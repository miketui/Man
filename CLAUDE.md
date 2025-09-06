# CLAUDE CODE CUSTOM QA WORKFLOW FOR EPUB GENERATION

This file is customized for **comprehensive EPUB quality assurance** enabling professional manuscript analysis, validation, and bestseller-quality publication using Claude Code with advanced MCP server orchestration.

---

## 1. Quick Start & Setup

### Install Claude Code
```bash
npm install -g @anthropic-ai/claude-code
claude
```

### Essential Commands Setup
```bash
/terminal-setup     # Enable shift+enter
/init              # Create claude.md and enable memory
/theme             # Toggle dark/light mode
/install-github-app # Set up GitHub Actions
```

### Repository Analysis
```bash
# Scan your project structure
ls -R

# Identify manuscript files
find . -name "*.xhtml" -o -name "*.epub" -o -name "*.md" -o -name "*.html"
```

---

## 2. MCP Server Integration & Configuration

### Essential MCP Servers for EPUB QA
```bash
# Core validation and automation
claude mcp add filesystem npx @modelcontextprotocol/server-filesystem
claude mcp add playwright npx @playwright/mcp@latest
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# Quality assurance and fact-checking
claude mcp add puppeteer -s user -- npx -y @modelcontextprotocol/server-puppeteer
claude mcp add --transport http context7 https://mcp.context7.com/mcp

# Database and memory for orchestration
claude mcp add sqlite npx @modelcontextprotocol/server-sqlite
claude mcp add memory npx @modelcontextprotocol/server-memory
```

### MCP Configuration for Professional Workflows
```json
{
  "mcpServers": {
    "sentry": {
      "command": "npx",
      "args": ["@sentry/mcp-server"],
      "env": {
        "SENTRY_DSN": "your-project-dsn"
      }
    },
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem"],
      "args": ["/path/to/epub/project"]
    }
  }
}
```

---

## 3. Master Quality Assurance Orchestration Workflow

### Initial Environment Setup
```bash
# Create this script in your project root
./setup_xhtml_environment.sh
```

### Complete QA Orchestration Prompt

**Copy and paste this into Claude Code for full automation:**

```text
XHTML/EPUB MANUSCRIPT QUALITY ASSURANCE ORCHESTRATOR

You are the master orchestrator for processing manuscript files using sequential agent workflow with MCP server coordination. Launch 4 specialized agents in sequence, with each building upon previous work.

INFRASTRUCTURE:
- SQLite Database: ./epub_qa.db (shared state storage)
- Memory Store: ./chain_memory (inter-agent communication)  
- File System: ./src/ or ./manuscripts/ (source files)
- MCP Servers: filesystem, sentry, playwright, sqlite, memory

SEQUENTIAL WORKFLOW:

AGENT 1: VALIDATION SPECIALIST
Mission: Validate ALL manuscript files for EPUB 3.3 compliance and W3C standards

Process:
1. Use filesystem MCP to scan for .xhtml, .html, .epub files
2. For each file:
   - Parse XHTML/HTML structure
   - Validate against W3C XHTML 1.1 DTD using playwright
   - Run EPUBCheck simulation/validation
   - Check accessibility with automated tools
   - Rate severity: CRITICAL, HIGH, MEDIUM, LOW
3. Store results: INSERT INTO validation_results (file_path, validation_status, errors_found, fix_suggestions)
4. Memory handoff: 'validation_complete' with summary data

AGENT 2: ACCESSIBILITY & COMPLIANCE SPECIALIST  
Mission: Ensure WCAG 2.1 Level AA compliance and European Accessibility Act requirements

Process:
1. Retrieve validation results from Agent 1
2. For each file:
   - Check alt text for images
   - Verify color contrast ratios (4.5:1 minimum)
   - Test heading structure and navigation
   - Validate semantic markup
   - Simulate screen reader compatibility
3. Store results: INSERT INTO accessibility_results (file_path, wcag_compliance, issues, recommendations)
4. Memory handoff: 'accessibility_complete' with compliance status

AGENT 3: CONTENT & CONSISTENCY ANALYST
Mission: Verify factual accuracy and maintain consistency across manuscript

Process:
1. Retrieve previous agent results
2. For each file:
   - Extract factual claims, dates, references
   - Use context7/search tools for fact verification
   - Analyze cross-file consistency (characters, themes, terminology)
   - Check narrative flow and logical progression
   - Identify contradictions or gaps
3. Store results: INSERT INTO content_analysis (file_path, fact_check_status, consistency_score, issues)
4. Memory handoff: 'content_complete' with analysis summary

AGENT 4: EPUB GENERATION & FINAL QA
Mission: Generate publication-ready EPUB with comprehensive quality report

Process:
1. Integrate all previous findings
2. Generate EPUB package with corrected files
3. Run final EPUBCheck validation
4. Test cross-platform compatibility (simulate Kindle, Apple Books, etc.)
5. Generate marketing-ready metadata
6. Create comprehensive QA report with:
   - Validation status (pass/fail)
   - Accessibility compliance score
   - Content quality assessment
   - EPUB readiness certification
   - Prioritized fix recommendations

DELIVERABLE: Publication-ready EPUB + Complete QA documentation

Execute this orchestration workflow now.
```

