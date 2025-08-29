#!/bin/bash

# XHTML Processing Environment Setup Script
# For Terragon Labs MCP Server Configuration

set -e

echo "🚀 Setting up XHTML Processing Environment for Terragon..."

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p ./chain_memory
mkdir -p ./xhtml_files
mkdir -p ./reports

# Install required MCP servers globally
echo "📦 Installing MCP servers..."

# Core servers for XHTML processing
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-brave-search
npm install -g @modelcontextprotocol/server-sqlite
npm install -g @modelcontextprotocol/server-playwright
npm install -g @modelcontextprotocol/server-memory
npm install -g @modelcontextprotocol/server-everything
npm install -g @modelcontextprotocol/server-github

# Install Playwright browsers for validation
echo "🎭 Installing Playwright browsers..."
npx playwright install

# Initialize SQLite database
echo "🗄️ Initializing SQLite database..."
sqlite3 ./xhtml_processing.db << 'EOF'
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

# Set environment variables
echo "🔧 Setting environment variables..."

# Check if .env exists, if not create it
if [ ! -f .env ]; then
    cat > .env << 'EOF'
# Environment variables for XHTML processing
SQLITE_DB_PATH=./xhtml_processing.db
MEMORY_STORE_PATH=./chain_memory
FILESYSTEM_ALLOWED_PATHS=/root/repo
BRAVE_API_KEY=your_brave_api_key_here
GITHUB_TOKEN=your_github_token_here
EOF
    echo "⚠️  Please update .env file with your actual API keys"
fi

# Source environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Create sample XHTML files for testing (if none exist)
if [ ! -f "./xhtml_files/sample_01.xhtml" ]; then
    echo "📝 Creating sample XHTML files..."
    for i in {01..44}; do
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
</body>
</html>
EOF
    done
fi

# Verify MCP server installations
echo "✅ Verifying installations..."
echo "Filesystem server: $(which @modelcontextprotocol/server-filesystem || echo 'Not found')"
echo "Brave search server: $(which @modelcontextprotocol/server-brave-search || echo 'Not found')"
echo "SQLite server: $(which @modelcontextprotocol/server-sqlite || echo 'Not found')"
echo "Playwright server: $(which @modelcontextprotocol/server-playwright || echo 'Not found')"
echo "Memory server: $(which @modelcontextprotocol/server-memory || echo 'Not found')"

# Test database connection
echo "🧪 Testing database connection..."
sqlite3 ./xhtml_processing.db "SELECT 'Database connection successful' as test;"

# Create workflow status file
cat > ./workflow_status.json << 'EOF'
{
  "workflow_status": {
    "validation_agent": "pending",
    "factcheck_agent": "pending", 
    "consistency_agent": "pending",
    "integration_agent": "pending"
  },
  "batch_processing": {
    "batch_1_files": "1-10",
    "batch_2_files": "11-20", 
    "batch_3_files": "21-30",
    "batch_4_files": "31-44"
  },
  "last_updated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF

echo "🎉 Environment setup complete!"
echo ""
echo "Next steps:"
echo "1. Update .env file with your API keys"
echo "2. Copy your XHTML files to ./xhtml_files/ directory"
echo "3. Run the master orchestration prompt in Terragon"
echo ""
echo "Files created:"
echo "- ./xhtml_processing.db (SQLite database)"
echo "- ./chain_memory/ (Memory store directory)"
echo "- ./xhtml_files/ (XHTML files directory with samples)"
echo "- ./reports/ (Output reports directory)"
echo "- .env (Environment variables)"
echo "- ./workflow_status.json (Workflow tracking)"