# Document Generation Workflow Standards

**Priority:** CRITICAL  
**Applies to:** All DOCX/PPTX generation from markdown with Mermaid diagrams  
**Last Updated:** March 4, 2026

---

## Overview

This document defines the **mandatory workflow** for generating Word and PowerPoint documents from markdown sources containing Mermaid diagrams.

**Critical Rule:** NEVER use direct Pandoc conversion from markdown with Mermaid blocks. Always use the 6-step preprocessing workflow.

---

## The Complete 6-Step Workflow

```
md_sources/*.md (with Mermaid)
    ↓
Step 1: Extract Mermaid → mmd/*.mmd
Step 2: Render PNG → png/*.png (2x resolution, transparent background)
Step 3: Pre-process MD → processed-md/ (Mermaid blocks → PNG refs)
Step 3B: Pre-process PPTX → processed-md-pptx/ (remove captions)
Step 4: Generate DOCX ← processed-md/
Step 5: Generate PPTX ← processed-md-pptx/
```

---

## Step-by-Step Implementation

### Step 1: Extract Mermaid Blocks

**Purpose:** Extract Mermaid diagram source code to separate `.mmd` files

**PowerShell script:**
```powershell
# Create output directory
New-Item -ItemType Directory -Force -Path "mmd" | Out-Null

# Extract from each markdown file
Get-ChildItem "md_sources\*.md" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $basename = $_.BaseName
    $diagramIndex = 1
    
    # Find all ```mermaid blocks
    $matches = [regex]::Matches($content, '(?s)```mermaid\s*\r?\n(.*?)\r?\n```')
    
    foreach ($match in $matches) {
        $mermaidCode = $match.Groups[1].Value
        $outputFile = "mmd\${basename}_diagram_$('{0:D2}' -f $diagramIndex).mmd"
        $mermaidCode | Out-File $outputFile -Encoding UTF8
        Write-Host "Extracted: $outputFile"
        $diagramIndex++
    }
}
```

**Expected output:** Multiple `.mmd` files in `mmd/` directory

---

### Step 2: Render Mermaid to PNG

**Purpose:** Convert `.mmd` files to high-resolution PNG images

**Requirements:**
- @mermaid-js/mermaid-cli installed globally: `npm install -g @mermaid-js/mermaid-cli`
- Puppeteer dependencies available

**PowerShell script:**
```powershell
# Create output directory
New-Item -ItemType Directory -Force -Path "png" | Out-Null

# Render each MMD file
Get-ChildItem "mmd\*.mmd" | ForEach-Object {
    $inputFile = $_.FullName
    $outputFile = "png\$($_.BaseName).png"
    
    # mmdc: -b transparent (background), -s 2 (2x scale for high resolution)
    & mmdc -i $inputFile -o $outputFile -b transparent -s 2
    
    if (Test-Path $outputFile) {
        $size = [math]::Round((Get-Item $outputFile).Length / 1KB, 1)
        Write-Host "✓ Generated: $outputFile ($size KB)" -ForegroundColor Green
    }
}
```

**Expected output:** PNG files in `png/` directory (60-300 KB each at 2x resolution)

---

### Step 3: Pre-process Markdown for DOCX

**Purpose:** Replace Mermaid blocks with PNG image references for DOCX generation

**⚠️ CRITICAL:** The Mermaid blocks MUST be **completely removed**, not just hidden or commented out. Otherwise, Word documents will contain both the image AND the raw Mermaid code.

**Use global script:**
```powershell
& "C:\Users\alk\src\VA\documentation\scripts\Process-VA-Markdown.ps1"
```

**What it does:**
1. Reads markdown files from `md_sources/`
2. Detects ```mermaid blocks using state machine parser
3. **Completely removes** Mermaid content
4. Inserts PNG reference: `![Diagram N](png/filename.png)`
5. Saves to `processed-md/` directory

