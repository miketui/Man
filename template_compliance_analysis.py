#!/usr/bin/env python3
"""
EPUB Template Compliance Analysis Script
Analyzes all 16 chapters against the required template structure.
"""

import os
import re
from pathlib import Path
import xml.etree.ElementTree as ET
from bs4 import BeautifulSoup
import json

class TemplateComplianceAnalyzer:
    def __init__(self, epub_path):
        self.epub_path = Path(epub_path)
        self.chapter_files = []
        self.compliance_results = {}
        
        # Required template elements
        self.required_elements = {
            'doctype': '<!DOCTYPE html>',
            'html_attrs': ['xmlns="http://www.w3.org/1999/xhtml"', 'xml:lang="en"', 'lang="en"'],
            'meta_charset': '<meta charset="UTF-8"',
            'viewport_meta': 'name="viewport"',
            'google_fonts': 'fonts.googleapis.com/css2?family=Cinzel+Decorative',
            'libre_baskerville': 'Libre+Baskerville',
            'chapter_number_container': 'chapter-number-container',
            'chapter_title_container': 'chapter-title-container',
            'chapter_title_word': 'chapter-title-word'
        }
        
        # Variables that should be replaced
        self.mustache_variables = [
            '{{BOOK_TITLE}}',
            '{{CHAPTER_TITLE}}', 
            '{{NAV_TITLE}}',
            '{{CHAPTER_ROMAN_NUMERAL}}',
            '{{CHAPTER_TITLE_LINES}}',
            '{{BIBLE_QUOTE_TEXT}}',
            '{{BIBLE_QUOTE_REFERENCE}}',
            '{{INTRODUCTION_LABEL}}',
            '{{INTRODUCTION_TEXT}}',
            '{{CONTENT_HEADER}}',
            '{{MAIN_CONTENT}}',
            '{{QUIZ_HEADER}}',
            '{{WORKSHEET_HEADER}}',
            '{{TOP_FLOURISH}}',
            '{{BOTTOM_FLOURISH}}',
            '{{CLOSING_IMAGE}}',
            '{{CLOSING_QUOTE}}'
        ]
    
    def find_chapter_files(self):
        """Find all chapter XHTML files."""
        text_dir = self.epub_path / 'OEBPS' / 'text'
        pattern = re.compile(r'.*chapter.*\.xhtml$', re.IGNORECASE)
        
        for file in text_dir.glob('*.xhtml'):
            if pattern.match(str(file)):
                self.chapter_files.append(file)
        
        # Sort by chapter number
        self.chapter_files.sort(key=lambda x: self._extract_chapter_number(x.name))
        return self.chapter_files
    
    def _extract_chapter_number(self, filename):
        """Extract chapter number for sorting."""
        roman_map = {'i': 1, 'ii': 2, 'iii': 3, 'iv': 4, 'v': 5, 'vi': 6, 
                    'vii': 7, 'viii': 8, 'ix': 9, 'x': 10, 'xi': 11, 'xii': 12,
                    'xiii': 13, 'xiv': 14, 'xv': 15, 'xvi': 16}
        
        # Extract roman numeral from filename
        match = re.search(r'chapter-([ivx]+)', filename.lower())
        if match:
            roman = match.group(1)
            return roman_map.get(roman, 0)
        return 0
    
    def analyze_chapter(self, chapter_file):
        """Analyze a single chapter for template compliance."""
        results = {
            'file': chapter_file.name,
            'path': str(chapter_file),
            'compliant': True,
            'issues': [],
            'missing_elements': [],
            'unreplaced_variables': [],
            'has_google_fonts': False,
            'has_proper_structure': False,
            'content_truncated': False
        }
        
        try:
            with open(chapter_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Check DOCTYPE
            if self.required_elements['doctype'] not in content:
                results['issues'].append('Missing or incorrect DOCTYPE declaration')
                results['missing_elements'].append('DOCTYPE')
                results['compliant'] = False
            
            # Check HTML attributes
            for attr in self.required_elements['html_attrs']:
                if attr not in content:
                    results['issues'].append(f'Missing HTML attribute: {attr}')
                    results['missing_elements'].append(attr)
                    results['compliant'] = False
            
            # Check meta charset
            if self.required_elements['meta_charset'] not in content:
                results['issues'].append('Missing UTF-8 charset declaration')
                results['missing_elements'].append('meta_charset')
                results['compliant'] = False
            
            # Check viewport meta
            if self.required_elements['viewport_meta'] not in content:
                results['issues'].append('Missing viewport meta tag')
                results['missing_elements'].append('viewport_meta')
                results['compliant'] = False
            
            # Check Google Fonts
            if self.required_elements['google_fonts'] in content and self.required_elements['libre_baskerville'] in content:
                results['has_google_fonts'] = True
            else:
                results['issues'].append('Missing or incorrect Google Fonts link')
                results['missing_elements'].append('google_fonts')
                results['compliant'] = False
            
            # Check chapter structure elements
            structure_elements = ['chapter_number_container', 'chapter_title_container', 'chapter_title_word']
            structure_found = 0
            for elem in structure_elements:
                if self.required_elements[elem] in content:
                    structure_found += 1
                else:
                    results['missing_elements'].append(elem)
            
            results['has_proper_structure'] = structure_found >= 2
            if not results['has_proper_structure']:
                results['issues'].append('Missing proper chapter structure elements')
                results['compliant'] = False
            
            # Check for unreplaced Mustache variables
            for var in self.mustache_variables:
                if var in content:
                    results['unreplaced_variables'].append(var)
                    results['issues'].append(f'Unreplaced template variable: {var}')
                    results['compliant'] = False
            
            # Check content length (basic truncation detection)
            if len(content) < 5000:  # Very short chapters might be truncated
                results['content_truncated'] = True
                results['issues'].append('Potentially truncated content (very short)')
            
            # Parse with BeautifulSoup for more detailed analysis
            try:
                soup = BeautifulSoup(content, 'xml')
                
                # Check for proper title
                title_tag = soup.find('title')
                if not title_tag or not title_tag.text.strip():
                    results['issues'].append('Missing or empty title tag')
                    results['compliant'] = False
                
                # Check for navigation structure
                nav_elements = soup.find_all(['nav', 'div'], class_=re.compile(r'nav|navigation'))
                if not nav_elements:
                    results['issues'].append('Missing navigation structure')
                    results['compliant'] = False
                
            except Exception as e:
                results['issues'].append(f'XML parsing error: {str(e)}')
                results['compliant'] = False
                
        except Exception as e:
            results['issues'].append(f'File reading error: {str(e)}')
            results['compliant'] = False
        
        return results
    
    def analyze_all_chapters(self):
        """Analyze all chapters and generate comprehensive report."""
        self.find_chapter_files()
        
        print(f"Found {len(self.chapter_files)} chapter files")
        
        for chapter_file in self.chapter_files:
            print(f"Analyzing: {chapter_file.name}")
            self.compliance_results[chapter_file.name] = self.analyze_chapter(chapter_file)
        
        return self.compliance_results
    
    def generate_report(self):
        """Generate detailed compliance report."""
        compliant_count = sum(1 for result in self.compliance_results.values() if result['compliant'])
        total_count = len(self.compliance_results)
        
        report = {
            'summary': {
                'total_chapters': total_count,
                'compliant_chapters': compliant_count,
                'non_compliant_chapters': total_count - compliant_count,
                'compliance_percentage': (compliant_count / total_count * 100) if total_count > 0 else 0
            },
            'chapter_details': self.compliance_results,
            'common_issues': self._find_common_issues(),
            'critical_issues': self._find_critical_issues()
        }
        
        return report
    
    def _find_common_issues(self):
        """Find the most common compliance issues."""
        issue_counts = {}
        for result in self.compliance_results.values():
            for issue in result['issues']:
                issue_counts[issue] = issue_counts.get(issue, 0) + 1
        
        return sorted(issue_counts.items(), key=lambda x: x[1], reverse=True)
    
    def _find_critical_issues(self):
        """Find critical issues that affect multiple chapters."""
        critical = []
        for chapter, result in self.compliance_results.items():
            if not result['compliant'] and len(result['issues']) > 3:
                critical.append({
                    'chapter': chapter,
                    'issue_count': len(result['issues']),
                    'issues': result['issues']
                })
        
        return sorted(critical, key=lambda x: x['issue_count'], reverse=True)

def main():
    analyzer = TemplateComplianceAnalyzer('/home/warrenm115/Man-main')
    
    print("🔍 Starting Template Compliance Analysis...")
    print("=" * 60)
    
    # Analyze all chapters
    results = analyzer.analyze_all_chapters()
    
    # Generate report
    report = analyzer.generate_report()
    
    # Print summary
    print(f"\n📊 COMPLIANCE SUMMARY")
    print("=" * 60)
    print(f"Total Chapters: {report['summary']['total_chapters']}")
    print(f"Compliant: {report['summary']['compliant_chapters']}")
    print(f"Non-Compliant: {report['summary']['non_compliant_chapters']}")
    print(f"Compliance Rate: {report['summary']['compliance_percentage']:.1f}%")
    
    # Print common issues
    print(f"\n⚠️  MOST COMMON ISSUES")
    print("=" * 60)
    for issue, count in report['common_issues'][:10]:
        print(f"{count:2d} chapters: {issue}")
    
    # Print critical issues
    if report['critical_issues']:
        print(f"\n🚨 CRITICAL ISSUES")
        print("=" * 60)
        for critical in report['critical_issues'][:5]:
            print(f"{critical['chapter']}: {critical['issue_count']} issues")
    
    # Save detailed report
    with open('template_compliance_report.json', 'w') as f:
        json.dump(report, f, indent=2)
    
    print(f"\n✅ Detailed report saved to: template_compliance_report.json")
    
    return report

if __name__ == "__main__":
    main()