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

CREATE TABLE IF NOT EXISTS accessibility_results (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT NOT NULL,
    wcag_compliance TEXT,
    issues TEXT,
    wcag_compliance_score REAL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS template_compliance_results (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT NOT NULL,
    compliance_status TEXT,
    issues_found TEXT,
    compliance_percentage REAL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS publication_readiness_results (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    epub_file TEXT NOT NULL,
    overall_score REAL,
    certification_level TEXT,
    epub_validation_score REAL,
    structure_score REAL,
    template_score REAL,
    accessibility_score REAL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
