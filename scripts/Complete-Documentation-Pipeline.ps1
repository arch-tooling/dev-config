<#
.SYNOPSIS
Complete VA documentation generation pipeline: diagrams + Word documents.

.DESCRIPTION
This script runs the complete VA documentation generation workflow:
1. Generate all PNG diagrams from Mermaid source files (.mmd)
2. Convert all markdown files to Word documents (.docx) with embedded diagrams

.PARAMETER Scale
Scale factor for diagram generation (2 or 3). Default: 2

.PARAMETER Path
Base path for documentation. Default: documentation

.PARAMETER Force
Force regeneration of all files (diagrams and Word documents).

.EXAMPLE
.\Complete-VA-Documentation.ps1
Generate all diagrams and Word documents

.EXAMPLE
.\Complete-VA-Documentation.ps1 -Force
Force regenerate everything

.EXAMPLE
.\Complete-VA-Documentation.ps1 -Scale 3 -Force
Regenerate with 3x scale diagrams

.NOTES
Requires: 
- @mermaid-js/mermaid-cli (mmdc)
- Pandoc 2.x+
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet(2, 3)]
    [int]$Scale = 2,
    
    [Parameter(Mandatory=$false)]
    [string]$Path = "documentation",
    
    [Parameter(Mandatory=$false)]
    [switch]$Force
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Complete VA Documentation Generation" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will:" -ForegroundColor White
Write-Host "  1. Generate PNG diagrams from Mermaid source" -ForegroundColor White
Write-Host "  2. Convert markdown to Word documents" -ForegroundColor White
Write-Host ""

# Phase 1: Generate Diagrams
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host " Phase 1: Generating Diagrams" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

$diagramScriptPath = Join-Path $PSScriptRoot "Generate-VA-Diagrams.ps1"
if (Test-Path $diagramScriptPath) {
    if ($Force) {
        & $diagramScriptPath -Scale $Scale -Path $Path -Force
    } else {
        & $diagramScriptPath -Scale $Scale -Path $Path
    }
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "⚠️  Diagram generation had errors. Continuing with Word generation..." -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  Diagram generation script not found: $diagramScriptPath" -ForegroundColor Yellow
    Write-Host "Skipping diagram generation..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Press any key to continue to Word document generation..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Phase 2: Generate Word Documents
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host " Phase 2: Generating Word Documents" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

$wordScriptPath = Join-Path $PSScriptRoot "Generate-VA-Word-Documents.ps1"
if (Test-Path $wordScriptPath) {
    # Generate for multiple paths
    $docPaths = @(
        "documentation\OUT-DESIGN",
        "documentation\VA-Cognigy",
        "documentation"
    ) | Where-Object { Test-Path $_ }
    
    foreach ($docPath in $docPaths) {
        Write-Host "Converting documents in: $docPath" -ForegroundColor Yellow
        Write-Host ""
        
        if ($Force) {
            & $wordScriptPath -Path $docPath -Force
        } else {
            & $wordScriptPath -Path $docPath
        }
        
        Write-Host ""
    }
} else {
    Write-Host "⚠️  Word generation script not found: $wordScriptPath" -ForegroundColor Yellow
}

# Summary
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host " Generation Complete" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ VA documentation generation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Generated files:" -ForegroundColor White
Write-Host "  - PNG diagrams in diagrams/ subdirectories" -ForegroundColor Gray
Write-Host "  - Word documents (.docx) alongside markdown files" -ForegroundColor Gray
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  - Review generated Word documents" -ForegroundColor White
Write-Host "  - Check diagram quality (zoom to 200%)" -ForegroundColor White
Write-Host "  - Verify UTF-8 encoding (no garbled characters)" -ForegroundColor White
Write-Host ""
