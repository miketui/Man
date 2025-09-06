#!/bin/bash

# Simple EPUB Validation Script
# Quick validation of EPUB files using EPUBCheck

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EPUBCHECK_JAR="$SCRIPT_DIR/epubcheck-5.1.0/epubcheck.jar"

echo "🔍 EPUB Validation Tool"
echo "======================="

# Function to validate a single EPUB
validate_epub() {
    local epub_file="$1"
    local filename=$(basename "$epub_file")
    
    echo -n "Validating $filename... "
    
    if ! [ -f "$epub_file" ]; then
        echo "❌ File not found"
        return 1
    fi
    
    # Run EPUBCheck and capture output
    if java -jar "$EPUBCHECK_JAR" "$epub_file" >/dev/null 2>&1; then
        echo "✅ VALID"
        return 0
    else
        echo "❌ INVALID"
        return 1
    fi
}

# Function to validate with details
validate_epub_detailed() {
    local epub_file="$1"
    local filename=$(basename "$epub_file")
    
    echo "Detailed validation for: $filename"
    echo "=================================="
    
    if ! [ -f "$epub_file" ]; then
        echo "❌ File not found: $epub_file"
        return 1
    fi
    
    java -jar "$EPUBCHECK_JAR" "$epub_file"
    echo ""
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 [OPTIONS] <epub-file(s)>"
    echo ""
    echo "Options:"
    echo "  --all          Validate all EPUB files in current directory"
    echo "  --detailed     Show detailed validation output"
    echo "  --quick        Quick validation (default)"
    echo ""
    echo "Examples:"
    echo "  $0 book.epub                    # Quick validation"
    echo "  $0 --detailed book.epub         # Detailed validation"
    echo "  $0 --all                        # Validate all EPUBs"
    echo "  $0 *.epub                       # Validate multiple files"
    exit 1
fi

# Check if EPUBCheck is available
if ! [ -f "$EPUBCHECK_JAR" ]; then
    echo "❌ EPUBCheck not found at: $EPUBCHECK_JAR"
    echo "Please ensure EPUBCheck 5.1.0 is installed in the epubcheck-5.1.0 directory"
    exit 1
fi

DETAILED=false
VALIDATE_ALL=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --detailed)
            DETAILED=true
            shift
            ;;
        --all)
            VALIDATE_ALL=true
            shift
            ;;
        --quick)
            DETAILED=false
            shift
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

# Handle --all option
if [ "$VALIDATE_ALL" = true ]; then
    epub_files=(*.epub)
    if [ ! -f "${epub_files[0]}" ]; then
        echo "❌ No EPUB files found in current directory"
        exit 1
    fi
else
    epub_files=("$@")
fi

echo "Found EPUBCheck 5.1.0"
echo "Starting validation..."
echo ""

valid_count=0
invalid_count=0
total_count=0

# Validate each file
for epub_file in "${epub_files[@]}"; do
    total_count=$((total_count + 1))
    
    if [ "$DETAILED" = true ]; then
        if validate_epub_detailed "$epub_file"; then
            valid_count=$((valid_count + 1))
        else
            invalid_count=$((invalid_count + 1))
        fi
    else
        if validate_epub "$epub_file"; then
            valid_count=$((valid_count + 1))
        else
            invalid_count=$((invalid_count + 1))
        fi
    fi
done

# Summary
echo ""
echo "📊 Validation Summary"
echo "===================="
echo "Total files: $total_count"
echo "✅ Valid: $valid_count"
echo "❌ Invalid: $invalid_count"

if [ $invalid_count -eq 0 ]; then
    echo ""
    echo "🎉 All EPUB files are valid and ready for publication!"
    exit 0
else
    echo ""
    echo "⚠️  Some files need fixes before publication"
    echo "   Use --detailed option to see specific errors"
    exit 1
fi