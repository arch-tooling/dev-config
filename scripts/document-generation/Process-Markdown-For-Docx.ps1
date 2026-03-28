# Pre-process markdown files - Insert PNG refs, hide Mermaid blocks
# V3 Fixes Script

$phaseStart = Get-Date
Write-Host "`n=== PHASE 1: PRE-PROCESS MARKDOWN ===" -ForegroundColor Cyan

$mdFiles = Get-ChildItem md_sources -Filter "*.md"
$totalProcessed = 0
$totalDiagrams = 0

foreach ($mdFile in $mdFiles) {
    Write-Host "Processing $($mdFile.Name)..." -ForegroundColor Gray
    
    $content = Get-Content $mdFile.FullName -Raw -Encoding UTF8
    $basename = $mdFile.BaseName
    
    # Get matching PNG files for this document
    $pngs = Get-ChildItem png -Filter "${basename}_*.png" | Sort-Object Name
    $pngIndex = 0
    
    # Process line by line
    $newContent = ""
    $lines = $content -split "`r?`n"
    $i = 0
    $inMermaidBlock = $false
    $mermaidBlockLines = @()
    
    while ($i -lt $lines.Count) {
        $line = $lines[$i]
        
        # Start of Mermaid block
        if ($line -match '^\s*```mermaid\s*$') {
            $inMermaidBlock = $true
            $mermaidBlockLines = @()
            $i++
            continue
        }
        
        # End of Mermaid block
        if ($inMermaidBlock -and $line -match '^\s*```\s*$') {
            $inMermaidBlock = $false
            
            # Insert PNG reference (completely replace Mermaid block)
            if ($pngIndex -lt $pngs.Count) {
                $png = $pngs[$pngIndex]
                $pngIndex++
                $diagramNum = $pngIndex
                
                # Add PNG image reference ONLY - no Mermaid source
                $newContent += "![Diagram $diagramNum](png/$($png.Name))`n`n"
                
                $totalDiagrams++
            }
            
            $i++
            continue
        }
        
        # Inside Mermaid block - collect lines
        if ($inMermaidBlock) {
            $mermaidBlockLines += $line
            $i++
            continue
        }
        
        # Regular line - keep as-is
        $newContent += $line + "`n"
        $i++
    }
    
    # Save processed file
    $outPath = "processed-md\$($mdFile.Name)"
    $newContent | Out-File $outPath -Encoding UTF8
    $totalProcessed++
}

# Report
$duration = ((Get-Date) - $phaseStart).TotalMinutes
$velocity = $totalProcessed / $duration
$elapsed = ((Get-Date) - $global:fixStartTime).TotalMinutes

Write-Host ""
Write-Host "✓ Processed $totalProcessed MD files" -ForegroundColor Green
Write-Host "✓ Replaced $totalDiagrams Mermaid blocks with PNG refs" -ForegroundColor Green
Write-Host "⏱ Phase 1: $([math]::Round($duration, 1)) min ($([math]::Round($velocity, 1)) files/min)" -ForegroundColor Yellow
Write-Host "⏱ Total elapsed: $([math]::Round($elapsed, 1)) min" -ForegroundColor Yellow
