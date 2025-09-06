#!/usr/bin/env python3

"""
EPUB Rebuilder - Creates a properly packaged EPUB file from extracted contents
Ensures correct EPUB packaging format with mimetype-first approach
"""

import os
import zipfile
from pathlib import Path

def rebuild_epub():
    """Rebuild EPUB file with proper packaging format"""
    source_dir = "test_epub_extract"
    output_file = "Curls-Contemplation-WORKING-EPUB-20250905.epub"
    
    print("🔧 Rebuilding EPUB with proper packaging...")
    
    # Remove existing output file if it exists
    if os.path.exists(output_file):
        os.remove(output_file)
        print(f"✅ Removed existing {output_file}")
    
    # Create ZIP file with proper EPUB structure
    with zipfile.ZipFile(output_file, 'w', zipfile.ZIP_DEFLATED) as epub_zip:
        
        # 1. First, add mimetype (uncompressed, must be first)
        mimetype_path = os.path.join(source_dir, "mimetype")
        if os.path.exists(mimetype_path):
            epub_zip.write(mimetype_path, "mimetype", compress_type=zipfile.ZIP_STORED)
            print("✅ Added mimetype (uncompressed)")
        else:
            print("❌ Missing mimetype file!")
            return False
        
        # 2. Add META-INF directory
        meta_inf_dir = os.path.join(source_dir, "META-INF")
        if os.path.exists(meta_inf_dir):
            for root, dirs, files in os.walk(meta_inf_dir):
                for file in files:
                    file_path = os.path.join(root, file)
                    arc_path = os.path.relpath(file_path, source_dir)
                    epub_zip.write(file_path, arc_path)
            print("✅ Added META-INF directory")
        
        # 3. Add OEBPS directory (content)
        oebps_dir = os.path.join(source_dir, "OEBPS")
        if os.path.exists(oebps_dir):
            for root, dirs, files in os.walk(oebps_dir):
                for file in files:
                    file_path = os.path.join(root, file)
                    arc_path = os.path.relpath(file_path, source_dir)
                    epub_zip.write(file_path, arc_path)
            print("✅ Added OEBPS directory")
        
        # 4. Add any other files at root level (excluding already added)
        for item in os.listdir(source_dir):
            item_path = os.path.join(source_dir, item)
            if item not in ["mimetype", "META-INF", "OEBPS"] and os.path.isfile(item_path):
                epub_zip.write(item_path, item)
    
    # Verify the created EPUB
    if os.path.exists(output_file):
        file_size = os.path.getsize(output_file)
        print(f"✅ EPUB created successfully: {output_file}")
        print(f"📊 File size: {file_size:,} bytes ({file_size / 1024 / 1024:.2f} MB)")
        return True
    else:
        print("❌ Failed to create EPUB file")
        return False

def test_epub_structure():
    """Test the created EPUB file structure"""
    epub_file = "Curls-Contemplation-WORKING-EPUB-20250905.epub"
    
    if not os.path.exists(epub_file):
        print("❌ EPUB file not found")
        return False
    
    print(f"\n🧪 Testing {epub_file} structure...")
    
    try:
        with zipfile.ZipFile(epub_file, 'r') as epub_zip:
            files = epub_zip.namelist()
            
            # Check critical files
            critical_files = [
                "mimetype",
                "META-INF/container.xml",
                "OEBPS/content.opf"
            ]
            
            all_good = True
            for critical_file in critical_files:
                if critical_file in files:
                    print(f"✅ {critical_file} present")
                else:
                    print(f"❌ {critical_file} missing")
                    all_good = False
            
            # Count content files
            xhtml_files = [f for f in files if f.endswith('.xhtml')]
            css_files = [f for f in files if f.endswith('.css')]
            image_files = [f for f in files if f.lower().endswith(('.png', '.jpg', '.jpeg', '.gif', '.svg'))]
            font_files = [f for f in files if f.endswith('.woff2')]
            
            print(f"\n📊 Content summary:")
            print(f"   📄 XHTML files: {len(xhtml_files)}")
            print(f"   🎨 CSS files: {len(css_files)}")
            print(f"   🖼️ Image files: {len(image_files)}")
            print(f"   🔤 Font files: {len(font_files)}")
            print(f"   📁 Total files: {len(files)}")
            
            # Check mimetype content
            mimetype_content = epub_zip.read("mimetype").decode('utf-8').strip()
            if mimetype_content == "application/epub+zip":
                print("✅ Mimetype content correct")
            else:
                print(f"❌ Mimetype content incorrect: {mimetype_content}")
                all_good = False
            
            return all_good
            
    except Exception as e:
        print(f"❌ Error testing EPUB: {e}")
        return False

if __name__ == "__main__":
    print("🚀 EPUB Rebuilder Starting...")
    
    # Check if source directory exists
    if not os.path.exists("test_epub_extract"):
        print("❌ Source directory 'test_epub_extract' not found!")
        print("Please ensure the EPUB has been extracted first.")
        exit(1)
    
    # Rebuild EPUB
    if rebuild_epub():
        print("\n" + "="*50)
        test_epub_structure()
        print("="*50)
        print("\n🎉 EPUB rebuild complete!")
        print("📱 Test the EPUB in your preferred reader application")
    else:
        print("\n❌ EPUB rebuild failed!")
        exit(1)