#!/bin/bash

# Add main landmarks to chapter files
CHAPTER_FILES=(
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
        
        # Add opening main tag after body
        sed -i 's|<body class="chap-title">|<body class="chap-title">\n    <main role="main" epub:type="bodymatter chapter">|' "$file"
        sed -i 's|<body class="chap-body">|<body class="chap-body">\n    <main role="main" epub:type="bodymatter chapter">|' "$file"
        
        # Add closing main tag before /body
        sed -i 's|</body>|    </main>\n  </body>|' "$file"
        
        echo "  ✓ Added landmarks to $file"
    else
        echo "  ⚠ File not found: $file"
    fi
done

echo "Landmark addition complete!"