#!/bin/bash

# Static HTML Generator for Resume
# Converts markdown to static HTML (no JavaScript)
# Usage: bash generate-html.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if pandoc is available for markdown conversion
if command -v pandoc &> /dev/null; then
    echo "Using pandoc for markdown conversion..."
    CONVERTER="pandoc"
else
    echo "pandoc not found. Using basic markdown converter..."
    CONVERTER="basic"
fi

# Read CSS files
CSS=$(cat assets/web/css/style.css)
FONTS_CSS=$(cat assets/web/fonts/fonts.css)

# Function to convert markdown to HTML (basic converter)
markdown_to_html() {
    local md="$1"
    
    # Remove first h1
    md=$(echo "$md" | sed '0,/^# .*/d')
    
    # Headers
    md=$(echo "$md" | sed 's/^### /\n<h3>/; s/$/<\/h3>/')
    md=$(echo "$md" | sed 's/^## /\n<h2>/; s/$/<\/h2>/')
    
    # Bold and italic
    md=$(echo "$md" | sed 's/\*\*\(.*\)\*\*/<strong>\1<\/strong>/g')
    md=$(echo "$md" | sed 's/\*\(.*\)\*/<em>\1<\/em>/g')
    
    # Line breaks
    md=$(echo "$md" | sed 's/  $/\n<br>/')
    
    # Convert blank lines to paragraphs (simple approach)
    local html=""
    local in_para=0
    local para_text=""
    
    while IFS= read -r line; do
        if [[ -z "$line" ]]; then
            if [[ $in_para -eq 1 && -n "$para_text" ]]; then
                html+="<p>$para_text</p>"
                para_text=""
                in_para=0
            fi
        else
            if [[ $line =~ ^[#\-\>] ]]; then
                # Headers, lists, blockquotes
                if [[ $in_para -eq 1 && -n "$para_text" ]]; then
                    html+="<p>$para_text</p>"
                    para_text=""
                    in_para=0
                fi
                html+="$line"$'\n'
            else
                in_para=1
                para_text+="$line"$'\n'
            fi
        fi
    done <<< "$md"
    
    if [[ $in_para -eq 1 && -n "$para_text" ]]; then
        html+="<p>$para_text</p>"
    fi
    
    echo "$html"
}

# Function to generate HTML page
generate_page() {
    local md_file="$1"
    local output_file="$2"
    local lang="$3"
    local title="$4"
    
    echo "Generating $output_file..."
    
    # Read markdown
    local content=$(cat "$md_file")
    
    # Use pandoc if available, otherwise basic converter
    if [[ "$CONVERTER" == "pandoc" ]]; then
        content=$(pandoc -f markdown -t html "$md_file")
    else
        content=$(markdown_to_html "$content")
    fi
    
    # Remove the first h1 heading (duplicate of page header)
    content=$(echo "$content" | sed '0,/<h1[^>]*>.*<\/h1>/d')
    
    # Remove phone number line - straight text replacement
    content=$(echo "$content" | sed 's/Phone: +352 691 458 569<br \/>//')
    content=$(echo "$content" | sed 's/Téléphone : +352 691 458 569<br \/>//')
    
    # Clean up extra blank lines
    content=$(echo "$content" | sed '/^[[:space:]]*$/d')
    
    # Obfuscate email
    content=$(echo "$content" | sed 's/contact@cecilemorange\.fr/contact[at]cecilemorange.fr/g')
    
    # Determine alternate page link
    local alt_page="index-fr.html"
    local alt_lang="FR"
    if [[ "$lang" == "fr" ]]; then
        alt_page="index.html"
        alt_lang="EN"
    fi
    
    # Build HTML
    cat > "$output_file" << EOF
<!DOCTYPE html>
<html lang="$lang">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$title</title>
    <style>
$FONTS_CSS

$CSS
    </style>
</head>
<body>
    <a href="#main-content" class="skip-link">Skip to main content</a>

    <div class="header-top">
        <div class="lang-switcher">
            <a href="./index.html" class="lang-link$([ "$lang" = "en" ] && echo " active")">EN</a>
            <span class="lang-sep">|</span>
            <a href="./index-fr.html" class="lang-link$([ "$lang" = "fr" ] && echo " active")">FR</a>
        </div>
    </div>

    <main id="main-content">
        <h1 class="company-name">Cécile Morange</h1>
        <p class="people">Freelance Cloud Builder</p>

        <div class="content">
$content
        </div>
    </main>
</body>
</html>
EOF
}

# Generate both pages
generate_page "CV_Cecile_Morange_EN.md" "index.html" "en" "Cécile Morange - Freelance Cloud Builder"
generate_page "CV_Cecile_Morange_FR.md" "index-fr.html" "fr" "Cécile Morange - Cloud Builder Indépendante"

echo ""
echo "✓ Static HTML pages generated successfully!"
echo "  - index.html (English)"
echo "  - index-fr.html (Français)"
echo ""
echo "No JavaScript, pure static HTML with inlined CSS."
