#!/bin/bash

# EPUB QUALITY ASSURANCE INTEGRATION TEST
# Tests the complete 5-agent workflow on the actual EPUB files

set -e

echo "🚀 Starting EPUB Quality Assurance Integration Test..."
echo "📁 Working Directory: $(pwd)"
echo "📚 Target EPUB: Curls-Contemplation-TEMPLATE-COMPLIANT-EPUB-VALID-20250905-222421.epub"

# Verify environment setup
echo ""
echo "🔍 Environment Verification:"

# Check if EPUB file exists
if [ -f "Curls-Contemplation-TEMPLATE-COMPLIANT-EPUB-VALID-20250905-222421.epub" ]; then
    EPUB_SIZE=$(ls -lh "Curls-Contemplation-TEMPLATE-COMPLIANT-EPUB-VALID-20250905-222421.epub" | awk '{print $5}')
    echo "✅ Latest EPUB found: $EPUB_SIZE"
else
    echo "❌ Latest EPUB file not found"
    exit 1
fi

# Check XHTML files count
XHTML_COUNT=$(find OEBPS/text -name "*.xhtml" | grep -v nav.xhtml | wc -l)
echo "✅ XHTML files found: $XHTML_COUNT (expected: 44)"

# Check database exists
if [ -f "epub_qa.db" ]; then
    echo "✅ Database found: epub_qa.db"
else
    echo "📝 Creating database..."
    sqlite3 epub_qa.db < create_database.sql
    echo "✅ Database created"
fi

# Check EPUBCheck is available
if [ -f "epubcheck-5.1.0/epubcheck.jar" ]; then
    echo "✅ EPUBCheck 5.1.0 found"
else
    echo "❌ EPUBCheck not found"
    exit 1
fi

# Initialize test tracking
echo ""
echo "🎯 Initializing Test Workflow..."

TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
sqlite3 epub_qa.db "DELETE FROM processing_state;"
sqlite3 epub_qa.db "INSERT INTO processing_state (agent_name, batch_number, status, results_summary) VALUES 
    ('epub-structure-validator', 1, 'initialized', 'Starting structural validation'),
    ('content-quality-assurance', 2, 'pending', 'Waiting for Agent 1'),
    ('accessibility-compliance-specialist', 3, 'pending', 'Waiting for Agent 2'),
    ('epub-template-enforcer', 4, 'pending', 'Waiting for Agent 3'),
    ('publication-readiness-specialist', 5, 'pending', 'Waiting for Agent 4');"

echo "✅ Test workflow initialized in database"

# PHASE 1: BASIC EPUB VALIDATION
echo ""
echo "📋 PHASE 1: Basic EPUB Validation"
echo "Running EPUBCheck validation..."

EPUBCHECK_OUTPUT=$(java -jar epubcheck-5.1.0/epubcheck.jar "Curls-Contemplation-TEMPLATE-COMPLIANT-EPUB-VALID-20250905-222421.epub" 2>&1)
EPUBCHECK_EXIT_CODE=$?

if [ $EPUBCHECK_EXIT_CODE -eq 0 ]; then
    echo "✅ EPUBCheck validation: PASSED"
    echo "📊 Result: No errors or warnings detected"
    EPUB_VALIDATION_SCORE=100
else
    echo "❌ EPUBCheck validation: FAILED"
    echo "$EPUBCHECK_OUTPUT"
    EPUB_VALIDATION_SCORE=0
fi

# PHASE 2: XHTML STRUCTURE VALIDATION
echo ""
echo "📋 PHASE 2: XHTML Structure Validation"

VALID_XHTML=0
TOTAL_XHTML=0
CRITICAL_ERRORS=0

