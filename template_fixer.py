#!/usr/bin/env python3
"""
EPUB Template Fixer - Apply template compliance to all 16 chapters
Adds Google Fonts and ensures template compliance while preserving content.
"""

import os
import re
from pathlib import Path
import shutil
from datetime import datetime

class TemplateEnforcer:
    def __init__(self):
        self.backup_dir = Path('chapter_backups')
        self.oebps_path = Path('OEBPS')
        self.fixed_count = 0
        
        # Google Fonts link to inject
        self.google_fonts_link = '''    <link href="https://fonts.googleapis.com/css2?family=Cinzel+Decorative:wght@400;700&amp;family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&amp;display=swap" rel="stylesheet" />'''
        
        # Template header requirements
        self.template_head = '''    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>{{TITLE_PLACEHOLDER}}</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel+Decorative:wght@400;700&amp;family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&amp;display=swap" rel="stylesheet" />'''
    
    def create_backup(self):
        """Create backup of all chapter files."""
        if self.backup_dir.exists():
            shutil.rmtree(self.backup_dir)
        
        self.backup_dir.mkdir(exist_ok=True)
        
        text_dir = self.oebps_path / 'text'
        chapter_files = list(text_dir.glob('*chapter*.xhtml'))
        
        print(f"📁 Creating backup of {len(chapter_files)} chapter files...")
        
        for chapter_file in chapter_files:
            shutil.copy2(chapter_file, self.backup_dir / chapter_file.name)
        
        print(f"✅ Backup created in: {self.backup_dir}")
        return len(chapter_files)
    
    def fix_chapter_template(self, chapter_file):
        """Fix a single chapter to match template requirements."""
        print(f"🔧 Fixing: {chapter_file.name}")
        
        try:
            with open(chapter_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            fixes_applied = []
            
            # 1. Fix DOCTYPE (should be correct already)
            if '<!DOCTYPE html>' not in content:
                content = re.sub(r'<!DOCTYPE[^>]*>', '<!DOCTYPE html>', content)
                fixes_applied.append('Fixed DOCTYPE')
            
            # 2. Ensure UTF-8 charset
            if 'charset="UTF-8"' not in content and 'charset="utf-8"' in content:
                content = content.replace('charset="utf-8"', 'charset="UTF-8"')
                fixes_applied.append('Standardized charset to UTF-8')
            
            # 3. Add Google Fonts link if missing
            if 'fonts.googleapis.com' not in content:
                # Find the head section and add Google Fonts
                head_pattern = r'(<head[^>]*>)(.*?)(</head>)'
                head_match = re.search(head_pattern, content, re.DOTALL)
                
                if head_match:
                    head_start = head_match.group(1)
                    head_content = head_match.group(2)
                    head_end = head_match.group(3)
                    
                    # Extract title for preservation
                    title_match = re.search(r'<title>([^<]+)</title>', head_content)
                    title = title_match.group(0) if title_match else '<title>Chapter Title</title>'
                    
                    # Build new head content with template structure
                    new_head_content = f'''
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    {title}
    <link href="https://fonts.googleapis.com/css2?family=Cinzel+Decorative:wght@400;700&amp;family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&amp;display=swap" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../styles/fonts.css" />
    <link rel="stylesheet" type="text/css" href="../styles/style.css" />'''
                    
                    content = content.replace(head_match.group(0), 
                                            head_start + new_head_content + '\n  ' + head_end)
                    fixes_applied.append('Added Google Fonts link')
                    fixes_applied.append('Updated head structure')
                else:
                    print(f"  ⚠️ Could not find head section in {chapter_file.name}")
            
            # 4. Ensure proper HTML attributes
            html_pattern = r'<html([^>]*)>'
            html_match = re.search(html_pattern, content)
            
            if html_match:
                html_attrs = html_match.group(1)
                required_attrs = {
                    'xmlns': 'http://www.w3.org/1999/xhtml',
                    'xml:lang': 'en',
                    'lang': 'en'
                }
                
                new_attrs = html_attrs
                for attr, value in required_attrs.items():
                    if f'{attr}=' not in html_attrs:
                        new_attrs += f' {attr}="{value}"'
                        fixes_applied.append(f'Added {attr} attribute')
                
                if new_attrs != html_attrs:
                    content = content.replace(html_match.group(0), f'<html{new_attrs}>')
            
            # 5. Verify chapter-title-word structure exists (should already be there)
            if 'chapter-title-word' in content:
                fixes_applied.append('Verified chapter-title-word structure')
            else:
                print(f"  ⚠️ Missing chapter-title-word structure in {chapter_file.name}")
            
            # Write the fixed content
            if fixes_applied:
                with open(chapter_file, 'w', encoding='utf-8') as f:
                    f.write(content)
                
                print(f"  ✅ Applied {len(fixes_applied)} fixes:")
                for fix in fixes_applied:
                    print(f"    • {fix}")
                
                self.fixed_count += 1
            else:
                print(f"  ℹ️ No fixes needed for {chapter_file.name}")
            
            return fixes_applied
            
        except Exception as e:
            print(f"  ❌ Error fixing {chapter_file.name}: {str(e)}")
            return []
    
    def fix_all_chapters(self):
        """Fix all chapter files."""
        print("🚀 Starting Template Enforcement...")
        print("=" * 60)
        
        # Create backup first
        backup_count = self.create_backup()
        
        # Find all chapter files
        text_dir = self.oebps_path / 'text'
        chapter_files = sorted(list(text_dir.glob('*chapter*.xhtml')), 
                              key=lambda x: self._extract_chapter_num(x.name))
        
        print(f"\n🔧 Applying template fixes to {len(chapter_files)} chapters...")
        print("=" * 60)
        
        all_fixes = {}
        
        for chapter_file in chapter_files:
            fixes = self.fix_chapter_template(chapter_file)
            all_fixes[chapter_file.name] = fixes
        
        print(f"\n📊 TEMPLATE ENFORCEMENT SUMMARY")
        print("=" * 60)
        print(f"Chapters processed: {len(chapter_files)}")
        print(f"Chapters fixed: {self.fixed_count}")
        print(f"Backup location: {self.backup_dir}")
        
        # Save fix report
        self.save_fix_report(all_fixes)
        
        return all_fixes
    
    def _extract_chapter_num(self, filename):
        """Extract chapter number for sorting."""
        roman_to_num = {'i': 1, 'ii': 2, 'iii': 3, 'iv': 4, 'v': 5, 'vi': 6,
                        'vii': 7, 'viii': 8, 'ix': 9, 'x': 10, 'xi': 11, 'xii': 12,
                        'xiii': 13, 'xiv': 14, 'xv': 15, 'xvi': 16}
        
        name = filename.lower()
        for roman, num in roman_to_num.items():
            if f'chapter-{roman}' in name:
                return num
        return 0
    
    def save_fix_report(self, all_fixes):
        """Save detailed fix report."""
        report_file = f"template_fixes_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
        
        with open(report_file, 'w') as f:
            f.write("EPUB TEMPLATE ENFORCEMENT REPORT\\n")
            f.write("=" * 50 + "\\n\\n")
            f.write(f"Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\\n")
            f.write(f"Chapters processed: {len(all_fixes)}\\n")
            f.write(f"Chapters fixed: {self.fixed_count}\\n\\n")
            
            f.write("DETAILED FIXES BY CHAPTER:\\n")
            f.write("-" * 30 + "\\n\\n")
            
            for filename, fixes in all_fixes.items():
                f.write(f"{filename}:\\n")
                if fixes:
                    for fix in fixes:
                        f.write(f"  • {fix}\\n")
                else:
                    f.write("  • No fixes needed\\n")
                f.write("\\n")
        
        print(f"📄 Fix report saved to: {report_file}")

def main():
    enforcer = TemplateEnforcer()
    
    # Check if OEBPS directory exists
    if not enforcer.oebps_path.exists():
        print("❌ OEBPS directory not found! Make sure you're in the extracted EPUB directory.")
        return
    
    # Apply template fixes
    fixes = enforcer.fix_all_chapters()
    
    print(f"\\n🎉 Template enforcement complete!")
    print("\\n🔄 Next steps:")
    print("1. Run compliance check again to verify fixes")
    print("2. Test chapters in browser")
    print("3. Recompile EPUB")

if __name__ == "__main__":
    main()