**Key logic pattern:**
```powershell
if ($line -match '^\s*```mermaid\s*$') {
    $inMermaidBlock = $true
    $i++
    continue  # Skip block start
}
if ($inMermaidBlock -and $line -match '^\s*```\s*$') {
    # INSERT PNG REFERENCE ONLY - NO MERMAID SOURCE
    $newContent += "![Diagram $pngIndex](png/$($png.Name))`n`n"
    $i++
    continue  # Skip block end
}
if ($inMermaidBlock) {
    $i++
    continue  # SKIP all Mermaid content
}
$newContent += $line + "`n"  # Keep regular lines
```

**Expected output:** Markdown files in `processed-md/` with PNG references, no Mermaid blocks

---

### Step 3B: Pre-process Markdown for PPTX

**Purpose:** Remove image captions to prevent text overlap in PowerPoint slides

**Problem:** In PPTX format, `![Diagram 1](png/file.png)` creates a text box containing "Diagram 1" that overlaps the image on slides.

**Solution:** Convert to empty alt text `![](png/file.png)`

**Use global script:**
```powershell
& "C:\Users\alk\src\VA\documentation\scripts\Process-VA-Markdown-PPTX.ps1"
```

**What it does:**
1. Reads markdown files from `processed-md/`
2. Replaces `![Diagram \d+](` with `![](` using regex
3. Saves to `processed-md-pptx/` directory

**Key logic:**
```powershell
$content = Get-Content $mdFile.FullName -Raw -Encoding UTF8
$newContent = $content -replace "!\[Diagram \d+\]\(", "![]("
$newContent | Out-File "processed-md-pptx\$($mdFile.Name)" -Encoding UTF8
```

**Expected output:** Markdown files in `processed-md-pptx/` without diagram captions

---

### Step 4: Generate DOCX

**Purpose:** Convert pre-processed markdown to Word documents

**⚠️ CRITICAL:** MUST use `processed-md/` as source, NEVER `md_sources/`

**PowerShell script:**
```powershell
# Create output directory
New-Item -ItemType Directory -Force -Path "docx" | Out-Null

# Generate each DOCX
Get-ChildItem "processed-md\*.md" | ForEach-Object {
    $inputFile = $_.FullName
    $outputFile = "docx\$($_.BaseName).docx"
    
    pandoc $inputFile -o $outputFile `
        --resource-path=png `
        --toc `
        --reference-doc="path\to\template.docx"  # Optional
    
    if (Test-Path $outputFile) {
        $size = [math]::Round((Get-Item $outputFile).Length / 1KB, 1)
        Write-Host "✓ Generated: $outputFile ($size KB)" -ForegroundColor Green
    }
}
```

**Expected output:** DOCX files in `docx/` directory (>50 KB with embedded images)

---

### Step 5: Generate PPTX

**Purpose:** Convert PPTX-optimized markdown to PowerPoint presentations

**⚠️ CRITICAL:** MUST use `processed-md-pptx/` as source, NEVER `processed-md/` or `md_sources/`

**PowerShell script:**
```powershell
# Create output directory
New-Item -ItemType Directory -Force -Path "pptx" | Out-Null

# Generate each PPTX
Get-ChildItem "processed-md-pptx\*.md" | ForEach-Object {
    $inputFile = $_.FullName
    $outputFile = "pptx\$($_.BaseName).pptx"
    
    pandoc $inputFile -o $outputFile `
        -t pptx `
        --resource-path=png `
        --reference-doc="path\to\template.pptx"  # Optional
    
    if (Test-Path $outputFile) {
        $size = [math]::Round((Get-Item $outputFile).Length / 1KB, 1)
        Write-Host "✓ Generated: $outputFile ($size KB)" -ForegroundColor Green
    }
}
```

**Expected output:** PPTX files in `pptx/` directory (>50 KB with embedded images)

---

## Critical Rules

### Rule 1: Source Directory Must Match Output Format

| Output Format | Source Directory | Reason |
|---------------|------------------|--------|
| DOCX | `processed-md/` | Needs captions for accessibility |
| PPTX | `processed-md-pptx/` | Captions cause text overlap on slides |

**NEVER:**
- ❌ Generate DOCX from `md_sources/` → Contains Mermaid code
- ❌ Generate PPTX from `processed-md/` → Causes caption overlap
- ❌ Generate PPTX from `md_sources/` → Both problems at once

### Rule 2: Mermaid Blocks Must Be Completely Removed

**WRONG approaches:**
```markdown
<!-- Mermaid code hidden in HTML comment -->
![Diagram](png/file.png)
```

**CORRECT approach:**
```markdown
![Diagram](png/file.png)

[No Mermaid code anywhere]
```

### Rule 3: Always Verify Outputs

**Never assume generation succeeded.** Extract and inspect:

```powershell
# Check DOCX for Mermaid code (MUST be absent)
$docxContent = pandoc docx\file.docx -t markdown
if ($docxContent -match 'graph TB|```mermaid|graph LR') {
    Write-Host "❌ FAIL: DOCX contains Mermaid code" -ForegroundColor Red
}

# Check PPTX for caption overlap (MUST be absent)
$pptxContent = pandoc pptx\file.pptx -t markdown
if ($pptxContent -match 'Diagram \d+\s*[\r\n]') {
    Write-Host "❌ FAIL: PPTX has caption overlap" -ForegroundColor Red
}
```

---

## Directory Structure

**Complete project structure:**
```
project/
├── md_sources/          [INPUT] Original markdown with Mermaid blocks
│   ├── document1.md
│   ├── document2.md
│   └── document3.md
│
├── mmd/                 [TEMP] Extracted Mermaid source files
│   ├── document1_diagram_01.mmd
│   ├── document1_diagram_02.mmd
│   └── document2_diagram_01.mmd
│
├── png/                 [OUTPUT] Rendered PNG diagrams (2x resolution)
│   ├── document1_diagram_01.png
│   ├── document1_diagram_02.png
│   └── document2_diagram_01.png
│
├── processed-md/        [TEMP] DOCX-ready markdown (Mermaid → PNG refs, with captions)
│   ├── document1.md
│   ├── document2.md
│   └── document3.md
│
├── processed-md-pptx/   [TEMP] PPTX-ready markdown (PNG refs, no captions)
│   ├── document1.md
│   ├── document2.md
│   └── document3.md
│
├── docx/                [OUTPUT] Word documents
│   ├── document1.docx
│   ├── document2.docx
│   └── document3.docx
│
└── pptx/                [OUTPUT] PowerPoint presentations
    ├── document1.pptx
    ├── document2.pptx
    └── document3.pptx
```

**Total files:** For N source files with M diagrams:
- N markdown sources
- M MMD files
- M PNG files
- N processed-md files
- N processed-md-pptx files
- N DOCX files
- N PPTX files

---

## Verification Checklist

After generation, verify each output:

### ✓ Processed Markdown Files

```powershell
# Check processed-md/ has NO Mermaid blocks
Get-ChildItem "processed-md\*.md" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match '```mermaid') {
        Write-Host "❌ $($_.Name) still contains Mermaid blocks" -ForegroundColor Red
    }
}
```

### ✓ PNG Files Generated

```powershell
# Check all PNG files exist and have reasonable size
Get-ChildItem "png\*.png" | ForEach-Object {
    $size = [math]::Round($_.Length / 1KB, 1)
    if ($size -lt 10) {
        Write-Host "⚠️ $($_.Name) is suspiciously small ($size KB)" -ForegroundColor Yellow
    }
}
```

### ✓ DOCX Files Quality

```powershell
# Extract DOCX to markdown and verify NO Mermaid code
Get-ChildItem "docx\*.docx" | ForEach-Object {
    $extracted = pandoc $_.FullName -t markdown | Out-String
    
    if ($extracted -match 'graph TB|```mermaid|graph LR') {
        Write-Host "❌ $($_.Name) contains Mermaid code (wrong source used)" -ForegroundColor Red
    }
    
    $size = [math]::Round($_.Length / 1KB, 1)
    if ($size -lt 50) {
        Write-Host "⚠️ $($_.Name) is small ($size KB) - images may not be embedded" -ForegroundColor Yellow
    }
}
```

### ✓ PPTX Files Quality

```powershell
# Extract PPTX to markdown and verify NO caption overlap
Get-ChildItem "pptx\*.pptx" | ForEach-Object {
    $extracted = pandoc $_.FullName -t markdown | Out-String
    
    if ($extracted -match 'Diagram \d+\s*[\r\n]') {
        Write-Host "❌ $($_.Name) has caption overlap (used processed-md instead of processed-md-pptx)" -ForegroundColor Red
    }
    
    if ($extracted -match 'graph TB|```mermaid') {
        Write-Host "❌ $($_.Name) contains Mermaid code (wrong source used)" -ForegroundColor Red
    }
    
    $size = [math]::Round($_.Length / 1KB, 1)
    if ($size -lt 50) {
        Write-Host "⚠️ $($_.Name) is small ($size KB) - images may not be embedded" -ForegroundColor Yellow
    }
}
```

---

## Common Problems and Fixes

### Problem 1: DOCX Contains Mermaid Code

**Symptoms:**
- Opening Word document shows both image and code blocks
- Code like `graph TB`, `A --> B` appears as text

**Diagnosis:**
```powershell
$content = pandoc docx\file.docx -t markdown
if ($content -match 'mermaid') { "FAIL: Contains Mermaid" }
```

**Root Cause:** Generated from `md_sources/` instead of `processed-md/`

**Fix:**
```powershell
# Re-run Step 3 (pre-processing)
& "C:\Users\alk\src\VA\documentation\scripts\Process-VA-Markdown.ps1"

