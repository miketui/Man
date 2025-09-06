# EPUB Chapter Template Enforcement Guide

## 📚 Purpose

This repository contains the source files for the "Curls & Contemplation" EPUB.  
**To ensure a professional, consistent reading experience, every chapter (all 16) must use the exact chapter XHTML template structure described below.**  
This README explains the template, the required variables, and step-by-step instructions for team members working on chapter XHTML files.

---

## 📝 Template Requirement

Each chapter XHTML file **must begin** with the following HTML structure.  
This template uses Mustache-style variables (`{{VARIABLE}}`)—replace these with actual chapter content.

> **Never alter styles, JS, navigation, or layout except to insert content.**

### 📄 Chapter XHTML Template Start

```html
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>{{CHAPTER_TITLE}} - {{BOOK_TITLE}}</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel+Decorative:wght@400;700&amp;family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&amp;display=swap" rel="stylesheet" />
    <!-- (include the entire style block from the template) -->
</head>
<body>
    <!-- (include the navigation and all content structure as provided in the template) -->
</body>
</html>
```

For the **full template**, see `chapter-template.html` in this repository.

---

## 🔄 Variables and Conditional Sections

Replace all variables in each chapter file:

| Variable                   | Description / Example                                                  |
|----------------------------|-----------------------------------------------------------------------|
| `{{BOOK_TITLE}}`           | Book title (e.g. "Curls & Contemplation: A Stylist's Interactive Journey Journal") |
| `{{CHAPTER_TITLE}}`        | Full chapter title (e.g. "The Art of Networking")                     |
| `{{NAV_TITLE}}`            | Navigation bar title (e.g. "Chapter IV - The Art of Networking")      |
| `{{CHAPTER_ROMAN_NUMERAL}}`| I, II, III, IV, ...                                                   |
| `{{CHAPTER_TITLE_LINES}}`  | Multi-line chapter title (see below)                                  |
| `{{BIBLE_QUOTE_TEXT}}`, `{{BIBLE_QUOTE_REFERENCE}}` | Bible quote & reference (optional)         |
| `{{INTRODUCTION_LABEL}}`, `{{INTRODUCTION_TEXT}}` | Introduction section                       |
| `{{CONTENT_HEADER}}`, `{{MAIN_CONTENT}}` | Main content section                          |
| `{{QUIZ_HEADER}}`, `{{QUIZ_QUESTIONS}}`, ... | Quiz section variables                       |
| `{{WORKSHEET_HEADER}}`, `{{WORKSHEET_SECTIONS}}` | Worksheet section variables                   |
| `{{TOP_FLOURISH}}`, `{{BOTTOM_FLOURISH}}` | Decorative elements                           |
| `{{CLOSING_IMAGE}}`, `{{CLOSING_QUOTE}}` | Closing page content (optional)               |

**Conditional Sections:**  
Blocks like `{{#BIBLE_QUOTE}} ... {{/BIBLE_QUOTE}}`  
- If you use the section: Replace it with content.  
- If not: Remove the entire block.

### Example: Multi-Line Chapter Title

```html
{{#CHAPTER_TITLE_LINES}}
<div class="chapter-title-word">{{.}}</div>
{{/CHAPTER_TITLE_LINES}}
```
Becomes:
```html
<div class="chapter-title-word">THE</div>
<div class="chapter-title-word">ART OF</div>
<div class="chapter-title-word">NETWORKING</div>
```

---

## 🚦 Workflow for Chapter Authors

1. **Copy the template** from `chapter-template.html`.
2. **Paste at the top** of your chapter XHTML file.
3. **Replace all variables** with actual content for your chapter.
4. **Remove or fill in conditional sections** as appropriate.
5. **Do not change styles, navigation, or JavaScript.**
6. **Test**: Open your chapter XHTML in a browser. Ensure all navigation and sections work as intended.
7. **Review**: Check for consistency with other chapters.

---

## 🛠️ Pro Tips

- Use high-quality images (minimum 800px wide) with alt text and captions.
- Convert Markdown to HTML before inserting into `{{MAIN_CONTENT}}`.
- Keep quiz answers in capital letters (A, B, C, D) in the JS.
- Use `<p>`, `<h2>`, `<blockquote>`, etc., for semantic structure.
- For worksheet fields, provide actionable prompts and helpful placeholder text.

---

## 📂 Reference

- **`chapter-template.html`**: Full reference template with all variables and sections.
- **`README.md` (this file)**: Team guide and enforcement checklist.

---

## ✅ Final Checklist

- [ ] Chapter file starts with the exact template structure.
- [ ] All variables are replaced.
- [ ] Conditional sections handled (filled or removed).
- [ ] No style/JS/layout changes.
- [ ] File tested in browser.

---

For questions or help, please contact the project maintainer.