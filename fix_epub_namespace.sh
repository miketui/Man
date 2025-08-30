#!/bin/bash

# Fix epub namespace declaration in chapter files
CHAPTER_FILES=(
    "9-chapter-i-unveiling-your-creative-odyssey.xhtml"
    "10-chapter-ii-refining-your-creative-toolkit.xhtml"
    "11-chapter-iii-reigniting-your-creative-fire.xhtml"
    "13-chapter-iv-the-art-of-networking-in-freelance-hairstyling.xhtml"
    "14-chapter-v-cultivating-creative-excellence-through-mentorship.xhtml"
    "15-chapter-vi-mastering-the-business-of-hairstyling.xhtml"
    "16-chapter-vii-embracing-wellness-and-self-care.xhtml"
    "17-chapter-viii-advancing-skills-through-continuous-education.xhtml"
    "19-chapter-ix-stepping-into-leadership.xhtml"
    "20-chapter-x-crafting-enduring-legacies.xhtml"
    "21-chapter-xi-advanced-digital-strategies-for-freelance-hairstylists.xhtml"
    "22-chapter-xii-financial-wisdom-building-sustainable-ventures.xhtml"
    "23-chapter-xiii-embracing-ethics-and-sustainability-in-hairstyling.xhtml"
    "25-chapter-xiv-the-impact-of-ai-on-the-beauty-industry.xhtml"
    "26-chapter-xv-cultivating-resilience-and-well-being-in-hairstyling.xhtml"
    "27-chapter-xvi-tresses-and-textures-embracing-diversity-in-hairstyling.xhtml"
)

cd /root/repo/OEBPS/text

for file in "${CHAPTER_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        echo "Processing $file..."
        
        # Add epub namespace to html element
        sed -i 's|<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">|<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="en" lang="en">|' "$file"
        
        echo "  ✓ Added epub namespace to $file"
    else
        echo "  ⚠ File not found: $file"
    fi
done

echo "Namespace fix complete!"