<#
.SYNOPSIS
Generate Word documents from markdown files for VA documentation.

.DESCRIPTION
This script converts all markdown files in the VA documentation tree to Word (.docx) format
using Pandoc with consistent formatting and diagram embedding.

.PARAMETER Path
Base path to search for .md files. Default: documentation\OUT-DESIGN

.PARAMETER PandocDefaults
Path to Pandoc defaults file. Default: documentation\pandoc-defaults\docx.yaml

.PARAMETER ResourcePath
Path to diagrams directory for image embedding. Default: diagrams

.PARAMETER Force
Regenerate all documents even if .docx already exists and is newer than .md source.

.PARAMETER FileFilter
Filter for markdown files to convert. Default: *.md

.EXAMPLE
.\Generate-VA-Word-Documents.ps1
Convert all markdown files in OUT-DESIGN to Word using centralized defaults

.EXAMPLE
.\Generate-VA-Word-Documents.ps1 -Force
Force regenerate all Word documents

.EXAMPLE
.\Generate-VA-Word-Documents.ps1 -Path "documentation\OUT-DESIGN" -FileFilter "VA-*.md"
Convert only files starting with VA- in OUT-DESIGN directory

.EXAMPLE
.\Generate-VA-Word-Documents.ps1 -PandocDefaults "documentation\VA-Cognigy\pandoc-defaults\docx.yaml"
Use project-specific Pandoc defaults instead of centralized

.NOTES
Requires: Pandoc 2.x or higher
Install: https://pandoc.org/installing.html

Uses centralized Pandoc defaults: documentation\pandoc-defaults\docx.yaml
For project-specific defaults, see: documentation\VA-Cognigy\pandoc-defaults\docx.yaml
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$Path = "documentation\OUT-DESIGN",
    
    [Parameter(Mandatory=$false)]
    [string]$PandocDefaults = "documentation\pandoc-defaults\docx.yaml",
    
    [Parameter(Mandatory=$false)]
    [string]$ResourcePath = "diagrams",
    
    [Parameter(Mandatory=$false)]
    [switch]$Force,
    
    [Parameter(Mandatory=$false)]
    [string]$FileFilter = "*.md"
)

Write-Host "Generating VA Word Documents" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Write-Host "Source Path: $Path" -ForegroundColor White
Write-Host "File Filter: $FileFilter" -ForegroundColor White
Write-Host ""

# Check if Pandoc is available
try {
    $pandocVersion = & pandoc --version 2>&1 | Select-Object -First 1
    Write-Host "Pandoc version: $pandocVersion" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "ERROR: pandoc command not found!" -ForegroundColor Red
    Write-Host "Install from: https://pandoc.org/installing.html" -ForegroundColor Yellow
    exit 1
}

# Check if Pandoc defaults file exists
if (-not (Test-Path $PandocDefaults)) {
    Write-Host "WARNING: Pandoc defaults file not found: $PandocDefaults" -ForegroundColor Yellow
    Write-Host "Will use Pandoc defaults..." -ForegroundColor Yellow
    $useDefaults = $false
} else {
    Write-Host "Using Pandoc defaults: $PandocDefaults" -ForegroundColor Green
    $useDefaults = $true
}

Write-Host ""

# Find all markdown files
$mdFiles = Get-ChildItem -Path $Path -Filter $FileFilter -Recurse -ErrorAction SilentlyContinue | 
    Where-Object { $_.Name -notmatch '^_' -and $_.DirectoryName -notmatch 'node_modules|\.git' }

if ($mdFiles.Count -eq 0) {
    Write-Host "No markdown files found matching filter: $FileFilter" -ForegroundColor Yellow
    exit 0
}

Write-Host "Found $($mdFiles.Count) markdown file(s)" -ForegroundColor Green
Write-Host ""

$converted = 0
$skipped = 0
$failed = 0

foreach ($md in $mdFiles) {
    $docxFile = $md.FullName -replace '\.md$', '.docx'
    $relativePath = $md.FullName -replace [regex]::Escape($PWD), '.'
    
    Write-Host "Processing: $relativePath" -ForegroundColor Yellow
    
    # Check if .docx exists and is newer than .md (unless Force specified)
    if ((Test-Path $docxFile) -and -not $Force) {
        $mdModified = $md.LastWriteTime
        $docxModified = (Get-Item $docxFile).LastWriteTime
        
        if ($docxModified -gt $mdModified) {
            Write-Host "  → Word document is up to date, skipping (use -Force to regenerate)" -ForegroundColor Gray
            $skipped++
            continue
        }
    }
    
    try {
        # Build Pandoc command
        $pandocArgs = @()
        $pandocArgs += $md.FullName
        $pandocArgs += "-o"
        $pandocArgs += $docxFile
        
        if ($useDefaults) {
            $pandocArgs += "--defaults"
            $pandocArgs += $PandocDefaults
        } else {
            # Fallback to basic options
            $pandocArgs += "--standalone"
            $pandocArgs += "--toc"
            $pandocArgs += "--number-sections"
        }
        
        # Add resource path for diagram embedding
        $diagramPath = Join-Path (Split-Path $md.FullName) $ResourcePath
        if (Test-Path $diagramPath) {
            $pandocArgs += "--resource-path"
            $pandocArgs += $diagramPath
        }
        
        # Execute Pandoc
        $output = & pandoc $pandocArgs 2>&1
        
        if ($LASTEXITCODE -eq 0 -and (Test-Path $docxFile)) {
            $docxSize = (Get-Item $docxFile).Length
            $docxSizeKB = [math]::Round($docxSize / 1KB, 1)
            Write-Host "  ✅ Generated: $docxSizeKB KB" -ForegroundColor Green
            $converted++
        } else {
            Write-Host "  ❌ Failed: $output" -ForegroundColor Red
            $failed++
        }
    } catch {
        Write-Host "  ❌ Error: $_" -ForegroundColor Red
        $failed++
    }
    
    Write-Host ""
}

Write-Host "Summary" -ForegroundColor Cyan
Write-Host "-------" -ForegroundColor Cyan
Write-Host "Converted: $converted" -ForegroundColor Green
Write-Host "Skipped:   $skipped" -ForegroundColor Gray
Write-Host "Failed:    $failed" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Green" })

if ($converted -gt 0) {
    Write-Host ""
    Write-Host "✅ Word document generation complete!" -ForegroundColor Green
    Write-Host "Output location: $Path" -ForegroundColor White
}

if ($failed -gt 0) {
    Write-Host ""
    Write-Host "⚠️  Some documents failed to convert. Check markdown syntax." -ForegroundColor Yellow
}
