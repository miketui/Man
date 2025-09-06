# Curls & Contemplation EPUB Generation Project - Project Documentation

## 1. Project Overview

This repository contains the complete production system for "Curls & Contemplation: A Stylist's Interactive Journey Journal" - a professional development book for hairstylists. The project focuses on creating publication-ready EPUB 3.3 files with comprehensive quality assurance, accessibility compliance, and template enforcement. It includes advanced AI-assisted workflows using Claude Code for manuscript validation, fact-checking, and professional publishing standards.

## 2. Directory Structure

```
/home/runner/work/Man/Man/
├── epub_work/                          # Main EPUB content structure
│   ├── OEBPS/                         # Open eBook Publication Structure
│   │   ├── text/                      # 44 XHTML chapter files
│   │   ├── styles/                    # CSS stylesheets
│   │   ├── fonts/                     # Web fonts (Montserrat, Libre Baskerville)
│   │   ├── images/                    # Book images and graphics
│   │   └── content.opf                # Package document
│   ├── META-INF/
│   │   └── container.xml              # Container information
│   └── mimetype                       # EPUB mimetype declaration
├── .claude/                           # Claude Code AI agent configurations
│   └── agents/                        # Specialized AI agents for QA
├── xhtml_files/                       # Template XHTML files (44 files)
├── chain_memory/                      # Inter-agent communication storage
├── qa-reports/                        # Quality assurance reports
├── backups/                           # File backups and versioning
├── create_final_epub.py               # Main EPUB generation script
├── rebuild_epub.py                    # EPUB rebuilding utility
├── template_fixer.py                  # Template compliance enforcement
├── unified_setup.sh                   # Environment setup script
├── CLAUDE.md                          # Claude Code workflow documentation
├── README.md                          # Project team guide
└── *.epub                            # Generated EPUB files (multiple versions)
```

## 3. Tech Stack

* **Primary Language:** Python 3.12.3
* **Content Format:** XHTML 1.1, CSS 3, EPUB 3.3
* **Fonts:** Google Fonts (Cinzel Decorative, Libre Baskerville, Montserrat)
* **Validation:** EPUBCheck 5.1.0, W3C validators
* **AI Integration:** Claude Code with MCP servers
* **Automation:** Bash shell scripts, Python automation
* **Version Control:** Git with GitHub Actions workflows
* **Database:** SQLite (for QA orchestration)
* **Compliance:** WCAG 2.1 Level AA, EPUB Accessibility 1.1, EU Accessibility Act

## 4. Setup and Installation

### 4.1. Prerequisites

* Python 3.12+ 
* Bash shell environment
* Git
* SQLite3 (optional, for advanced QA features)
* Node.js and npm (for MCP server integration)

### 4.2. Installation

**Quick Setup (Standard Environment):**
```bash
# Clone and setup
git clone <repository-url>
cd Man

# Run unified setup script
chmod +x unified_setup.sh
./unified_setup.sh
```

**Claude Code Integration Setup:**
```bash
# Install Claude Code (if using AI assistance)
npm install -g @anthropic-ai/claude-code

# Setup MCP servers for advanced QA
./test_mcp_integration.sh
```

**Manual Environment Setup:**
```bash
# Create required directories
mkdir -p chain_memory xhtml_files qa-reports

# Initialize database (optional)
sqlite3 epub_qa.db < create_database.sql

# Setup XHTML environment
./setup_xhtml_environment.sh
```

### 4.3. Configuration

**Environment Variables (.env):**
```bash
PROJECT_NAME="Curls & Contemplation"
EPUB_OUTPUT_DIR="./output"
VALIDATION_LEVEL="strict"
```

**Claude Code Configuration (claude_desktop_config.json):**
Available for MCP server integration with filesystem, memory, and validation tools.

## 5. Available Scripts

### 5.1. EPUB Generation
* `python3 create_final_epub.py` - Creates production-ready EPUB with full metadata
* `python3 rebuild_epub.py` - Rebuilds EPUB from source files with validation
* `python3 epub_font_fixer.py` - Fixes font references and embedding

