# Document Generation Troubleshooting Guide

**Priority:** HIGH  
**Applies to:** DOCX/PPTX generation from markdown with Mermaid diagrams  
**Last Updated:** March 4, 2026

---

## Overview

This guide provides solutions to common problems encountered during document generation using the VA workspace workflow. All issues listed here have been encountered and resolved in production projects.

**Related Documentation:**
- [Document Generation Workflow](.github/skills/document-generation-workflow.md) - Complete workflow specification
- [Bug Prevention Standards](.github/standards/bugs-prevention-standard.md) - Anti-patterns to avoid

---

## Quick Diagnostic Guide

| Symptom | Likely Cause | Jump To |
|---------|-------------|---------|
| DOCX contains Mermaid code | Wrong source directory | [Problem 1](#problem-1-docx-contains-mermaid-code) |
| PPTX has text over images | Used processed-md instead of processed-md-pptx | [Problem 2](#problem-2-pptx-has-text-overlapping-images) |
| PPTX generation fails | Missing PNG files | [Problem 3](#problem-3-pptx-generation-fails-with-file-not-found) |
| DOCX files are tiny (<50 KB) | Images not embedded | [Problem 4](#problem-4-docx-files-are-small-50-kb) |
| List items on same line | Markdown formatting issue | [Problem 5](#problem-5-list-items-appear-on-same-line) |
| PNG generation fails | Mermaid syntax error or missing mmdc | [Problem 6](#problem-6-png-generation-fails) |
| Process-VA-Markdown fails | Missing directories | [Problem 7](#problem-7-pre-processing-scripts-fail) |

---

## Problem 1: DOCX Contains Mermaid Code

### Symptoms
- Opening Word document shows both diagram images AND code blocks
- Text like `graph TB`, `A --> B`, `subgraph` appears in document
- Mermaid syntax visible as literal text

### Diagnosis
Extract DOCX to markdown and check for Mermaid patterns:
```powershell
$content = pandoc docx\file.docx -t markdown
if ($content -match 'mermaid|graph TB|graph LR') {
    Write-Host "CONFIRMED: Contains Mermaid code" -ForegroundColor Red
}
```

### Root Cause
Generated from `md_sources/` instead of `processed-md/`

### Solution
```powershell
# 1. Pre-process markdown (removes Mermaid, inserts PNG refs)
& "C:\Users\alk\src\VA\documentation\scripts\Process-VA-Markdown.ps1"

# 2. Regenerate DOCX from PROCESSED markdown
Get-ChildItem "processed-md\*.md" | ForEach-Object {
    $output = "docx\$($_.BaseName).docx"
    pandoc $_.FullName -o $output --resource-path=png --toc
    Write-Host "✓ Regenerated: $output"
}

# 3. Verify
$content = pandoc docx\file.docx -t markdown
if ($content -notmatch 'mermaid') {
    Write-Host "✓ FIXED: No Mermaid code found" -ForegroundColor Green
}
```

### Prevention
- **Always** use `processed-md/` as source for DOCX generation
- **Never** use `md_sources/` directly with Pandoc
- Add verification step to generation scripts

---

## Problem 2: PPTX Has Text Overlapping Images

### Symptoms
- PowerPoint slides show text boxes with "Diagram 1", "Diagram 2", etc.
- Text overlaps the actual diagram images
- Captions appear above or on top of graphics

### Diagnosis
Extract PPTX to markdown and check for diagram captions:
```powershell
$content = pandoc pptx\file.pptx -t markdown
if ($content -match 'Diagram \d+\s*[\r\n]') {
    Write-Host "CONFIRMED: Caption overlap present" -ForegroundColor Red
}
```

### Root Cause
Generated from `processed-md/` instead of `processed-md-pptx/`

PPTX format renders image alt text `![Diagram N](...)` as visible caption text boxes.

### Solution
```powershell
# 1. Create PPTX-optimized markdown (removes captions)
& "C:\Users\alk\src\VA\documentation\scripts\Process-VA-Markdown-PPTX.ps1"

# 2. Regenerate PPTX from PPTX-OPTIMIZED markdown
Get-ChildItem "processed-md-pptx\*.md" | ForEach-Object {
    $output = "pptx\$($_.BaseName).pptx"
    pandoc $_.FullName -o $output -t pptx --resource-path=png
    Write-Host "✓ Regenerated: $output"
}

# 3. Verify
$content = pandoc pptx\file.pptx -t markdown
if ($content -notmatch 'Diagram \d+') {
    Write-Host "✓ FIXED: No caption overlap found" -ForegroundColor Green
}
```

### Prevention
- **Always** use `processed-md-pptx/` as source for PPTX generation
- **Never** use `processed-md/` or `md_sources/` for PPTX
- Run Step 3B (Process-VA-Markdown-PPTX.ps1) after Step 3

---

## Problem 3: PPTX Generation Fails with "File not found"

### Symptoms
- Pandoc error: `Could not find image 'png/diagram.png'`
- PPTX file not created
- Error message references missing PNG files

### Diagnosis
Check if PNG files exist:
```powershell
$missingImages = @()
Get-Content "processed-md-pptx\file.md" -Raw | 
    Select-String -Pattern '!\[.*?\]\((png/.*?\.png)\)' -AllMatches |
    ForEach-Object { $_.Matches.Groups[1].Value } |
    Where-Object { !(Test-Path $_) } |
    ForEach-Object { $missingImages += $_ }

if ($missingImages.Count -gt 0) {
    Write-Host "Missing PNG files:" -ForegroundColor Red
    $missingImages | ForEach-Object { Write-Host "  - $_" }
}
```

### Root Cause
- Step 2 (PNG rendering) not completed
- Step 1 (Mermaid extraction) skipped
- Invalid Mermaid syntax caused rendering failures

### Solution
```powershell
# 1. Check if MMD files exist
if (!(Test-Path "mmd\*.mmd")) {
    Write-Host "Step 1 required: Extract Mermaid blocks"
    # Run extraction...
}

# 2. Render missing PNG files
Get-ChildItem "mmd\*.mmd" | ForEach-Object {
    $pngFile = "png\$($_.BaseName).png"
    if (!(Test-Path $pngFile)) {
        Write-Host "Rendering: $($_.Name)"
        mmdc -i $_.FullName -o $pngFile -b transparent -s 2
    }
}

# 3. Retry PPTX generation
pandoc processed-md-pptx\file.md -o pptx\file.pptx -t pptx --resource-path=png
```

### Prevention
- Complete Steps 1-2 before attempting Steps 4-5
- Verify PNG files exist before running Pandoc
- Check mmdc errors for Mermaid syntax problems

---

## Problem 4: DOCX Files Are Small (<50 KB)

### Symptoms
- DOCX file size unexpectedly small (10-20 KB when expecting 100+ KB)
- Opening document shows broken image links or missing diagrams
- Red X icons where images should appear

### Diagnosis
```powershell
Get-ChildItem "docx\*.docx" | ForEach-Object {
    $size = [math]::Round($_.Length / 1KB, 1)
    if ($size -lt 50) {
        Write-Host "$($_.Name): $size KB - Suspiciously small" -ForegroundColor Yellow
    }
}
```

### Root Cause
Images not embedded - missing `--resource-path=png` parameter

### Solution
```powershell
# Regenerate with correct resource path
Get-ChildItem "processed-md\*.md" | ForEach-Object {
    $output = "docx\$($_.BaseName).docx"
    
    # CRITICAL: Include --resource-path=png
    pandoc $_.FullName -o $output --resource-path=png --toc
    
    $size = [math]::Round((Get-Item $output).Length / 1KB, 1)
    Write-Host "✓ $($_.BaseName).docx - $size KB"
}
```

### Prevention
- **Always** include `--resource-path=png` parameter
- Verify file sizes after generation (>50 KB for docs with diagrams)
- Check that PNG files are in `png/` subdirectory relative to source

---

## Problem 5: List Items Appear on Same Line

### Symptoms
- Bullet points or numbered lists render as single line
- List formatting broken in DOCX/PPTX output
- Items separated by commas instead of line breaks

### Diagnosis
Check markdown source for proper list formatting:
```powershell
Get-Content "md_sources\file.md" | Select-String -Pattern "^\-\s" -Context 1
```

### Root Cause
- Missing blank line before list
- Inconsistent list marker spacing
- Mixing list styles (-, *, +)

### Solution
Edit source markdown to ensure proper formatting:

**Wrong:**
```markdown
Some text immediately before list:
- Item 1
- Item 2
```

**Correct:**
```markdown
Some text before list

- Item 1
- Item 2
```

**Also check:**
- Use consistent markers (`-` recommended)
- Include space after marker: `- Item` not `-Item`
- Ensure blank line before AND after lists

### Prevention
- Add blank lines before/after lists in source markdown
- Use linting tools to validate markdown syntax
- Test with Pandoc before committing to source control

---

## Problem 6: PNG Generation Fails

### Symptoms
- `mmdc` command fails with errors
- PNG files not created in `png/` directory
- Error messages about Puppeteer, Chrome, or syntax

### Diagnosis
```powershell
# Test mmdc directly on a single file
mmdc -i mmd\diagram.mmd -o png\test.png -b transparent -s 2

# Check mmdc installation
mmdc --version
```

### Root Cause A: mmdc Not Installed
```
Error: 'mmdc' is not recognized as an internal or external command
```

**Solution:**
```powershell
npm install -g @mermaid-js/mermaid-cli

# Verify installation
mmdc --version
```

### Root Cause B: Invalid Mermaid Syntax
```
Error: Parse error on line X
```

**Solution:**
1. Open the `.mmd` file in a text editor
2. Check Mermaid syntax at https://mermaid.live/
3. Common issues:
   - Missing closing quotes in node labels
   - Invalid arrow syntax (`->` should be `-->`)
   - Unsupported diagram type
   - Special characters not escaped

**Example fix:**
```mermaid
# Wrong
graph TB
    A[Node with "quotes] --> B

# Correct
graph TB
    A["Node with quotes"] --> B
```

### Root Cause C: Puppeteer/Chrome Issues
```
Error: Could not find Chrome
```

**Solution:**
```powershell
# Reinstall mermaid-cli with Puppeteer
npm uninstall -g @mermaid-js/mermaid-cli
npm install -g @mermaid-js/mermaid-cli

# Or specify custom Chrome path
$env:PUPPETEER_EXECUTABLE_PATH = "C:\Program Files\Google\Chrome\Application\chrome.exe"
mmdc -i input.mmd -o output.png -b transparent -s 2
```

### Prevention
- Validate Mermaid syntax at https://mermaid.live/ before committing
- Keep mermaid-cli updated: `npm update -g @mermaid-js/mermaid-cli`
- Test diagram rendering before bulk generation

---

## Problem 7: Pre-Processing Scripts Fail

### Symptoms
- `Process-VA-Markdown.ps1` throws errors
- "Could not find a part of the path" errors
- `processed-md/` or `processed-md-pptx/` directories empty

### Diagnosis
```powershell
# Check if directories exist
Test-Path "processed-md"
Test-Path "processed-md-pptx"

# Check if scripts can be found
Test-Path "C:\Users\alk\src\VA\documentation\scripts\Process-VA-Markdown.ps1"
```

### Root Cause A: Missing Directories
Scripts expect `processed-md/` and `processed-md-pptx/` to exist

**Solution:**
```powershell
# Create directories
New-Item -ItemType Directory -Force -Path "processed-md"
New-Item -ItemType Directory -Force -Path "processed-md-pptx"

# Retry scripts
& "C:\Users\alk\src\VA\documentation\scripts\Process-VA-Markdown.ps1"
& "C:\Users\alk\src\VA\documentation\scripts\Process-VA-Markdown-PPTX.ps1"
```

### Root Cause B: Working Directory Issue
Scripts assume you're in project root with `md_sources/` subdirectory

**Solution:**
```powershell
# Navigate to project directory first
cd "C:\path\to\project"

# Verify structure
if (Test-Path "md_sources") {
    Write-Host "✓ Correct location"
} else {
    Write-Host "✗ Not in project root - navigate to directory containing md_sources/"
}
```

### Root Cause C: Script Not Found
Global scripts not in expected location

**Solution:**
```powershell
# Verify global scripts exist
$scriptPath = "C:\Users\alk\src\VA\documentation\scripts"
Get-ChildItem "$scriptPath\Process-VA-*.ps1"

# If missing, copy from working project
Copy-Item "working-project\*.ps1" $scriptPath
```

### Prevention
- Use automation script: `Generate-VA-Documents.ps1` (handles directory creation)
- Always run from project root directory
- Verify global scripts installed after workspace setup

---

## Problem 8: Verification Tests Fail

### Symptoms
- Extraction tests report Mermaid code in DOCX
- Caption overlap detected in PPTX
- Files pass visual inspection but fail automated checks

### Diagnosis
This usually indicates correct diagnosis - the files ARE wrong

```powershell
# Double-check extraction
$docxContent = pandoc docx\file.docx -t markdown
$docxContent | Out-File "extracted-docx.md" -Encoding UTF8

# Open extracted-docx.md and search for 'mermaid' or 'graph TB'
code extracted-docx.md
```

### Root Cause
False sense of success - file was generated but from wrong source

### Solution
Don't ignore verification failures. Regenerate from correct source:

```powershell
# If DOCX verification fails
& "C:\Users\alk\src\VA\documentation\scripts\Process-VA-Markdown.ps1"
pandoc processed-md\file.md -o docx\file.docx --resource-path=png

# If PPTX verification fails
& "C:\Users\alk\src\VA\documentation\scripts\Process-VA-Markdown-PPTX.ps1"
pandoc processed-md-pptx\file.md -o pptx\file.pptx -t pptx --resource-path=png
```

### Prevention
- Run verification immediately after generation
- Automate verification in CI/CD pipelines
- Don't skip verification even if files "look correct"

---

## Quick Reference: Extraction Testing Pattern

Use this pattern for all document verification:

```powershell
# DOCX Verification
$docxContent = pandoc file.docx -t markdown 2>$null | Out-String
$hasMermaid = $docxContent -match 'mermaid|graph TB|graph LR'
$hasImages = $docxContent -match '!\[.*?\]\(.*?\.png\)'

if ($hasMermaid) {
    Write-Host "✗ FAIL: Contains Mermaid code" -ForegroundColor Red
} elseif (!$hasImages) {
    Write-Host "⚠ WARNING: No images found" -ForegroundColor Yellow
} else {
    Write-Host "✓ PASS: Clean DOCX" -ForegroundColor Green
}

# PPTX Verification
$pptxContent = pandoc file.pptx -t markdown 2>$null | Out-String
$hasOverlap = $pptxContent -match 'Diagram \d+\s*[\r\n]'
$hasMermaid = $pptxContent -match 'mermaid|graph TB'

if ($hasMermaid) {
    Write-Host "✗ FAIL: Contains Mermaid code" -ForegroundColor Red
} elseif ($hasOverlap) {
    Write-Host "✗ FAIL: Caption overlap detected" -ForegroundColor Red
} else {
    Write-Host "✓ PASS: Clean PPTX" -ForegroundColor Green
}
```

---

## Emergency Recovery: Complete Regeneration

If multiple problems compound, start over with clean slate:

```powershell
Write-Host "=== EMERGENCY REGENERATION ===" -ForegroundColor Red

# 1. Clean all generated files
Remove-Item "mmd\*" -Force -ErrorAction SilentlyContinue
Remove-Item "png\*" -Force -ErrorAction SilentlyContinue
Remove-Item "processed-md\*" -Force -ErrorAction SilentlyContinue
Remove-Item "processed-md-pptx\*" -Force -ErrorAction SilentlyContinue
Remove-Item "docx\*" -Force -ErrorAction SilentlyContinue
Remove-Item "pptx\*" -Force -ErrorAction SilentlyContinue

# 2. Recreate directories
New-Item -ItemType Directory -Force -Path "mmd", "png", "processed-md", "processed-md-pptx", "docx", "pptx"

# 3. Run complete workflow
& "C:\Users\alk\src\VA\documentation\scripts\Generate-VA-Documents.ps1" -Verify

Write-Host "`n✓ Emergency regeneration complete" -ForegroundColor Green
```

---

## Getting Help

If problems persist after trying solutions in this guide:

1. **Check source markdown:**
   - Valid Mermaid syntax at https://mermaid.live/
   - Proper list formatting (blank lines before/after)
   - No invalid characters or encoding issues

2. **Verify tool versions:**
   ```powershell
   pandoc --version
   mmdc --version
   node --version
   npm --version
   ```

3. **Reference working example:**
   - See `VA_0302_v8--TEST` project for proven working implementation
   - Compare file structure and script usage

4. **Consult documentation:**
   - [Document Generation Workflow](.github/skills/document-generation-workflow.md)
   - [Bug Prevention Standards](.github/standards/bugs-prevention-standard.md)

---

## Version History

| Date | Version | Changes |
|------|---------|---------|
| 2026-03-04 | 1.0 | Initial troubleshooting guide from VA_0302_v8--TEST and Q_v4 lessons |

---

**Remember:** When in doubt, run the complete workflow from scratch using `Generate-VA-Documents.ps1` with verification enabled.