# Regenerate DOCX from processed-md/
pandoc processed-md\file.md -o docx\file.docx --resource-path=png
```

---

### Problem 2: PPTX Has Text Overlapping Images

**Symptoms:**
- Text boxes with "Diagram 1", "Diagram 2" appear on slides
- Text overlaps the diagram images

**Diagnosis:**
```powershell
$content = pandoc pptx\file.pptx -t markdown
if ($content -match 'Diagram \d+') { "FAIL: Caption overlap" }
```

**Root Cause:** Generated from `processed-md/` instead of `processed-md-pptx/`

**Fix:**
```powershell
# Re-run Step 3B (PPTX pre-processing)
& "C:\Users\alk\src\VA\documentation\scripts\Process-VA-Markdown-PPTX.ps1"

# Regenerate PPTX from processed-md-pptx/
pandoc processed-md-pptx\file.md -o pptx\file.pptx -t pptx --resource-path=png
```

---

### Problem 3: PPTX Generation Fails with "File not found"

**Symptoms:**
- Pandoc error: "Could not find image 'png/diagram.png'"
- PPTX file not created

**Root Cause:** Missing PNG files (Step 2 not completed)

**Fix:**
```powershell
# Verify PNG files exist
Get-ChildItem "png\*.png"

# If missing, re-run Step 2
Get-ChildItem "mmd\*.mmd" | ForEach-Object {
    mmdc -i $_.FullName -o "png\$($_.BaseName).png" -b transparent -s 2
}
```

---

### Problem 4: DOCX Files Are Small (<50 KB)

**Symptoms:**
- DOCX file size unexpectedly small
- Opening shows broken image links instead of embedded images

**Root Cause:** Images not embedded (missing `--resource-path=png`)

**Fix:**
```powershell
# Regenerate with correct resource path
pandoc processed-md\file.md -o docx\file.docx --resource-path=png
```

---

### Problem 5: List Items Appear on Same Line

**Symptoms:**
- Bullet points or numbered lists render as single line
- List formatting broken in output

**Root Cause:** Markdown formatting issues or Pandoc version

**Fix:**
```powershell
# Check Pandoc version (need 3.0+)
pandoc --version

