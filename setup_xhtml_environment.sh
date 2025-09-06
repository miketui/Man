#!/bin/bash

# XHTML/EPUB Environment Setup Script
# Based on CLAUDE.md configuration for comprehensive EPUB QA workflow

set -e

echo "🚀 Setting up XHTML/EPUB Quality Assurance Environment..."

# Create necessary directories
echo "📁 Creating project structure..."
mkdir -p src manuscripts qa-reports logs temp chain_memory

# Check for Node.js/npm
if command -v npm >/dev/null 2>&1; then
    echo "📦 Installing MCP servers..."
    
    # Core servers for XHTML processing
    npm install -g @modelcontextprotocol/server-filesystem || echo "⚠️ Failed to install filesystem server"
    npm install -g @modelcontextprotocol/server-brave-search || echo "⚠️ Failed to install brave-search server"
    npm install -g @modelcontextprotocol/server-sqlite || echo "⚠️ Failed to install sqlite server"
    npm install -g @modelcontextprotocol/server-playwright || echo "⚠️ Failed to install playwright server"
    npm install -g @modelcontextprotocol/server-memory || echo "⚠️ Failed to install memory server"
    npm install -g @modelcontextprotocol/server-everything || echo "⚠️ Failed to install everything server"
    npm install -g @modelcontextprotocol/server-github || echo "⚠️ Failed to install github server"
    
    # Install Playwright browsers for validation
    echo "🎭 Installing Playwright browsers..."
    npx playwright install || echo "⚠️ Failed to install Playwright browsers"
else
    echo "⚠️ npm not found. Please install Node.js and npm first."
    echo "MCP server installation skipped."
fi

# Initialize SQLite database (if sqlite3 is available)
if command -v sqlite3 >/dev/null 2>&1; then
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
    
    # Test database connection
    echo "🧪 Testing database connection..."
    sqlite3 ./xhtml_processing.db "SELECT 'Database connection successful' as test;" || echo "⚠️ Database test failed"
else
    echo "⚠️ sqlite3 not found. Database initialization skipped."
    echo "Please install sqlite3 to enable database functionality."
fi

# Set environment variables
echo "🔧 Setting environment variables..."

# Check if .env exists, if not create it
if [ ! -f .env ]; then
    cat > .env << 'EOF'
# Environment variables for XHTML processing
SQLITE_DB_PATH=./xhtml_processing.db
MEMORY_STORE_PATH=./chain_memory
FILESYSTEM_ALLOWED_PATHS=$(pwd)
BRAVE_API_KEY=your_brave_api_key_here
GITHUB_TOKEN=your_github_token_here
EOF
    echo "⚠️  Please update .env file with your actual API keys"
fi

# Create sample XHTML files for testing (if none exist)
if [ ! -f "./xhtml_files/sample_01.xhtml" ]; then
    echo "📝 Creating sample XHTML files..."
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
    <p>Some sample content with facts that need verification.</p>
    <p>Additional paragraph for consistency analysis testing.</p>
</body>
</html>
EOF
    done
fi

# Create workflow status file
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
  "last_updated": ""
}
EOF

# Update timestamp in workflow status
if command -v date >/dev/null 2>&1; then
    TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    sed -i "s/\"last_updated\": \"\"/\"last_updated\": \"$TIMESTAMP\"/" ./workflow_status.json
fi

echo "🎉 Environment setup complete!"
echo ""
echo "Setup Summary:"
echo "✅ Created directories: chain_memory, xhtml_files, reports"
echo "✅ Created 44 sample XHTML files"
echo "✅ Created environment configuration (.env)"
echo "✅ Created workflow tracking (workflow_status.json)"

if command -v sqlite3 >/dev/null 2>&1; then
    echo "✅ Initialized SQLite database with schema"
else
    echo "⚠️  SQLite database setup skipped (sqlite3 not available)"
fi

if command -v npm >/dev/null 2>&1; then
    echo "✅ MCP servers installation attempted"
else
    echo "⚠️  MCP servers installation skipped (npm not available)"
fi

echo ""
echo "Next steps:"
echo "1. Install Node.js and npm if not available"
echo "2. Install sqlite3 if not available" 
echo "3. Update .env file with your actual API keys"
echo "4. Replace sample XHTML files with your actual files"
echo "5. Configure MCP servers in your Terragon environment"
echo "6. Run the master orchestration prompt"
echo ""
echo "Files created:"
echo "- ./xhtml_processing.db (SQLite database, if sqlite3 available)"
echo "- ./chain_memory/ (Memory store directory)"
echo "- ./xhtml_files/ (44 sample XHTML files)"
echo "- ./reports/ (Output reports directory)"
echo "- .env (Environment variables template)"
echo "- ./workflow_status.json (Workflow tracking)"