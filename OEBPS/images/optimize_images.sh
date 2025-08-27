#!/bin/bash

# Image Optimization Script for Ebook and PDF Distribution
# This script optimizes all images in the OEBPS/images folder

echo "Starting image optimization for ebook and PDF distribution..."

# Create backup directory
mkdir -p original_backups
echo "Created backup directory: original_backups/"

# Function to optimize JPEG images
optimize_jpeg() {
    local input_file="$1"
    local output_file="$2"
    
    # For ebook/PDF: Use quality 85-90 for good balance of size and quality
    # Strip metadata, optimize for web/ebook viewing
    convert "$input_file" \
        -strip \
        -quality 85 \
        -interlace Plane \
        -sampling-factor 4:2:0 \
        "$output_file"
    
    echo "Optimized JPEG: $input_file"
}

# Function to optimize PNG images
optimize_png() {
    local input_file="$1"
    local output_file="$2"
    
    # For PNG: Preserve transparency, optimize compression
    # Use adaptive filtering for better compression
    convert "$input_file" \
        -strip \
        -define png:compression-level=9 \
        -define png:compression-strategy=1 \
        -define png:exclude-chunk=all \
        -define png:color-type=6 \
        "$output_file"
    
    echo "Optimized PNG: $input_file"
}

# Backup all original files first
echo "Creating backups of original files..."
for file in *.JPEG *.PNG *.PNG; do
    if [ -f "$file" ]; then
        cp "$file" "original_backups/$file"
    fi
done

echo "Backups created successfully."

# Optimize JPEG images (quote images, decorative elements)
echo "Optimizing JPEG images..."
for file in *.JPEG; do
    if [ -f "$file" ]; then
        case "$file" in
            "Michael.JPEG")
                # Portrait photo - use higher quality
                convert "$file" -strip -quality 90 -interlace Plane "$file"
                echo "Optimized portrait: $file"
                ;;
            "part-border.JPEG"|"brushstroke.JPEG"|"decorative-line.JPEG")
                # Decorative elements - can use more compression
                convert "$file" -strip -quality 80 -interlace Plane "$file"
                echo "Optimized decorative: $file"
                ;;
            *)
                # Quote images - standard optimization
                optimize_jpeg "$file" "$file"
                ;;
        esac
    fi
done

# Optimize PNG images (graphics, icons, elements with transparency)
echo "Optimizing PNG images..."
for file in *.PNG; do
    if [ -f "$file" ]; then
        case "$file" in
            "quiz-checkbox.PNG"|"endnote-marker.PNG"|"toc-divider.PNG")
                # Small icons - aggressive optimization
                convert "$file" -strip -define png:compression-level=9 "$file"
                echo "Optimized small icon: $file"
                ;;
            "quote-marks.PNG"|"crown-ornament.PNG"|"ruled-paper.PNG")
                # Larger graphics - standard optimization
                optimize_png "$file" "$file"
                ;;
            *)
                # Default PNG optimization
                optimize_png "$file" "$file"
                ;;
        esac
    fi
done

# Generate optimization report
echo ""
echo "=== OPTIMIZATION COMPLETE ==="
echo ""
echo "Original total size:"
du -sh original_backups/
echo ""
echo "Optimized total size:"
du -sh *.JPEG *.PNG *.PNG
echo ""
echo "Individual file sizes after optimization:"
du -sh *.JPEG *.PNG *.PNG | sort -h
echo ""
echo "Backup files are stored in: original_backups/"
echo "Optimization complete!"