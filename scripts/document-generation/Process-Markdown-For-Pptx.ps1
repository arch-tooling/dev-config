# Pre-process markdown for PPTX - Remove image alt text to prevent overlap
# Creates processed-md-pptx/ from processed-md/ with empty alt text

Write-Host "`n=== PRE-PROCESSING FOR PPTX (Remove Image Captions) ===" -ForegroundColor Cyan

# Create output directory
if (-not (Test-Path "processed-md-pptx")) {
    New-Item -ItemType Directory -Path "processed-md-pptx" | Out-Null
}

$mdFiles = Get-ChildItem processed-md -Filter "*.md"
$totalProcessed = 0
$totalReplacements = 0

foreach ($mdFile in $mdFiles) {
    Write-Host "Processing $($mdFile.Name)..." -ForegroundColor Gray
    
    $content = Get-Content $mdFile.FullName -Raw -Encoding UTF8
    
    # Replace ![Diagram N](png/filename.png) with ![](png/filename.png)
    # This prevents "Diagram N" from appearing as overlapping text in PPTX slides
    $newContent = $content -replace "!\[Diagram \d+\]\(", "![](" 
    
    # Count replacements
    $matches = [regex]::Matches($content, "!\[Diagram \d+\]")
    $replacementCount = $matches.Count
    $totalReplacements += $replacementCount
    
    # Save processed file
    $outPath = "processed-md-pptx\$($mdFile.Name)"
    $newContent | Out-File $outPath -Encoding UTF8
    $totalProcessed++
    
    if ($replacementCount -gt 0) {
        Write-Host "  Removed $replacementCount diagram captions" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Processed $totalProcessed MD files for PPTX" -ForegroundColor Green
Write-Host "Removed $totalReplacements diagram captions to prevent slide overlap" -ForegroundColor Green
Write-Host "Output: processed-md-pptx/" -ForegroundColor Green
