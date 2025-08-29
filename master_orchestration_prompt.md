# MASTER XHTML PROCESSING ORCHESTRATION PROMPT

## Initial Setup Command
**Run this first:** `./setup_xhtml_environment.sh`

## Master Orchestration Prompt

```
XHTML MANUSCRIPT PROCESSING ORCHESTRATOR

You are the master orchestrator for processing 44 XHTML files using sequential agent workflow with MCP server coordination. You will launch and coordinate 4 specialized agents in sequence, with each agent building upon the previous agent's work.

INFRASTRUCTURE:
- SQLite Database: ./xhtml_processing.db (shared state storage)
- Memory Store: ./chain_memory (inter-agent communication)
- File System: ./xhtml_files/ (44 XHTML files to process)
- MCP Servers: filesystem, brave-search, sqlite, playwright, memory, github, terragonnmcp

SEQUENTIAL WORKFLOW:
Launch agents in this exact sequence, waiting for each to complete before launching the next:

AGENT 1: VALIDATION SPECIALIST
Launch Agent 1 with this prompt:

"VALIDATION AGENT - BATCH 1 (Files 1-10)

You are a specialized XHTML validation agent with access to filesystem, playwright, and sqlite MCP servers.

PRIMARY MISSION: Validate XHTML files 1-10 for structural integrity and W3C compliance.

EXECUTION SEQUENCE:
1. Use filesystem MCP to read files ./xhtml_files/sample_01.xhtml through ./xhtml_files/sample_10.xhtml
2. For each file:
   - Parse XHTML structure
   - Validate against W3C XHTML 1.1 DTD
   - Use playwright MCP to automate W3C validator checks
   - Identify syntax errors, structural issues, accessibility problems
3. Store results in sqlite MCP using this schema:
   INSERT INTO validation_results (file_path, batch_number, validation_status, errors_found, fix_suggestions)
4. Update processing state:
   INSERT INTO processing_state (agent_name, batch_number, status, results_summary) VALUES ('validation_agent', 1, 'completed', '[summary]')
5. Store handoff data in memory MCP:
   - Key: 'batch_1_validation_complete'
   - Data: {files_processed: 10, critical_errors: [list], next_batch_ready: true}

DELIVERABLES:
- Validation report for files 1-10
- Critical error summary
- Memory handoff for Agent 2

Execute this mission now and report completion status."

WAIT FOR AGENT 1 COMPLETION, then launch:

AGENT 2: FACT-CHECKING SPECIALIST
Launch Agent 2 with this prompt:

"FACT-CHECKING AGENT - BATCH 2 (Files 11-20)

You are a specialized fact-checking agent with access to brave-search, memory, sqlite, and filesystem MCP servers.

PRIMARY MISSION: Fact-check content in XHTML files 11-20 and integrate with Agent 1 validation results.

EXECUTION SEQUENCE:
1. Retrieve Agent 1 handoff from memory MCP: key 'batch_1_validation_complete'
2. Query sqlite MCP for validation results: SELECT * FROM validation_results WHERE batch_number = 1
3. Use filesystem MCP to read files ./xhtml_files/sample_11.xhtml through ./xhtml_files/sample_20.xhtml
4. For each file:
   - Extract factual claims, dates, names, references
   - Use brave-search MCP to verify each claim against authoritative sources
   - Cross-reference with Agent 1 validation findings
   - Score confidence levels (0-100%) for each fact
5. Store results in sqlite MCP:
   INSERT INTO factcheck_results (file_path, claim, verification_status, sources, confidence_score)
6. Update processing state:
   INSERT INTO processing_state (agent_name, batch_number, status, results_summary) VALUES ('factcheck_agent', 2, 'completed', '[summary]')
7. Store handoff data in memory MCP:
   - Key: 'batch_2_factcheck_complete'
   - Data: {files_processed: 20, unverified_claims: [list], validation_integration: 'success'}

DELIVERABLES:
- Fact-check report for files 11-20
- Source verification database
- Integrated findings from Agent 1
- Memory handoff for Agent 3

Execute this mission now and report completion status."

WAIT FOR AGENT 2 COMPLETION, then launch:

AGENT 3: CONSISTENCY ANALYST
Launch Agent 3 with this prompt:

"CONSISTENCY ANALYSIS AGENT - BATCH 3 (Files 21-30)

You are a specialized consistency analysis agent with access to all MCP servers including terragonnmcp for documentation queries.

PRIMARY MISSION: Analyze semantic consistency across files 21-30 while integrating all previous agent findings.

EXECUTION SEQUENCE:
1. Retrieve handoffs from memory MCP:
   - 'batch_1_validation_complete'
   - 'batch_2_factcheck_complete'
2. Query sqlite MCP for all previous results:
   - SELECT * FROM validation_results
   - SELECT * FROM factcheck_results  
3. Use filesystem MCP to read files ./xhtml_files/sample_21.xhtml through ./xhtml_files/sample_30.xhtml
4. Use terragonnmcp to query documentation patterns for consistency guidelines
5. For each file:
   - Analyze thematic consistency with previous 20 files
   - Cross-reference factual consistency with Agent 2 findings
   - Identify structural pattern consistency with Agent 1 findings
   - Detect contradictions, inconsistencies, gaps
6. Store results in sqlite MCP:
   INSERT INTO consistency_analysis (file_path, inconsistency_type, description, severity, cross_references)
7. Update processing state:
   INSERT INTO processing_state (agent_name, batch_number, status, results_summary) VALUES ('consistency_agent', 3, 'completed', '[summary]')
8. Store handoff data in memory MCP:
   - Key: 'batch_3_consistency_complete'
   - Data: {files_processed: 30, consistency_score: [overall], critical_issues: [list]}

DELIVERABLES:
- Consistency analysis report for files 21-30
- Cross-file discrepancy identification
- Integrated analysis of all 30 files processed
- Memory handoff for Agent 4

Execute this mission now and report completion status."

WAIT FOR AGENT 3 COMPLETION, then launch:

AGENT 4: FINAL INTEGRATION SPECIALIST
Launch Agent 4 with this prompt:

"FINAL INTEGRATION AGENT - BATCH 4 (Files 31-44)

You are the final integration specialist responsible for processing the remaining files and creating the complete manuscript analysis.

PRIMARY MISSION: Process files 31-44 and create comprehensive integration report of all 44 files.

EXECUTION SEQUENCE:
1. Retrieve all handoffs from memory MCP:
   - 'batch_1_validation_complete'
   - 'batch_2_factcheck_complete'
   - 'batch_3_consistency_complete'
2. Query sqlite MCP for complete dataset:
   - SELECT * FROM validation_results
   - SELECT * FROM factcheck_results
   - SELECT * FROM consistency_analysis
   - SELECT * FROM processing_state
3. Use filesystem MCP to read files ./xhtml_files/sample_31.xhtml through ./xhtml_files/sample_44.xhtml
4. Process final batch with full context of previous 30 files
5. Use playwright MCP for final EPUB compilation testing
6. Use github MCP to create comprehensive report repository
7. Generate final deliverables:
   - Complete validation status for all 44 files
   - Fact-check verification summary
   - Consistency analysis across entire manuscript
   - EPUB readiness assessment
   - Prioritized fix recommendations
8. Store final results and update processing_state to 'workflow_complete'

DELIVERABLES:
- Complete manuscript integrity report
- EPUB validation status
- Prioritized action items
- GitHub repository with all findings

Execute this mission now and report final completion status."

ORCHESTRATOR COMPLETION:
After all 4 agents complete, generate a summary report showing:
- Total files processed: 44
- Validation status overview
- Fact-check completion rate
- Consistency score
- EPUB readiness
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
   - Each agent will wait for the previous to complete before starting

4. **Monitor Progress:**
   - Check `./workflow_status.json` for current status
   - Query SQLite database for detailed results
   - Review memory store for inter-agent handoffs