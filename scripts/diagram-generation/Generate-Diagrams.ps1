<#
.SYNOPSIS
Generate PNG diagrams from Mermaid source files for VA documentation.

.DESCRIPTION
This script finds all .mmd Mermaid source files in the VA documentation tree and generates
high-resolution PNG diagrams at 2x scale for embedding in Word documents.

.PARAMETER Scale
Scale factor for PNG generation (2 or 3). Default: 2 (standard resolution).
Use 3 for complex diagrams with 16+ nodes.

.PARAMETER Force
Regenerate all diagrams even if PNG already exists. Use this to refresh all diagrams
after updating Mermaid source files or changing scale factor.

.PARAMETER Path
Base path to search for .mmd files. Default: documentation

.EXAMPLE
.\Generate-VA-Diagrams.ps1
Generate all VA diagrams at 2x resolution (default)

.EXAMPLE
.\Generate-VA-Diagrams.ps1 -Scale 3 -Force
Regenerate all diagrams at 3x resolution (for complex architecture diagrams)

.EXAMPLE
.\Generate-VA-Diagrams.ps1 -Path "documentation\OUT-DESIGN" -Force  
Regenerate only diagrams in OUT-DESIGN directory

.NOTES
Requires: @mermaid-js/mermaid-cli (mmdc command)
Install: npm install -g @mermaid-js/mermaid-cli
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet(2, 3)]
    [int]$Scale = 2,
    
    [Parameter(Mandatory=$false)]
    [switch]$Force,
    
    [Parameter(Mandatory=$false)]
    [string]$Path = "documentation"
)

Write-Host "Generating VA Documentation Diagrams" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Scale Factor: ${Scale}x" -ForegroundColor White
Write-Host "Search Path: $Path" -ForegroundColor White
Write-Host ""

# Check if mmdc is available
try {
    $mmdcVersion = & mmdc --version 2>&1
    Write-Host "mermaid-cli version: $mmdcVersion" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "ERROR: mmdc command not found!" -ForegroundColor Red
    Write-Host "Install with: npm install -g @mermaid-js/mermaid-cli" -ForegroundColor Yellow
    exit 1
}

# Find all .mmd files
$mmdFiles = Get-ChildItem -Path $Path -Recurse -Filter "*.mmd" -ErrorAction SilentlyContinue

if ($mmdFiles.Count -eq 0) {
    Write-Host "No Mermaid source files (.mmd) found in $Path" -ForegroundColor Yellow
    exit 0
}

Write-Host "Found $($mmdFiles.Count) Mermaid source file(s)" -ForegroundColor Green
Write-Host ""

$generated = 0
$skipped = 0
$failed = 0

foreach ($mmd in $mmdFiles) {
    $pngFile = $mmd.FullName -replace '\.mmd$', '.png'
    $relativePath = $mmd.FullName -replace [regex]::Escape($PWD), '.'
    
    Write-Host "Processing: $relativePath" -ForegroundColor Yellow
    
    # Check if PNG exists and Force not specified
    if ((Test-Path $pngFile) -and -not $Force) {
        Write-Host "  → PNG exists, skipping (use -Force to regenerate)" -ForegroundColor Gray
        $skipped++
        continue
    }
    
    try {
        # Generate PNG at specified scale with transparent background
        $null = & mmdc -i $mmd.FullName -o $pngFile -s $Scale -b transparent 2>&1
        
        if ($LASTEXITCODE -eq 0 -and (Test-Path $pngFile)) {
            $pngSize = (Get-Item $pngFile).Length
            $pngSizeKB = [math]::Round($pngSize / 1KB, 1)
            
            # Check image dimensions
            try {
                $img = [System.Drawing.Image]::FromFile($pngFile)
                $dimensions = "$($img.Width)x$($img.Height)"
                $img.Dispose()
                Write-Host "  ✅ Generated: $pngSizeKB KB ($dimensions)" -ForegroundColor Green
            } catch {
                Write-Host "  ✅ Generated: $pngSizeKB KB" -ForegroundColor Green
            }
            
            $generated++
        } else {
            Write-Host "  ❌ Failed: PNG not generated" -ForegroundColor Red
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
Write-Host "Generated: $generated" -ForegroundColor Green
Write-Host "Skipped:   $skipped" -ForegroundColor Gray
Write-Host "Failed:    $failed" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Green" })

if ($generated -gt 0) {
    Write-Host ""
    Write-Host "✅ Diagram generation complete!" -ForegroundColor Green
    Write-Host "Next step: Regenerate Word documents to embed new diagrams" -ForegroundColor White
}

if ($failed -gt 0) {
    Write-Host ""
    Write-Host "⚠️  Some diagrams failed to generate. Check Mermaid syntax." -ForegroundColor Yellow
}
