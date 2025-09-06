#!/bin/bash

# Terragon Environment Setup for XHTML Processing
# Simplified version for Terragon Labs

echo "🚀 Setting up Terragon XHTML Processing Environment..."

# Create essential directories
mkdir -p ./chain_memory
mkdir -p ./xhtml_files
mkdir -p ./reports

echo "📁 Created directories: chain_memory, xhtml_files, reports"

# Create environment variables file
cat > .env << 'EOF'
# Terragon Environment Variables
SQLITE_DB_PATH=./xhtml_processing.db
MEMORY_STORE_PATH=./chain_memory
FILESYSTEM_ALLOWED_PATHS=$(pwd)
BRAVE_API_KEY=your_brave_api_key_here
GITHUB_TOKEN=your_github_token_here
EOF

echo "🔧 Created environment configuration"

# Create 44 sample XHTML files
echo "📝 Creating 44 sample XHTML files..."
for i in $(seq -w 1 44); do
    cat > "./xhtml_files/sample_${i}.xhtml" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Sample XHTML File ${i}</title>
    <meta charset="UTF-8" />
</head>
<body>
    <h1>Chapter ${i}</h1>
    <p>This is a sample XHTML file for processing. File number: ${i}</p>
    <p>This content needs fact-checking and validation.</p>
    <p>Some sample facts: The year 2024 was significant for AI development.</p>
    <p>Additional paragraph for consistency analysis testing.</p>
</body>
</html>
EOF
done

# Create workflow tracking file
cat > ./workflow_status.json << 'EOF'
{
  "workflow_status": {
    "validation_agent": "pending",
    "factcheck_agent": "pending", 
    "consistency_agent": "pending",
    "integration_agent": "pending"
  },
  "processing_model": "all_files_per_agent",
  "total_files": 44,
  "environment": "terragon"
}
EOF

echo "📊 Created workflow tracking file"

# Create database schema script (for manual execution if needed)
cat > ./create_database.sql << 'EOF'
CREATE TABLE IF NOT EXISTS validation_results (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT NOT NULL,
    batch_number INTEGER,
    validation_status TEXT,
    errors_found TEXT,
    fix_suggestions TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS factcheck_results (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT NOT NULL,
    claim TEXT,
    verification_status TEXT,
    sources TEXT,
    confidence_score REAL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS consistency_analysis (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT NOT NULL,
    inconsistency_type TEXT,
    description TEXT,
    severity TEXT,
    cross_references TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS processing_state (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    agent_name TEXT NOT NULL,
    batch_number INTEGER,
    status TEXT,
    results_summary TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
EOF

echo "🗄️ Created database schema script"

echo ""
echo "✅ Terragon Environment Setup Complete!"
echo ""
echo "Created:"
echo "- ./chain_memory/ (Memory store directory)"
echo "- ./xhtml_files/ (44 sample XHTML files)"
echo "- ./reports/ (Output reports directory)" 
echo "- .env (Environment variables)"
echo "- ./workflow_status.json (Workflow tracking)"
echo "- ./create_database.sql (Database schema)"
echo ""
echo "Next steps for Terragon:"
echo "1. Update .env with your actual API keys"
echo "2. Configure MCP servers in Terragon interface"
echo "3. Run database setup if SQLite is available"
echo "4. Launch master orchestration prompt"
echo ""
echo "Ready for XHTML processing workflow! 🎉"