### 5.2. Quality Assurance & Validation
* `python3 simple_compliance_check.py` - Quick compliance validation
* `python3 template_compliance_analysis.py` - Comprehensive template analysis
* `python3 template_fixer.py` - Automated template compliance fixes
* `./validate-xml.sh` - XML/XHTML structure validation

### 5.3. Setup & Environment
* `./unified_setup.sh` - Complete environment setup (recommended)
* `./setup_xhtml_environment.sh` - XHTML-specific environment setup
* `./terragon_setup.sh` - Terragon platform specific setup
* `./test_mcp_integration.sh` - Test MCP server connectivity

### 5.4. Utilities
* `./add_landmarks.sh` - Add accessibility landmarks to XHTML files
* `./fix_epub_namespace.sh` - Fix EPUB namespace declarations

## 6. Coding Conventions

### 6.1. XHTML Chapter Structure
* **Template Compliance**: All 44 chapter files must use exact template structure from `chapter-template.html`
* **Variable Replacement**: Use Mustache-style variables (`{{VARIABLE}}`) consistently
* **Semantic HTML**: Use proper heading hierarchy (h1 > h2 > h3) and semantic elements
* **Accessibility**: Include alt text for images, proper ARIA labels, and landmark roles

### 6.2. Python Code Style
* Follow PEP 8 standards
* Use descriptive function names and docstrings
* Include error handling for file operations
* Maintain backwards compatibility with Python 3.12+

### 6.3. File Organization
* **XHTML files**: Numbered sequentially (01-44) with descriptive names
* **Backup strategy**: Automatic backups before template fixes
* **Version control**: Descriptive commit messages for content changes

## 7. Important Notes

### 7.1. EPUB Quality Standards
* **Validation**: Must pass EPUBCheck 5.1.0 with zero errors/warnings
* **Accessibility**: WCAG 2.1 Level AA compliance required for EU market
* **Metadata**: Enhanced Dublin Core metadata for discoverability
* **File size**: Target <2.5MB for optimal distribution compatibility

### 7.2. AI-Assisted Workflows
* **Claude Code Integration**: Four specialized agents for validation, accessibility, content analysis, and EPUB generation
* **MCP Servers**: filesystem, memory, sqlite, playwright for automated testing
* **Quality Orchestration**: Sequential agent workflow for comprehensive QA

### 7.3. Publication Targets
* **Amazon KDP**: A10 algorithm optimization with strategic keywords
* **Apple Books**: Enhanced typography and interactive features
* **Kobo**: Global market considerations
* **Libraries**: OverDrive compatibility and accessibility features

### 7.4. Content Management
* **44 Chapter Structure**: Fixed sequence from Title Page through Bibliography
* **Interactive Elements**: Worksheets, quizzes, and journal pages
* **Professional Standards**: Consistent formatting, navigation, and branding

### 7.5. Template Enforcement
* **Critical Requirement**: Every chapter must use identical HTML structure
* **No Style Modifications**: Preserve CSS, JavaScript, and layout integrity
* **Variable System**: Systematic content replacement using Mustache variables
* **Conditional Sections**: Proper handling of optional content blocks

### 7.6. Deployment & Distribution
* **GitHub Actions**: Automated validation and quality checks
* **Multiple Formats**: Various EPUB versions for different distribution channels
* **Backup Strategy**: Comprehensive file versioning and recovery systems

### 7.7. Current EPUB Status
* **Working File**: `Curls-Contemplation-WORKING-EPUB-20250905.epub` - Main development version
* **Validation Status**: All EPUBs pass EPUBCheck 5.1.0 validation with zero errors
* **File Count**: 45 XHTML files (44 content + 1 navigation)
* **Production Ready**: Multiple validated versions available for distribution
* **Size Optimization**: Target achieved at ~2.15 MB for optimal compatibility