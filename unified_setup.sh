#!/bin/bash

# Unified XHTML Processing Environment Setup Script
# Compatible with Terragon Labs and Standard Environments
# Auto-detects environment capabilities and adjusts accordingly

set -e

echo "🚀 Setting up XHTML Processing Environment..."

# Detect environment type
TERRAGON_MODE=false
if [ "$1" = "--terragon" ] || [ -n "$TERRAGON_ENV" ]; then
    TERRAGON_MODE=true
    echo "📱 Running in Terragon-compatible mode"
else
    echo "💻 Running in standard environment mode"
fi

echo ""
echo "🔍 Environment Detection:"
echo "Node.js/npm: $(command -v npm >/dev/null 2>&1 && echo "✅ Available" || echo "❌ Not available")"
echo "SQLite3: $(command -v sqlite3 >/dev/null 2>&1 && echo "✅ Available" || echo "❌ Not available")"
echo "Git: $(command -v git >/dev/null 2>&1 && echo "✅ Available" || echo "❌ Not available")"
echo ""

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p ./chain_memory
mkdir -p ./xhtml_files
mkdir -p ./reports

echo "✅ Created directories: chain_memory, xhtml_files, reports"

# MCP Servers Installation (skip in Terragon mode)
if [ "$TERRAGON_MODE" = false ] && command -v npm >/dev/null 2>&1; then
    echo ""
    echo "📦 Installing MCP servers..."
    
    # Core servers for XHTML processing
    echo "Installing filesystem server..."
    npm install -g @modelcontextprotocol/server-filesystem || echo "⚠️ Failed to install filesystem server"
    
    echo "Installing brave-search server..."
    npm install -g @modelcontextprotocol/server-brave-search || echo "⚠️ Failed to install brave-search server"
    
    echo "Installing memory server..."
    npm install -g @modelcontextprotocol/server-memory || echo "⚠️ Failed to install memory server"
    
    echo "Installing everything server..."
    npm install -g @modelcontextprotocol/server-everything || echo "⚠️ Failed to install everything server"
    
    echo "Installing github server..."
    npm install -g @modelcontextprotocol/server-github || echo "⚠️ Failed to install github server"
    
    # These servers often fail, so we'll skip them or handle gracefully
    echo "Attempting sqlite server (may fail)..."
    npm install -g @modelcontextprotocol/server-sqlite 2>/dev/null || echo "⚠️ SQLite server not available in registry"
    
    echo "Attempting playwright server (may fail)..."
    npm install -g @modelcontextprotocol/server-playwright 2>/dev/null || echo "⚠️ Playwright server not available in registry"
    
    # Install Playwright browsers if possible
    echo "🎭 Installing Playwright browsers..."
    if command -v npx >/dev/null 2>&1; then
        npx playwright install || echo "⚠️ Failed to install Playwright browsers (this is okay)"
    fi
    
    echo "✅ MCP servers installation completed"
else
    if [ "$TERRAGON_MODE" = true ]; then
        echo "📱 Skipping MCP server installation (Terragon mode - configure in interface)"
    else
        echo "⚠️ npm not found. MCP server installation skipped."
        echo "   Install Node.js and npm to enable MCP server installation"
    fi
fi

# Initialize SQLite database
echo ""
if command -v sqlite3 >/dev/null 2>&1 && [ "$TERRAGON_MODE" = false ]; then
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
    echo "✅ SQLite database initialized and tested"
else
    echo "🗄️ Creating database schema script for manual setup..."
    cat > ./create_database.sql << 'EOF'
-- SQLite Database Schema for XHTML Processing
-- Run this manually if SQLite becomes available

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
    echo "✅ Database schema script created (./create_database.sql)"
fi

# Set environment variables
echo ""
echo "🔧 Creating environment configuration..."

# Check if .env exists, if not create it
if [ ! -f .env ]; then
    # Detect current working directory properly
    CURRENT_DIR=$(pwd)
    cat > .env << EOF
# Environment variables for XHTML processing
SQLITE_DB_PATH=./xhtml_processing.db
MEMORY_STORE_PATH=./chain_memory
FILESYSTEM_ALLOWED_PATHS=${CURRENT_DIR}
BRAVE_API_KEY=your_brave_api_key_here
GITHUB_TOKEN=your_github_token_here
EOF
    echo "✅ Created .env file with template values"
    echo "⚠️  Please update .env file with your actual API keys"