---

## 4. Quick QA Commands

### Immediate Validation
```bash
# Quick EPUB structure check
/validate-structure

# Accessibility compliance scan  
/check-accessibility

# Content consistency analysis
/analyze-content

# Generate test EPUB
/create-epub-test
```

### Advanced Quality Assurance
```bash
# Complete manuscript processing
/process-manuscript

# Cross-platform compatibility test
/test-platforms [kindle|apple|kobo|all]

# Marketing metadata optimization
/optimize-metadata

# Performance analysis
/analyze-performance --detailed
```

---

## 5. Professional Publishing Checklist

### Pre-Publication Requirements
- [ ] EPUB 3.3 specification compliance (EPUBCheck 5.2.1)
- [ ] WCAG 2.1 Level AA accessibility (European Accessibility Act)
- [ ] Cross-platform testing (Kindle, Apple Books, Kobo, Adobe)
- [ ] Metadata optimization for discoverability
- [ ] Cover art meets platform requirements (1600x2400px minimum)
- [ ] Performance optimization (<2 second load time)

### Platform-Specific Optimization
- [ ] **Amazon KDP**: A10 algorithm optimization, keyword integration
- [ ] **Apple Books**: Enhanced typography, interactive features
- [ ] **Kobo**: Global market considerations, pricing strategy
- [ ] **Libraries**: OverDrive compatibility, accessibility features

### Quality Metrics Targets
- [ ] Structural Integrity: 100% pass rate
- [ ] Accessibility Score: WCAG 2.1 AA minimum
- [ ] Cross-Platform Compatibility: 95% consistency
- [ ] Performance Score: <2 second load time
- [ ] Metadata Optimization: 90%+ category relevance

---

## 6. Error Tracking & Issue Management

### Sentry Integration
All validation errors automatically tracked for:
- Centralized error monitoring across manuscript processing
- Issue prioritization (CRITICAL → LOW)
- Progress tracking through remediation
- Performance monitoring of validation workflows

### Issue Categories
- **CRITICAL**: Prevents EPUB generation or causes crashes
- **HIGH**: Affects accessibility or major platform compatibility
- **MEDIUM**: Minor formatting or metadata optimization
- **LOW**: Style preferences or performance improvements

---

## 7. Continuous Integration Workflow

### GitHub Actions Integration
```yaml
name: EPUB Quality Assurance
on: [push, pull_request]
jobs:
  qa-complete:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Claude Code
        run: npm install -g @anthropic-ai/claude-code
      - name: Run Complete QA
        run: claude /process-manuscript
      - name: Upload Results
        uses: actions/upload-artifact@v3
        with:
          name: qa-reports
          path: ./qa-reports/
```

### Pre-commit Hooks
```bash
# Install pre-commit validation
pre-commit install

# Auto-validate before commits
echo "claude /validate-structure" > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

---

## 8. Advanced Features & Customization

### Custom Validation Rules
Create `.claude/commands/` directory for project-specific commands:

```bash
mkdir -p .claude/commands

# Custom accessibility check
echo "Enhanced accessibility validation with project-specific requirements" > .claude/commands/accessibility-plus.md

# Custom EPUB optimization  
echo "Project-specific EPUB optimization for target platforms" > .claude/commands/optimize-epub.md
```

### Batch Processing
```bash
# Process multiple manuscripts
/batch-process --directory=./manuscripts

# Bulk validation
/validate-all --format=epub --output=validation-report.json

# Series consistency check
/check-series-consistency --books=book1,book2,book3
```

---

## 9. Troubleshooting & Support

### Common Issues & Solutions
- **Validation Failures**: Check XHTML syntax and DOCTYPE declarations
- **Accessibility Errors**: Review alt text, heading structure, color contrast  
- **Platform Incompatibility**: Test with platform-specific readers
- **Performance Issues**: Optimize images and CSS complexity

### Debug Commands
```bash
# Verbose validation output
/validate-structure --verbose --log-level=debug

# Detailed accessibility report
/check-accessibility --detailed --export=html

# Platform-specific testing
/test-platforms --platform=kindle --debug

# Performance profiling
/analyze-performance --profile --export=json
```

---

## 10. Resources & Documentation

### Essential Tools
- **EPUBCheck 5.2.1**: EPUB specification compliance
- **ACE by DAISY**: Accessibility validation  
- **W3C Validators**: HTML/CSS validation
- **Kindle Previewer**: Amazon platform testing
- **Apple Books Preview**: Apple platform testing

### Publishing Platforms
- [Amazon KDP](https://kdp.amazon.com) - 68-85% market share
- [Apple Books Connect](https://books.apple.com/us/) - Premium audience
- [Kobo Writing Life](https://www.kobo.com/us/en/p/writinglife) - Global reach
- [Draft2Digital](https://draft2digital.com) - Wide distribution

### Standards & Compliance
- [EPUB 3.3 Specification](https://www.w3.org/publishing/epub3/)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/)
- [European Accessibility Act](https://ec.europa.eu/social/main.jsp?catId=1202)

---

**This claude.md provides complete EPUB quality assurance from manuscript to bestseller-ready publication. Execute the Master QA Orchestration for full automation, or use individual commands for targeted improvements.**
