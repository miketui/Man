#!/usr/bin/env python3
"""
EPUB Font Link Fixer - Remove Google Fonts for EPUB compliance
"""

import os
import re
from pathlib import Path

def fix_google_fonts_in_chapters():
    """Remove Google Fonts links from all chapters for EPUB compliance."""
    
    text_dir = Path('OEBPS/text')
    chapter_files = list(text_dir.glob('*chapter*.xhtml'))
    
    print(f"🔧 Fixing Google Fonts links in {len(chapter_files)} chapters...")
    
    fixed_count = 0
    
    for chapter_file in chapter_files:
        try:
            with open(chapter_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Remove the Google Fonts link line
            google_fonts_pattern = r'\s*<link href="https://fonts\.googleapis\.com/css2[^>]*>\s*\n?'
            
            if re.search(google_fonts_pattern, content):
                content = re.sub(google_fonts_pattern, '', content)
                
                with open(chapter_file, 'w', encoding='utf-8') as f:
                    f.write(content)
                
                print(f"  ✅ Fixed: {chapter_file.name}")
                fixed_count += 1
            else:
                print(f"  ℹ️  No Google Fonts found: {chapter_file.name}")
                
        except Exception as e:
            print(f"  ❌ Error fixing {chapter_file.name}: {str(e)}")
    
    print(f"\n📊 Summary: Fixed {fixed_count} out of {len(chapter_files)} chapters")
    return fixed_count

def main():
    print("🚀 Starting EPUB Font Compliance Fix...")
    print("=" * 50)
    
    if not Path('OEBPS/text').exists():
        print("❌ OEBPS/text directory not found!")
        return
    
    fixed_count = fix_google_fonts_in_chapters()
    
    print(f"\n🎉 EPUB font compliance fix complete!")
    print(f"✅ {fixed_count} chapters now use local fonts only")
    print("\nNote: Chapters still have proper font styling via local CSS files.")

if __name__ == "__main__":
    main()