else
    echo "✅ .env file already exists"
fi

# Create sample XHTML files for testing (if none exist)
echo ""
if [ ! -f "./xhtml_files/sample_01.xhtml" ]; then
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
    <p>Sample factual claim: The year 2024 marked significant advances in AI technology.</p>
    <p>Additional paragraph for consistency analysis testing across all files.</p>
    <p>Each file contains unique content while maintaining thematic consistency.</p>
</body>
</html>
EOF
    done
    echo "✅ Created 44 sample XHTML files"
else
    echo "✅ XHTML files already exist"
fi

# Create workflow status file
echo ""
echo "📊 Creating workflow tracking..."
ENVIRONMENT_TYPE=$( [ "$TERRAGON_MODE" = true ] && echo "terragon" || echo "standard" )
TIMESTAMP=$( command -v date >/dev/null 2>&1 && date -u +%Y-%m-%dT%H:%M:%SZ || echo "" )

cat > ./workflow_status.json << EOF
{
  "workflow_status": {
    "validation_agent": "pending",
    "factcheck_agent": "pending", 
    "consistency_agent": "pending",
    "integration_agent": "pending"
  },
  "processing_model": "all_files_per_agent",
  "total_files": 44,
  "environment": "${ENVIRONMENT_TYPE}",
  "setup_completed": "${TIMESTAMP}",
  "capabilities": {
    "npm": $(command -v npm >/dev/null 2>&1 && echo "true" || echo "false"),
    "sqlite3": $(command -v sqlite3 >/dev/null 2>&1 && echo "true" || echo "false"),
    "git": $(command -v git >/dev/null 2>&1 && echo "true" || echo "false")
  }
}
EOF

echo "✅ Created workflow tracking file"

# Summary
echo ""
echo "🎉 Environment setup complete!"
echo ""
echo "📋 Setup Summary:"
echo "✅ Created directories: chain_memory, xhtml_files, reports"
echo "✅ Created 44 sample XHTML files"
echo "✅ Created environment configuration (.env)"
echo "✅ Created workflow tracking (workflow_status.json)"

if command -v sqlite3 >/dev/null 2>&1 && [ "$TERRAGON_MODE" = false ]; then
    echo "✅ Initialized SQLite database with schema"
else
    echo "📝 Created database schema script (./create_database.sql)"
fi

if [ "$TERRAGON_MODE" = false ] && command -v npm >/dev/null 2>&1; then
    echo "✅ MCP servers installation attempted"
else
    echo "📱 MCP server installation skipped (configure in Terragon interface)"
fi

echo ""
echo "📁 Files created:"
echo "- ./chain_memory/ (Memory store directory)"
echo "- ./xhtml_files/ (44 sample XHTML files)"
echo "- ./reports/ (Output reports directory)"
echo "- .env (Environment variables template)"
echo "- ./workflow_status.json (Workflow tracking)"
if [ ! -f "./xhtml_processing.db" ]; then
    echo "- ./create_database.sql (Database schema for manual setup)"
else
    echo "- ./xhtml_processing.db (SQLite database)"
fi

echo ""
echo "🚀 Next Steps:"
if [ "$TERRAGON_MODE" = true ]; then
    echo "1. Update .env file with your actual API keys"
    echo "2. Configure MCP servers in Terragon interface using provided JSON"
    echo "3. Run database setup manually if SQLite becomes available"
    echo "4. Replace sample XHTML files with your actual files"
    echo "5. Launch master orchestration prompt in Terragon"
else
    echo "1. Install missing dependencies if needed:"
    command -v npm >/dev/null 2>&1 || echo "   - Install Node.js and npm"
    command -v sqlite3 >/dev/null 2>&1 || echo "   - Install sqlite3"
    echo "2. Update .env file with your actual API keys"
    echo "3. Replace sample XHTML files with your actual files"
    echo "4. Configure MCP servers in your environment"
    echo "5. Run the master orchestration prompt"
fi

echo ""
echo "🔧 Usage:"
echo "Standard mode:    ./unified_setup.sh"
echo "Terragon mode:    ./unified_setup.sh --terragon"
echo "                  or set TERRAGON_ENV=1"
echo ""
echo "Ready for XHTML processing workflow! 🎯"