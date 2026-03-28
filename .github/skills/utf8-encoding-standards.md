````markdown
# UTF-8 Encoding Standards - VA Project

**Purpose**: Prevent garbled UTF-8 characters in generated VA documentation

**Priority**: CRITICAL - Apply to all document generation tasks

**Last Updated**: February 24, 2026

---

## Overview

All markdown and text files MUST use UTF-8 encoding without BOM (Byte Order Mark). Improper encoding causes characters like →, ✅, ❌ to appear as garbled sequences like `â†'`, `âœ…`, `âŒ`.

---

## Mandatory Rules

### 1. File Encoding
- **ALWAYS** use UTF-8 without BOM
- **NEVER** use Windows-1252, Latin-1, or ANSI encoding
- Verify encoding when reading/writing files programmatically

### 2. Unicode Character Usage
Use proper Unicode characters directly in markdown:

**Approved Characters:**
- **→** (U+2192) - Right arrow for flows/transitions
- **✅** (U+2705) - Check mark button for "yes" or "done"
- **❌** (U+274C) - Cross mark for "no" or "blocked"
- **✓** (U+2713) - Check mark for "valid" or "correct"
- **✗** (U+2717) - Ballot X for "invalid" or "incorrect"
- **•** (U+2022) - Bullet point

**How to Insert:**
```
Direct insertion: → ✅ ❌ ✓ ✗ •
HTML entities: &rarr; &#x2705; &#x274C; &#x2713; &#x2717; &bull;
Markdown: Use direct Unicode (recommended)
```

### 3. Common Pitfalls to AVOID

❌ **DO NOT:**
- Copy-paste from Word documents (may introduce wrong encoding)
- Use HTML entities like `&rarr;` `&check;` in markdown tables
- Mix encoding types within same file
- Use ASCII alternatives like `->`, `[x]`, `[ ]` when Unicode is intended
- Write files without explicitly specifying UTF-8 encoding

✅ **DO:**
- Type Unicode characters directly: `→`, `✅`, `❌`
- Use UTF-8 encoding explicitly in all file operations
- Test rendering in VS Code and Word before finalizing
- Verify character appearance after Pandoc conversion

---

## Implementation Guidelines

### For AI Assistants

When generating markdown documents:

1. **Character Selection:**
   ```markdown
   # Correct
   - VA Client → Cognigy Platform
   - ✅ Implemented
   - ❌ Blocked
   
   # Incorrect (ASCII substitutes)
   - VA Client -> Cognigy Platform
   - [x] Implemented
   - [X] Blocked
   ```

2. **Table Formatting:**
   ```markdown
   | Component | Status |
   |-----------|--------|
   | Cognigy API | ✅ Done |
   | TIPS Integration | ❌ Blocked |
   ```

3. **Lists with Symbols:**
   ```markdown
   Advantages:
   - ✅ High performance
   - ✅ Easy to integrate
   
   Disadvantages:
   - ❌ High cost
   - ❌ Complex configuration
   ```

### For PowerShell Scripts

```powershell
# Always specify UTF-8 without BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)

# Or use Set-Content with UTF8 encoding
$content | Set-Content -Path $file -Encoding UTF8
```

### For Python Scripts

```python
# Always specify UTF-8 encoding
with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

# For read operations
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()
```

### For Pandoc Conversions

Pandoc automatically handles UTF-8 correctly when:
- Input files are UTF-8 encoded
- No encoding conversion flags are used
- Default Unicode handling is enabled (default in Pandoc 3.x)

```powershell
# Simple conversion - UTF-8 preserved
pandoc -f markdown -t docx -o output.docx input.md

# With diagram embedding - UTF-8 preserved
pandoc -f markdown -t docx -o output.docx input.md --resource-path=diagrams

# With custom config (if exists) - UTF-8 preserved
pandoc -f markdown -t docx -o output.docx input.md -d docx.yaml --resource-path=diagrams
```