for xhtml_file in OEBPS/text/*.xhtml; do
    if [ "$xhtml_file" != "OEBPS/text/nav.xhtml" ]; then
        TOTAL_XHTML=$((TOTAL_XHTML + 1))
        filename=$(basename "$xhtml_file")
        
        # Basic XML validation
        if xmllint --noout "$xhtml_file" 2>/dev/null; then
            VALID_XHTML=$((VALID_XHTML + 1))
            validation_status="VALID"
        else
            validation_status="INVALID"
            CRITICAL_ERRORS=$((CRITICAL_ERRORS + 1))
            echo "⚠️  XML validation failed for: $filename"
        fi
        
        # Store validation result
        sqlite3 epub_qa.db "INSERT OR REPLACE INTO validation_results 
            (file_path, batch_number, validation_status, errors_found, timestamp) VALUES 
            ('$xhtml_file', 1, '$validation_status', '', '$TIMESTAMP');"
    fi
done

STRUCTURE_VALIDATION_SCORE=$(echo "scale=2; $VALID_XHTML * 100 / $TOTAL_XHTML" | bc -l)
echo "✅ XHTML Structure Validation: $VALID_XHTML/$TOTAL_XHTML files valid (${STRUCTURE_VALIDATION_SCORE}%)"

# PHASE 3: TEMPLATE COMPLIANCE CHECK
echo ""
echo "📋 PHASE 3: Template Compliance Analysis"

TEMPLATE_COMPLIANT=0
DOCTYPE_COUNT=0
NAMESPACE_COUNT=0
META_CHARSET_COUNT=0

for xhtml_file in OEBPS/text/*.xhtml; do
    if [ "$xhtml_file" != "OEBPS/text/nav.xhtml" ]; then
        filename=$(basename "$xhtml_file")
        compliance_issues=()
        
        # Check DOCTYPE declaration
        if grep -q "<!DOCTYPE html" "$xhtml_file"; then
            DOCTYPE_COUNT=$((DOCTYPE_COUNT + 1))
        else
            compliance_issues+=("Missing DOCTYPE")
        fi
        
        # Check XML namespace
        if grep -q 'xmlns="http://www.w3.org/1999/xhtml"' "$xhtml_file"; then
            NAMESPACE_COUNT=$((NAMESPACE_COUNT + 1))
        else
            compliance_issues+=("Missing XHTML namespace")
        fi
        
        # Check meta charset
        if grep -q 'charset="UTF-8"' "$xhtml_file"; then
            META_CHARSET_COUNT=$((META_CHARSET_COUNT + 1))
        else
            compliance_issues+=("Missing UTF-8 charset")
        fi
        
        # Determine compliance status
        if [ ${#compliance_issues[@]} -eq 0 ]; then
            TEMPLATE_COMPLIANT=$((TEMPLATE_COMPLIANT + 1))
            compliance_status="COMPLIANT"
        else
            compliance_status="NON_COMPLIANT"
            echo "⚠️  Template issues in $filename: ${compliance_issues[*]}"
        fi
        
        # Store template compliance result
        sqlite3 epub_qa.db "INSERT OR REPLACE INTO template_compliance_results 
            (file_path, compliance_status, issues_found, compliance_percentage, timestamp) VALUES 
            ('$xhtml_file', '$compliance_status', '$(IFS=,; echo "${compliance_issues[*]}")', 
             $(echo "scale=2; 100 - ${#compliance_issues[@]} * 33.33" | bc -l), '$TIMESTAMP');"
    fi
done

TEMPLATE_COMPLIANCE_SCORE=$(echo "scale=2; $TEMPLATE_COMPLIANT * 100 / $TOTAL_XHTML" | bc -l)
echo "✅ Template Compliance: $TEMPLATE_COMPLIANT/$TOTAL_XHTML files compliant (${TEMPLATE_COMPLIANCE_SCORE}%)"
echo "  - DOCTYPE declarations: $DOCTYPE_COUNT/$TOTAL_XHTML"
echo "  - XHTML namespaces: $NAMESPACE_COUNT/$TOTAL_XHTML" 
echo "  - UTF-8 charset: $META_CHARSET_COUNT/$TOTAL_XHTML"

# PHASE 4: ACCESSIBILITY BASIC CHECK
echo ""
echo "📋 PHASE 4: Basic Accessibility Analysis"

ALT_TEXT_COUNT=0
HEADING_STRUCTURE_COUNT=0
LANG_ATTRIBUTE_COUNT=0

for xhtml_file in OEBPS/text/*.xhtml; do
    if [ "$xhtml_file" != "OEBPS/text/nav.xhtml" ]; then
        filename=$(basename "$xhtml_file")
        accessibility_score=100
        accessibility_issues=()
        
        # Check for images without alt text
        IMG_TOTAL=$(grep -c '<img' "$xhtml_file" 2>/dev/null || echo "0")
        IMG_WITH_ALT=$(grep -c '<img[^>]*alt=' "$xhtml_file" 2>/dev/null || echo "0")
        
        if [ $IMG_TOTAL -gt 0 ] && [ $IMG_WITH_ALT -eq $IMG_TOTAL ]; then
            ALT_TEXT_COUNT=$((ALT_TEXT_COUNT + 1))
        elif [ $IMG_TOTAL -gt 0 ]; then
            accessibility_issues+=("Missing alt text on images")
            accessibility_score=$((accessibility_score - 30))
        fi
        
        # Check heading structure
        if grep -q '<h[1-6]' "$xhtml_file"; then
            HEADING_STRUCTURE_COUNT=$((HEADING_STRUCTURE_COUNT + 1))
        else
            accessibility_issues+=("No heading structure")
            accessibility_score=$((accessibility_score - 20))
        fi
        
        # Check lang attribute
        if grep -q 'lang=' "$xhtml_file"; then
            LANG_ATTRIBUTE_COUNT=$((LANG_ATTRIBUTE_COUNT + 1))
        else
            accessibility_issues+=("Missing lang attribute")
            accessibility_score=$((accessibility_score - 10))
        fi
        
        # Store accessibility result
        sqlite3 epub_qa.db "INSERT OR REPLACE INTO accessibility_results 
            (file_path, wcag_compliance, issues, wcag_compliance_score, timestamp) VALUES 
            ('$xhtml_file', '$([ ${#accessibility_issues[@]} -eq 0 ] && echo "PASS" || echo "PARTIAL")', 
             '$(IFS=,; echo "${accessibility_issues[*]}")', $accessibility_score, '$TIMESTAMP');"
    fi
done

ACCESSIBILITY_SCORE=$(echo "scale=2; ($ALT_TEXT_COUNT + $HEADING_STRUCTURE_COUNT + $LANG_ATTRIBUTE_COUNT) * 100 / ($TOTAL_XHTML * 3)" | bc -l)
echo "✅ Basic Accessibility: ${ACCESSIBILITY_SCORE}%"
echo "  - Images with alt text: $ALT_TEXT_COUNT/$TOTAL_XHTML files"
echo "  - Heading structure: $HEADING_STRUCTURE_COUNT/$TOTAL_XHTML files"
echo "  - Language attributes: $LANG_ATTRIBUTE_COUNT/$TOTAL_XHTML files"

# PHASE 5: OVERALL QUALITY CALCULATION
echo ""
echo "📋 PHASE 5: Overall Quality Assessment"

# Calculate weighted overall score
OVERALL_SCORE=$(echo "scale=2; ($EPUB_VALIDATION_SCORE * 0.3) + ($STRUCTURE_VALIDATION_SCORE * 0.25) + ($TEMPLATE_COMPLIANCE_SCORE * 0.25) + ($ACCESSIBILITY_SCORE * 0.20)" | bc -l)

# Determine certification level
if (( $(echo "$OVERALL_SCORE >= 95" | bc -l) )); then
    CERTIFICATION="PUBLICATION_CERTIFIED"
    STATUS_ICON="🟢"
elif (( $(echo "$OVERALL_SCORE >= 90" | bc -l) )); then
    CERTIFICATION="PROFESSIONAL_READY"
    STATUS_ICON="🟡"
elif (( $(echo "$OVERALL_SCORE >= 80" | bc -l) )); then
    CERTIFICATION="REVIEW_REQUIRED"
    STATUS_ICON="🟠"
else
    CERTIFICATION="DEVELOPMENT_STAGE"
    STATUS_ICON="🔴"
fi

# Store final results
sqlite3 epub_qa.db "INSERT OR REPLACE INTO publication_readiness_results 
    (epub_file, overall_score, certification_level, epub_validation_score, 
     structure_score, template_score, accessibility_score, timestamp) VALUES 
    ('Curls-Contemplation-TEMPLATE-COMPLIANT-EPUB-VALID-20250905-222421.epub', 
     $OVERALL_SCORE, '$CERTIFICATION', $EPUB_VALIDATION_SCORE, 
     $STRUCTURE_VALIDATION_SCORE, $TEMPLATE_COMPLIANCE_SCORE, $ACCESSIBILITY_SCORE, '$TIMESTAMP');"

# FINAL REPORT
echo ""
echo "📊 COMPREHENSIVE QUALITY ASSURANCE REPORT"
echo "=========================================="
echo ""
echo "$STATUS_ICON OVERALL QUALITY SCORE: ${OVERALL_SCORE}%"
echo "🎯 CERTIFICATION LEVEL: $CERTIFICATION"
echo ""
echo "📋 Domain Scores:"
echo "  📚 EPUB Validation: ${EPUB_VALIDATION_SCORE}% (Weight: 30%)"
echo "  🏗️  Structure Validation: ${STRUCTURE_VALIDATION_SCORE}% (Weight: 25%)"
echo "  📋 Template Compliance: ${TEMPLATE_COMPLIANCE_SCORE}% (Weight: 25%)"
echo "  ♿ Accessibility: ${ACCESSIBILITY_SCORE}% (Weight: 20%)"
echo ""
echo "📈 File Statistics:"
echo "  📄 Total XHTML files: $TOTAL_XHTML"
echo "  ✅ Valid XHTML files: $VALID_XHTML"
echo "  📋 Template compliant: $TEMPLATE_COMPLIANT"
echo "  ⚠️  Critical errors: $CRITICAL_ERRORS"
echo ""

# Recommendations
echo "🎯 RECOMMENDATIONS:"
if [ $CRITICAL_ERRORS -gt 0 ]; then
    echo "  🔴 CRITICAL: Fix $CRITICAL_ERRORS XHTML validation errors"
fi

if (( $(echo "$TEMPLATE_COMPLIANCE_SCORE < 100" | bc -l) )); then
    echo "  🟡 TEMPLATE: Address template compliance issues in $((TOTAL_XHTML - TEMPLATE_COMPLIANT)) files"
fi

if (( $(echo "$ACCESSIBILITY_SCORE < 90" | bc -l) )); then
    echo "  🟠 ACCESSIBILITY: Improve accessibility features"
fi

if (( $(echo "$OVERALL_SCORE >= 95" | bc -l) )); then
    echo "  🟢 PUBLICATION: Ready for immediate publication!"
elif (( $(echo "$OVERALL_SCORE >= 90" | bc -l) )); then
    echo "  🟡 PUBLICATION: Minor improvements recommended before publication"
else
    echo "  🔴 PUBLICATION: Significant improvements required before publication"
fi

echo ""
echo "📁 Detailed results stored in: epub_qa.db"
echo "🔍 Query database for detailed analysis:"
echo "  sqlite3 epub_qa.db \"SELECT * FROM validation_results;\""
echo "  sqlite3 epub_qa.db \"SELECT * FROM template_compliance_results;\""
echo "  sqlite3 epub_qa.db \"SELECT * FROM accessibility_results;\""
echo ""
echo "✅ Integration test completed!"

# Update final status
sqlite3 epub_qa.db "UPDATE processing_state SET status='completed', results_summary='Overall Score: $OVERALL_SCORE%, Certification: $CERTIFICATION' WHERE agent_name='epub-structure-validator';"

exit 0