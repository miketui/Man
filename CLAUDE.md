# CLAUDE CODE CUSTOM QA WORKFLOW FOR THIS REPOSITORY

This file is customized for **miketui/Man** to enable comprehensive project analysis, quality assurance, and ebook/manuscript processing using Claude Code and recommended MCP server orchestration.

---

## 1. Getting Started

Install Claude Code globally and start your session:

```bash
npm install -g @anthropic-ai/claude-code
claude
```

---

## 2. Repository-Specific Setup

### Project Structure

Review your repo for:
- Manuscript source files (`.xhtml`, `.epub`, `.md`, etc.)
- Scripts for build/validation (bash, Python, Node, etc.)
- Automation or workflow-related files
- Any files for ebook, EPUB, or manuscript processing

Run this to see all files and folders:

```bash
ls -R
```

---

## 3. Essential Claude & MCP Commands

| Command              | Description                                 |
|----------------------|---------------------------------------------|
| `/terminal-setup`    | Enable shift+enter for multiline input      |
| `/init`              | Create claude.md and enable memory          |
| `/theme`             | Toggle dark/light mode                      |
| `/install-github-app`| Set up GitHub Actions                       |
| `/commit`            | Conventional commits with emojis            |
| `/analyze-code`      | Review code and suggest improvements        |
| `/create-pr`         | Create pull requests with formatting        |

---

## 4. Recommended MCP Server Integration

Connect these MCPs for best QA and automation in this repo:

- **filesystem**: File access (read/write/scan)
- **sqlite**: Store QA results and validation data
- **memory**: Agent handoff and shared state
- **playwright**: Browser automation for validation/testing
- **github**: Automated PRs, issue tracking, and CI/CD
- **brave-search**: Fact-checking, external lookup
- **terragonnmcp**: Documentation and consistency queries

Sample MCP add:
```bash
claude mcp add --transport http github https://mcp.github.com/mcp
```

---

## 5. Master Quality Assurance & Orchestration Workflow

### Launch This Custom QA Pipeline

**Initial Setup**
```bash
./setup_xhtml_environment.sh
```
(Create this script if not present. It should prep your environment and ensure dependencies for validation.)

---

**Orchestration Prompt**  
Paste this into Claude Code or your MCP orchestrator:

```text
XHTML/EPUB MANUSCRIPT QUALITY ASSURANCE ORCHESTRATOR

1. VALIDATION AGENT:
   - Parse all `.xhtml`, `.epub`, and related files in the repo
   - Validate structure (W3C, EPUBCheck, or simulate if no `.epub`)
   - Store results in SQLite: validation_results
   - Memory handoff: validation_all_files_complete

2. FACT-CHECK AGENT:
   - Extract and verify factual claims using brave-search
   - Integrate with validation findings
   - Store in SQLite: factcheck_results
   - Memory handoff: factcheck_all_files_complete

3. CONSISTENCY ANALYSIS AGENT:
   - Analyze semantic/style/structural consistency
   - Use documentation patterns via terragonnmcp if configured
   - Store in SQLite: consistency_analysis
   - Memory handoff: consistency_all_files_complete

4. FINAL INTEGRATION AGENT:
   - Synthesize findings and generate a comprehensive QA report
   - Prioritize fixes, assess EPUB readiness, and output final recommendations
   - Store in GitHub (report), update processing_state
```

---

## 6. Custom Validation & QA Checklist

- [ ] Identify all manuscript and automation files in the repo
- [ ] Run EPUBCheck/structural validation (or simulate if no `.epub`)
- [ ] Run accessibility and metadata checks (ACE, manual, or with scripts)
- [ ] Cross-link any scripts/automation for build and validation
- [ ] Use MCP servers as described above
- [ ] Generate a consolidated report and actionable fix recommendations

---

## 7. Final Quality Assurance (with Claude Code)

- Use `/analyze-code` to review specific files or folders.
- Use `/commit` to document and stage fixes.
- Use `/create-pr` to submit your QA improvements as a pull request.
- For advanced orchestration, run the **Master QA Workflow** above.

---

## 8. Resources

- [Anthropic Documentation](https://docs.anthropic.com)
- [EPUBCheck](https://github.com/w3c/epubcheck)
- [ACE by DAISY](https://inclusivepublishing.org/toolbox/ace/)
- [MCP Protocol](https://github.com/modelcontextprotocol)
- [Terragon Orchestration](https://github.com/terragonn/terragon)
- [Book Publishing QA Guide](https://github.com/anthropics/quickstarts)

---

*This claude.md is customized for full-stack quality assurance, manuscript analysis, and automated workflow execution in the miketui/Man repository. Adapt as needed for your specific file structure and workflow!*