**UTF-8 Verification After Conversion:**
1. Open generated .docx in Word
2. Check that → displays as arrow (not â†')
3. Check that ✅ displays as checkmark (not âœ…)
4. Check that ❌ displays as cross mark (not âŒ)

---

## Character Reference Table

| Symbol | Unicode | Hex Code | Common Use in VA | Garbled Appearance |
|--------|---------|----------|------------------|-------------------|
| → | U+2192 | E2 86 92 | Flow/data direction | â†' |
| ✅ | U+2705 | E2 9C 85 | Approved/completed | âœ… |
| ❌ | U+274C | E2 9D 8C | Rejected/blocked | âŒ |
| ✓ | U+2713 | E2 9C 93 | Check/validated | âœ" |
| ✗ | U+2717 | E2 9C 97 | X/invalid | âœ— |
| • | U+2022 | E2 80 A2 | Bullet point | â€¢ |
| — | U+2014 | E2 80 94 | Em dash | â€" |
| – | U+2013 | E2 80 93 | En dash | â€" |

**Detection Pattern:**
If you see sequences like `â`, `€`, `œ`, `Œ`, `Å` followed by special characters, the file has encoding corruption.

---

## Validation Steps

Before finalizing any VA document:

1. **VS Code Check:**
   - Look at bottom-right corner: should show "UTF-8"
   - If it shows "UTF-8 with BOM", convert to "UTF-8"

2. **Visual Inspection:**
   - Search for patterns: `â†`, `âœ`, `âŒ`
   - All arrows should display as: →
   - All checkmarks should display as: ✅ or ✓
   - All X marks should display as: ❌ or ✗

3. **Pandoc Conversion Test:**
   ```powershell
   # Convert to Word and verify (portable method)
   pandoc -f markdown -t docx -o VA-Design.docx VA-Design.md --resource-path=diagrams
   # Open in Word - symbols should render correctly
   
   # Or with custom config if file exists:
   # pandoc -f markdown -t docx -o VA-Design.docx VA-Design.md -d pandoc-defaults/docx.yaml
   ```

4. **Script Validation:**
   ```powershell
   # Check for garbled patterns in documentation
   Get-ChildItem documentation -Recurse -Filter *.md | 
       Select-String -Pattern "â†|âœ|âŒ"
   # Should return no results
   ```

---

## Recovery Procedure

If encoding corruption occurs in VA documents:

1. **Manual Fix:**
   - Open file in VS Code
   - Click encoding in status bar (bottom-right)
   - Select "Reopen with Encoding" → UTF-8
   - If characters still garbled, use find/replace:
     - Replace `â†'` with `→`
     - Replace `âœ…` with `✅`
     - Replace `âŒ` with `❌`

2. **Script-Based Fix:**
   ```powershell
   # Create encoding fix script
   $content = Get-Content -Path "VA-Doc.md" -Raw -Encoding UTF8
   $content = $content -replace 'â†'', '→'
   $content = $content -replace 'âœ…', '✅'
   $content = $content -replace 'âŒ', '❌'
   
   $utf8NoBom = New-Object System.Text.UTF8Encoding $false
   [System.IO.File]::WriteAllText("VA-Doc.md", $content, $utf8NoBom)
   ```

3. **Regenerate Affected Documents:**
   - Regenerate Word documents after fixing markdown
   - Regenerate diagrams if labels affected
   - Verify all downstream artifacts

---

## VA Project-Specific Examples

### Architecture Documentation
```markdown
### Data Flow

VA Client → Cognigy Platform → TIPS Backend → Database

**Status:**
- ✅ Cognigy integration complete
- ✅ TIPS API endpoints defined
- ❌ Database schema pending approval
```

### Meeting Notes
```markdown
## Decisions

- ✅ Adopt Cognigy for conversational AI
- ✅ Use TIPS for backend integration
- ❌ Hold off on DCT implementation until Q3
```

### Technical Specifications
```markdown
| Component | Status | Priority |
|-----------|--------|----------|
| iCompass VA | ✅ Active | High |
| Cognigy API | ✅ Integrated | High |
| TIPS Integration | → In Progress | High |
| DCT Module | ❌ Blocked | Medium |
```

---

## Best Practices Summary

✅ **ALWAYS:**
- Use UTF-8 encoding without BOM for all VA documents
- Type Unicode characters directly in markdown
- Verify encoding in VS Code status bar
- Test in both markdown and Word formats
- Run validation before committing documents

❌ **NEVER:**
- Copy from sources with different encoding (e.g., legacy Word docs)
- Use ASCII substitutes when Unicode intended
- Ignore encoding warnings in editors
- Skip validation steps before delivery
- Mix file encodings in same project

---

## Integration with Other Skills

This skill works in conjunction with:
- **document-styles.md** - Formatting standards
- **mermaid-diagram-standards.md** - Diagram formatting
- **demo-creation-standards.md** - Demo preparation

**Priority Order:**
1. UTF-8 Encoding (this skill) - MUST be correct first
2. Document Styles - Applied after encoding is verified
3. Mermaid Standards - Diagrams rendered after encoding fixed

---

**This standard applies to all VA project documentation and must be verified before document finalization.**

````