#!/usr/bin/env python3
"""
Comprehensive EPUB Validation Script
Validates all EPUB files in the repository using EPUBCheck 5.1.0
"""

import os
import subprocess
import json
import sqlite3
from datetime import datetime
from pathlib import Path

class EPUBValidator:
    def __init__(self, repo_path="/home/runner/work/Man/Man"):
        self.repo_path = Path(repo_path)
        self.epubcheck_jar = self.repo_path / "epubcheck-5.1.0" / "epubcheck.jar"
        self.db_path = self.repo_path / "epub_qa.db"
        self.results = []
        
    def find_epub_files(self):
        """Find all EPUB files in the repository"""
        epub_files = list(self.repo_path.glob("*.epub"))
        return sorted(epub_files)
    
    def validate_epub(self, epub_path):
        """Validate a single EPUB file using EPUBCheck"""
        print(f"Validating: {epub_path.name}")
        
        try:
            # Run EPUBCheck
            cmd = ["java", "-jar", str(self.epubcheck_jar), str(epub_path)]
            result = subprocess.run(cmd, capture_output=True, text=True, cwd=self.repo_path)
            
            # Parse results
            output_lines = result.stdout.strip().split('\n')
            errors = []
            warnings = []
            
            for line in output_lines:
                if line.startswith('ERROR'):
                    errors.append(line)
                elif line.startswith('WARNING'):
                    warnings.append(line)
            
            # Extract summary
            summary_line = [line for line in output_lines if "Messages:" in line]
            if summary_line:
                summary = summary_line[0]
            else:
                summary = "No summary available"
            
            is_valid = result.returncode == 0 and len(errors) == 0
            
            validation_result = {
                'file_name': epub_path.name,
                'file_path': str(epub_path),
                'file_size': epub_path.stat().st_size,
                'is_valid': is_valid,
                'error_count': len(errors),
                'warning_count': len(warnings),
                'errors': errors[:10],  # Limit to first 10 errors
                'warnings': warnings[:10],  # Limit to first 10 warnings
                'summary': summary,
                'validation_time': datetime.now().isoformat(),
                'return_code': result.returncode
            }
            
            return validation_result
            
        except Exception as e:
            return {
                'file_name': epub_path.name,
                'file_path': str(epub_path),
                'file_size': epub_path.stat().st_size if epub_path.exists() else 0,
                'is_valid': False,
                'error_count': 1,
                'warning_count': 0,
                'errors': [f"Validation failed: {str(e)}"],
                'warnings': [],
                'summary': f"Validation error: {str(e)}",
                'validation_time': datetime.now().isoformat(),
                'return_code': -1
            }
    
    def update_database(self, results):
        """Update the SQLite database with validation results"""
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            for result in results:
                cursor.execute("""
                    INSERT OR REPLACE INTO validation_results 
                    (file_path, validation_status, errors_found, fix_suggestions)
                    VALUES (?, ?, ?, ?)
                """, (
                    result['file_path'],
                    'PASS' if result['is_valid'] else 'FAIL',
                    str(result['error_count']),
                    f"Errors: {result['error_count']}, Warnings: {result['warning_count']}"
                ))
            
            conn.commit()
            conn.close()
            print(f"Database updated with {len(results)} validation results")
            
        except Exception as e:
            print(f"Database update failed: {e}")
    
    def generate_report(self, results):
        """Generate comprehensive validation report"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # JSON Report
        json_report_path = self.repo_path / f"epub_validation_report_{timestamp}.json"
        with open(json_report_path, 'w') as f:
            json.dump({
                'validation_timestamp': datetime.now().isoformat(),
                'total_files': len(results),
                'valid_files': sum(1 for r in results if r['is_valid']),
                'invalid_files': sum(1 for r in results if not r['is_valid']),
                'results': results
            }, f, indent=2)
        
        # Text Summary Report
        text_report_path = self.repo_path / f"epub_validation_summary_{timestamp}.txt"
        with open(text_report_path, 'w') as f:
            f.write("COMPREHENSIVE EPUB VALIDATION REPORT\n")
            f.write("=" * 50 + "\n")
            f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"Total Files Validated: {len(results)}\n")
            f.write(f"Valid Files: {sum(1 for r in results if r['is_valid'])}\n")
            f.write(f"Invalid Files: {sum(1 for r in results if not r['is_valid'])}\n\n")
            
            for result in results:
                status = "✅ VALID" if result['is_valid'] else "❌ INVALID"
                f.write(f"{status}: {result['file_name']}\n")
                f.write(f"  Size: {result['file_size']:,} bytes\n")
                f.write(f"  Errors: {result['error_count']}, Warnings: {result['warning_count']}\n")
                if not result['is_valid'] and result['errors']:
                    f.write("  Sample Errors:\n")
                    for error in result['errors'][:3]:
                        f.write(f"    - {error}\n")
                f.write("\n")
        
        return json_report_path, text_report_path
    
    def update_chain_memory(self, results):
        """Update chain memory with validation summary"""
        chain_memory_dir = self.repo_path / "chain_memory"
        chain_memory_dir.mkdir(exist_ok=True)
        
        valid_count = sum(1 for r in results if r['is_valid'])
        invalid_count = sum(1 for r in results if not r['is_valid'])
        
        memory_content = f"""COMPREHENSIVE EPUB VALIDATION COMPLETE
Timestamp: {datetime.now().isoformat()}
Files Processed: {len(results)} EPUB files
Status: {"ALL VALID" if invalid_count == 0 else "MIXED RESULTS"}
- Valid EPUBs: {valid_count}
- Invalid EPUBs: {invalid_count}
- Total Errors: {sum(r['error_count'] for r in results)}
- Total Warnings: {sum(r['warning_count'] for r in results)}

LATEST PROFESSIONAL EPUB: {"PASS" if any(r['is_valid'] and 'PROFESSIONAL-BESTSELLER-20250830-080822' in r['file_name'] for r in results) else "NOT VALIDATED"}

Priority: {"No action needed - all files valid" if invalid_count == 0 else f"Fix {invalid_count} invalid EPUB files"}
Next Agent: {"Publication ready" if invalid_count == 0 else "Error remediation required"}
"""
        
        with open(chain_memory_dir / "epub_validation_complete.txt", 'w') as f:
            f.write(memory_content)
    
    def run_validation(self):
        """Run complete validation workflow"""
        print("Starting comprehensive EPUB validation...")
        
        epub_files = self.find_epub_files()
        print(f"Found {len(epub_files)} EPUB files")
        
        results = []
        for epub_file in epub_files:
            result = self.validate_epub(epub_file)
            results.append(result)
            self.results = results
        
        # Update database
        self.update_database(results)
        
        # Generate reports
        json_report, text_report = self.generate_report(results)
        
        # Update chain memory
        self.update_chain_memory(results)
        
        print(f"\nValidation complete!")
        print(f"JSON Report: {json_report}")
        print(f"Text Report: {text_report}")
        
        # Print summary
        valid_count = sum(1 for r in results if r['is_valid'])
        invalid_count = sum(1 for r in results if not r['is_valid'])
        
        print(f"\nSUMMARY:")
        print(f"✅ Valid EPUBs: {valid_count}")
        print(f"❌ Invalid EPUBs: {invalid_count}")
        print(f"📊 Total Files: {len(results)}")
        
        return results

if __name__ == "__main__":
    validator = EPUBValidator()
    validator.run_validation()