# Ensure blank line before lists in markdown
# WRONG:
# Some text
# - Item 1

# CORRECT:
# Some text
# 
# - Item 1
```

---

## Anti-Patterns (Never Do This)

### ❌ Direct Pandoc Conversion
```powershell
# DON'T DO THIS
pandoc md_sources\file.md -o docx\file.docx
# Result: Mermaid code appears as text blocks
```

### ❌ Same Source for DOCX and PPTX
```powershell
# DON'T DO THIS
pandoc processed-md\file.md -o docx\file.docx  # OK
pandoc processed-md\file.md -o pptx\file.pptx  # WRONG - caption overlap
```

### ❌ Skipping Verification
```powershell
# DON'T DO THIS
pandoc ... -o output.docx
# Ship it without checking!
```

### ❌ Keeping Mermaid in Comments
```markdown
<!-- graph TB
    A --> B
-->
![Diagram](png/file.png)
```
**Result:** Pandoc may still include the commented code

---

## Global Script Locations

**Script directory:** `C:\Users\alk\src\VA\documentation\scripts\`

**Available scripts:**
- `Process-VA-Markdown.ps1` - Step 3: Pre-process for DOCX
- `Process-VA-Markdown-PPTX.ps1` - Step 3B: Pre-process for PPTX
- `Generate-VA-Documents.ps1` - Complete workflow automation (coming soon)

**Usage from any project:**
```powershell
# Navigate to project directory
cd "C:\path\to\project"

# Run global scripts
& "C:\Users\alk\src\VA\documentation\scripts\Process-VA-Markdown.ps1"
& "C:\Users\alk\src\VA\documentation\scripts\Process-VA-Markdown-PPTX.ps1"
```

---

## Related Documentation

- [Mermaid Diagram Standards](mermaid-diagram-standards.md) - Syntax and quality standards
- [Diagram Generation Standards](diagram-generation-standards.md) - Resolution requirements (2x/3x)
- [UTF-8 Encoding Standards](utf8-encoding-standards.md) - Character encoding rules
- [Document Styles](document-styles.md) - TOC and formatting standards

---

## Quick Reference Card

```
INPUT:  md_sources/*.md (with Mermaid)
STEP 1: Extract → mmd/*.mmd
STEP 2: Render → png/*.png (mmdc -s 2 -b transparent)
STEP 3: Process → processed-md/ (Mermaid REMOVED, PNG refs added)
STEP 3B: Process → processed-md-pptx/ (captions removed)
STEP 4: Generate → docx/*.docx (from processed-md/)
STEP 5: Generate → pptx/*.pptx (from processed-md-pptx/)
VERIFY: Extract to markdown, check for Mermaid/captions
```

**Never:**
- Use md_sources/ as Pandoc input
- Use processed-md/ for PPTX generation
- Skip verification steps

**Always:**
- Pre-process markdown before generation
- Use separate sources for DOCX vs PPTX
- Extract and verify actual content

---

## Version History

| Date | Version | Changes |
|------|---------|---------|
| 2026-03-04 | 1.0 | Initial global standard from VA_0302_v8--TEST lessons |

---

**Questions or Issues?** See [troubleshooting-docgen.md](troubleshooting-docgen.md) (coming soon) or refer to VA_0302_v8--TEST implementation as reference.
