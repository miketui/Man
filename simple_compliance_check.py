#!/usr/bin/env python3
"""
Simple EPUB Template Compliance Analysis
Uses only built-in Python modules.
"""

import os
import re
from pathlib import Path
import json

class SimpleComplianceChecker:
    def __init__(self):
        self.chapter_files = []
        self.results = {}
        
        # Template requirements
        self.required_patterns = {
            'doctype': r'<!DOCTYPE html>',
            'html_namespace': r'xmlns="http://www\.w3\.org/1999/xhtml"',
            'xml_lang': r'xml:lang="en"',
            'lang_attr': r'lang="en"',
            'utf8_charset': r'<meta charset="UTF-8"',
            'viewport_meta': r'name="viewport"',
            'google_fonts': r'fonts\.googleapis\.com/css2',
            'cinzel_font': r'Cinzel\+Decorative',
            'baskerville_font': r'Libre\+Baskerville',
            'chapter_structure': r'class="chapter-number-container"',
            'title_container': r'class="chapter-title-container"',
            'title_word': r'chapter-title-word'
        }
        
        # Mustache variables that should be replaced
        self.mustache_vars = [
            '{{BOOK_TITLE}}',
            '{{CHAPTER_TITLE}}', 
            '{{NAV_TITLE}}',
            '{{CHAPTER_ROMAN_NUMERAL}}',
            '{{CHAPTER_TITLE_LINES}}',
            '{{BIBLE_QUOTE_TEXT}}',
            '{{BIBLE_QUOTE_REFERENCE}}',
            '{{INTRODUCTION_LABEL}}',
            '{{MAIN_CONTENT}}',
            '{{QUIZ_HEADER}}'
        ]
    
    def find_chapters(self):
        """Find all chapter XHTML files."""
        oebps_text = Path('OEBPS/text')
        if not oebps_text.exists():
            print("❌ OEBPS/text directory not found!")
            return []
        
        # Find files with 'chapter' in the name
        for file in oebps_text.glob('*chapter*.xhtml'):
            self.chapter_files.append(file)
        
        # Sort by roman numeral
        self.chapter_files.sort(key=self._extract_chapter_num)
        print(f"📁 Found {len(self.chapter_files)} chapter files")
        return self.chapter_files
    
    def _extract_chapter_num(self, filepath):
        """Extract chapter number for sorting."""
        roman_to_num = {'i': 1, 'ii': 2, 'iii': 3, 'iv': 4, 'v': 5, 'vi': 6,
                        'vii': 7, 'viii': 8, 'ix': 9, 'x': 10, 'xi': 11, 'xii': 12,
                        'xiii': 13, 'xiv': 14, 'xv': 15, 'xvi': 16}
        
        name = filepath.name.lower()
        for roman, num in roman_to_num.items():
            if f'chapter-{roman}' in name:
                return num
        return 0
    
    def check_chapter(self, chapter_file):
        """Check a single chapter for compliance."""
        result = {
            'file': chapter_file.name,
            'compliant': True,
            'issues': [],
            'missing_required': [],
            'unreplaced_vars': [],
            'file_size': 0,
            'has_fonts': False,
            'has_structure': False
        }
        
        try:
            with open(chapter_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            result['file_size'] = len(content)
            
            # Check required patterns
            for name, pattern in self.required_patterns.items():
                if not re.search(pattern, content, re.IGNORECASE):
                    result['missing_required'].append(name)
                    result['issues'].append(f"Missing: {name}")
                    result['compliant'] = False
            
            # Check for Google Fonts
            if (re.search(self.required_patterns['google_fonts'], content) and
                re.search(self.required_patterns['cinzel_font'], content) and
                re.search(self.required_patterns['baskerville_font'], content)):
                result['has_fonts'] = True
            else:
                result['issues'].append("Missing proper Google Fonts links")
                result['compliant'] = False
            
            # Check chapter structure
            structure_count = 0
            for key in ['chapter_structure', 'title_container', 'title_word']:
                if re.search(self.required_patterns[key], content):
                    structure_count += 1
            
            result['has_structure'] = structure_count >= 2
            if not result['has_structure']:
                result['issues'].append("Missing proper chapter structure")
                result['compliant'] = False
            
            # Check for unreplaced mustache variables
            for var in self.mustache_vars:
                if var in content:
                    result['unreplaced_vars'].append(var)
                    result['issues'].append(f"Unreplaced variable: {var}")
                    result['compliant'] = False
            
            # Check content length
            if len(content) < 3000:
                result['issues'].append("Suspiciously short content - possible truncation")
            
            # Check for proper title tag
            title_match = re.search(r'<title>([^<]+)</title>', content)
            if not title_match or not title_match.group(1).strip():
                result['issues'].append("Missing or empty title tag")
                result['compliant'] = False
            
        except Exception as e:
            result['issues'].append(f"Error reading file: {str(e)}")
            result['compliant'] = False
        
        return result
    
    def analyze_all(self):
        """Analyze all chapters."""
        print("\n🔍 Starting Template Compliance Analysis...")
        print("=" * 60)
        
        if not self.find_chapters():
            print("❌ No chapter files found!")
            return {}
        
        for chapter_file in self.chapter_files:
            print(f"Checking: {chapter_file.name}...")
            self.results[chapter_file.name] = self.check_chapter(chapter_file)
        
        return self.results
    
    def print_report(self):
        """Print detailed compliance report."""
        if not self.results:
            print("❌ No analysis results available")
            return
        
        # Summary statistics
        total = len(self.results)
        compliant = sum(1 for r in self.results.values() if r['compliant'])
        non_compliant = total - compliant
        
        print(f"\n📊 COMPLIANCE SUMMARY")
        print("=" * 60)
        print(f"Total Chapters Analyzed: {total}")
        print(f"✅ Compliant Chapters: {compliant}")
        print(f"❌ Non-Compliant Chapters: {non_compliant}")
        print(f"📈 Compliance Rate: {(compliant/total*100):.1f}%")
        
        # Issue frequency analysis
        all_issues = []
        for result in self.results.values():
            all_issues.extend(result['issues'])
        
        issue_counts = {}
        for issue in all_issues:
            issue_counts[issue] = issue_counts.get(issue, 0) + 1
        
        print(f"\n⚠️  TOP ISSUES (Most Common)")
        print("=" * 60)
        sorted_issues = sorted(issue_counts.items(), key=lambda x: x[1], reverse=True)
        for issue, count in sorted_issues[:10]:
            print(f"{count:2d} files: {issue}")
        
        # Detailed chapter analysis
        print(f"\n📋 DETAILED CHAPTER ANALYSIS")
        print("=" * 60)
        
        for filename, result in self.results.items():
            status = "✅ COMPLIANT" if result['compliant'] else "❌ NON-COMPLIANT"
            print(f"\n{filename}: {status}")
            
            if result['issues']:
                print("  Issues:")
                for issue in result['issues'][:5]:  # Show first 5 issues
                    print(f"    • {issue}")
                if len(result['issues']) > 5:
                    print(f"    ... and {len(result['issues']) - 5} more issues")
            
            print(f"  File size: {result['file_size']:,} bytes")
            print(f"  Has fonts: {'Yes' if result['has_fonts'] else 'No'}")
            print(f"  Has structure: {'Yes' if result['has_structure'] else 'No'}")
            
            if result['unreplaced_vars']:
                print(f"  Unreplaced variables: {', '.join(result['unreplaced_vars'][:3])}")
                if len(result['unreplaced_vars']) > 3:
                    print(f"    ... and {len(result['unreplaced_vars']) - 3} more")
        
        # Save JSON report
        with open('compliance_report.json', 'w') as f:
            json.dump({
                'summary': {
                    'total': total,
                    'compliant': compliant,
                    'non_compliant': non_compliant,
                    'compliance_rate': compliant/total*100
                },
                'details': self.results
            }, f, indent=2)
        
        print(f"\n💾 Detailed JSON report saved to: compliance_report.json")

def main():
    checker = SimpleComplianceChecker()
    checker.analyze_all()
    checker.print_report()

if __name__ == "__main__":
    main()