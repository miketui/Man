# MASTER XHTML PROCESSING ORCHESTRATION PROMPT

## Initial Setup Command
**Run this first:** `./setup_xhtml_environment.sh`

## Master Orchestration Prompt

```
XHTML MANUSCRIPT PROCESSING ORCHESTRATOR

You are the master orchestrator for processing 44 XHTML files using sequential agent workflow with MCP server coordination. You will launch and coordinate 4 specialized agents in sequence, with each agent processing ALL 44 files for their specialty while building upon the previous agent's work.

INFRASTRUCTURE:
- SQLite Database: ./xhtml_processing.db (shared state storage)
- Memory Store: ./chain_memory (inter-agent communication)
- File System: ./xhtml_files/ (44 XHTML files to process)
- MCP Servers: filesystem, brave-search, sqlite, playwright, memory, github, terragonnmcp

SEQUENTIAL WORKFLOW:
Launch agents in this exact sequence, waiting for each to complete before launching the next:

AGENT 1: VALIDATION SPECIALIST
Launch Agent 1 with this prompt:

"VALIDATION AGENT - ALL FILES (Files 1-44)

You are a specialized XHTML validation agent with access to filesystem, playwright, and sqlite MCP servers.

PRIMARY MISSION: Validate ALL 44 XHTML files for structural integrity and W3C compliance.

EXECUTION SEQUENCE:
1. Use filesystem MCP to read ALL files ./xhtml_files/sample_01.xhtml through ./xhtml_files/sample_44.xhtml
2. For each file (1-44):
   - Parse XHTML structure
   - Validate against W3C XHTML 1.1 DTD
   - Use playwright MCP to automate W3C validator checks
   - Identify syntax errors, structural issues, accessibility problems
   - Rate severity: CRITICAL, HIGH, MEDIUM, LOW
3. Store results in sqlite MCP using this schema:
   INSERT INTO validation_results (file_path, batch_number, validation_status, errors_found, fix_suggestions)
4. Update processing state:
   INSERT INTO processing_state (agent_name, batch_number, status, results_summary) VALUES ('validation_agent', 1, 'completed', '[summary_of_all_44_files]')
5. Store handoff data in memory MCP:
   - Key: 'validation_all_files_complete'
   - Data: {files_processed: 44, critical_errors: [list], validation_summary: [detailed_stats], ready_for_factcheck: true}

DELIVERABLES:
- Complete validation report for ALL 44 files
- Critical error summary across entire manuscript
- File-by-file validation status
- Memory handoff for Agent 2

Execute this mission now and report completion status."

WAIT FOR AGENT 1 COMPLETION, then launch:

AGENT 2: FACT-CHECKING SPECIALIST
Launch Agent 2 with this prompt:

"FACT-CHECKING AGENT - ALL FILES (Files 1-44)

You are a specialized fact-checking agent with access to brave-search, memory, sqlite, and filesystem MCP servers.

PRIMARY MISSION: Fact-check content in ALL 44 XHTML files and integrate with Agent 1 validation results.

EXECUTION SEQUENCE:
1. Retrieve Agent 1 handoff from memory MCP: key 'validation_all_files_complete'
2. Query sqlite MCP for validation results: SELECT * FROM validation_results
3. Use filesystem MCP to read ALL files ./xhtml_files/sample_01.xhtml through ./xhtml_files/sample_44.xhtml
4. For each file (1-44):
   - Extract factual claims, dates, names, references, statistics
   - Use brave-search MCP to verify each claim against authoritative sources
   - Cross-reference with Agent 1 validation findings
   - Score confidence levels (0-100%) for each fact
   - Prioritize fact-checking based on Agent 1's critical errors
5. Store results in sqlite MCP:
   INSERT INTO factcheck_results (file_path, claim, verification_status, sources, confidence_score)
6. Update processing state:
   INSERT INTO processing_state (agent_name, batch_number, status, results_summary) VALUES ('factcheck_agent', 2, 'completed', '[summary_of_all_44_files]')
7. Store handoff data in memory MCP:
   - Key: 'factcheck_all_files_complete'
   - Data: {files_processed: 44, unverified_claims: [list], validation_integration: 'success', confidence_scores: [stats]}

DELIVERABLES:
- Fact-check report for ALL 44 files
- Source verification database
- Integrated findings from Agent 1 validation
- Confidence scoring across entire manuscript
- Memory handoff for Agent 3

Execute this mission now and report completion status."

WAIT FOR AGENT 2 COMPLETION, then launch:

AGENT 3: CONSISTENCY ANALYST
Launch Agent 3 with this prompt:

"CONSISTENCY ANALYSIS AGENT - ALL FILES (Files 1-44)

You are a specialized consistency analysis agent with access to all MCP servers including terragonnmcp for documentation queries.

PRIMARY MISSION: Analyze semantic consistency across ALL 44 XHTML files while integrating all previous agent findings.

EXECUTION SEQUENCE:
1. Retrieve handoffs from memory MCP:
   - 'validation_all_files_complete'
   - 'factcheck_all_files_complete'
2. Query sqlite MCP for all previous results:
   - SELECT * FROM validation_results
   - SELECT * FROM factcheck_results  
3. Use filesystem MCP to read ALL files ./xhtml_files/sample_01.xhtml through ./xhtml_files/sample_44.xhtml
4. Use terragonnmcp to query documentation patterns for consistency guidelines
5. For each file (1-44):
   - Analyze thematic consistency across entire manuscript
   - Cross-reference factual consistency with Agent 2 findings
   - Identify structural pattern consistency with Agent 1 findings
   - Detect contradictions, inconsistencies, gaps between files
   - Map narrative flow and logical progression
   - Check character/concept consistency throughout
6. Store results in sqlite MCP:
   INSERT INTO consistency_analysis (file_path, inconsistency_type, description, severity, cross_references)
7. Update processing state:
   INSERT INTO processing_state (agent_name, batch_number, status, results_summary) VALUES ('consistency_agent', 3, 'completed', '[summary_of_all_44_files]')
8. Store handoff data in memory MCP:
   - Key: 'consistency_all_files_complete'
   - Data: {files_processed: 44, consistency_score: [overall], critical_issues: [list], manuscript_flow: [analysis]}

DELIVERABLES:
- Consistency analysis report for ALL 44 files
- Cross-file discrepancy identification
- Narrative flow analysis
- Thematic consistency mapping
- Integrated analysis of validation + fact-checking + consistency
- Memory handoff for Agent 4

Execute this mission now and report completion status."

WAIT FOR AGENT 3 COMPLETION, then launch:

AGENT 4: FINAL INTEGRATION SPECIALIST
Launch Agent 4 with this prompt:

"FINAL INTEGRATION AGENT - ALL FILES (Files 1-44)

You are the final integration specialist responsible for creating the comprehensive manuscript analysis and final deliverables.

PRIMARY MISSION: Integrate all agent findings and create final analysis for all 44 files.

EXECUTION SEQUENCE:
1. Retrieve all handoffs from memory MCP:
   - 'validation_all_files_complete'
   - 'factcheck_all_files_complete'  
   - 'consistency_all_files_complete'
2. Query sqlite MCP for complete dataset:
   - SELECT * FROM validation_results
   - SELECT * FROM factcheck_results
   - SELECT * FROM consistency_analysis
   - SELECT * FROM processing_state
3. Use filesystem MCP to re-analyze ALL files ./xhtml_files/sample_01.xhtml through ./xhtml_files/sample_44.xhtml with complete context
4. Synthesize all findings into comprehensive analysis:
   - Prioritize fixes based on validation + fact-checking + consistency severity
   - Create manuscript improvement roadmap
   - Generate EPUB readiness assessment
5. Use playwright MCP for final EPUB compilation testing
6. Use github MCP to create comprehensive report repository
7. Generate final deliverables:
   - Complete validation status for all 44 files
   - Fact-check verification summary with confidence scores
   - Consistency analysis across entire manuscript
   - EPUB readiness assessment
   - Prioritized fix recommendations (critical → low priority)
   - Manuscript quality score and improvement metrics
8. Store final results and update processing_state to 'workflow_complete'

DELIVERABLES:
- Complete manuscript integrity report (all 44 files)
- EPUB validation status
- Prioritized action items with severity rankings
- Quality metrics and improvement recommendations
- GitHub repository with all findings
- Executive summary for manuscript finalization

Execute this mission now and report final completion status."

ORCHESTRATOR COMPLETION:
After all 4 agents complete, generate a summary report showing:
- Total files processed: 44 (by all 4 agents)
- Validation status overview (all files)
- Fact-check completion rate (all files)
- Consistency score (entire manuscript)
- EPUB readiness (complete assessment)
- Next steps for manuscript finalization

Execute this orchestration workflow now.
```

## Usage Instructions

1. **Setup Environment:**
   ```bash
   ./setup_xhtml_environment.sh
   ```

2. **Configure MCP Servers:**
   - Copy the JSON configuration to your Terragon environment
   - Update .env file with your API keys

3. **Launch Workflow:**
   - Paste the Master Orchestration Prompt into Terragon
   - The system will automatically launch agents sequentially
   - Each agent processes ALL 44 files for their specialty
   - Each agent builds upon previous agent findings

4. **Monitor Progress:**
   - Check `./workflow_status.json` for current status
   - Query SQLite database for detailed results
   - Review memory store for inter-agent handoffs

## Workflow Summary
- **Agent 1**: Validates ALL 44 files → Stores validation results
- **Agent 2**: Fact-checks ALL 44 files → Integrates with validation findings  
- **Agent 3**: Analyzes consistency across ALL 44 files → Integrates with validation + fact-check
- **Agent 4**: Final integration of ALL findings → Creates comprehensive report

Each agent processes the complete manuscript while specializing in their domain expertise.