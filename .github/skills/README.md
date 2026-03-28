````markdown
# GitHub Copilot Skills Directory - VA Project

This directory contains skill files that guide AI assistants in generating consistent, high-quality documentation for the iCompass VA Integration Architecture project.

**Global Instructions:** See [../copilot-instructions.md](../copilot-instructions.md) for default behaviors applied to ALL Copilot sessions.

---

## Available Skills

### 1. UTF-8 Encoding Standards
**File:** `utf8-encoding-standards.md`
**Priority:** CRITICAL
**Purpose:** Prevent garbled UTF-8 characters in generated documents

**Key Rules:**
- Always use UTF-8 encoding without BOM
- Use proper Unicode characters: → ✅ ❌ ✓ ✗
- Never use ASCII substitutes when Unicode is intended
- Validate encoding before finalizing documents

**When to Apply:** ALL document generation tasks

---

### 2. Document Styles
**File:** `document-styles.md`
**Priority:** HIGH
**Purpose:** Maintain consistent formatting across all VA documentation

**Key Rules:**
- Include table of contents for documents > 2 pages
- Use horizontal lines (---) to separate major sections
- Maintain vertical compactness (no excessive whitespace)
- Follow hierarchical heading structure (# → ## → ###)

**When to Apply:** All markdown and Word document generation

---

### 3. Diagram Generation Standards
**File:** `diagram-generation-standards.md`
**Priority:** HIGH
**Purpose:** Generate high-resolution diagrams that remain readable when zoomed

**Key Rules:**
- Generate all diagrams at 2x scale minimum (use `-s 2` with mmdc)
- Use 3x scale for complex diagrams (16+ nodes)
- Always use transparent background (`-b transparent`)
- Embed PNG images in Word/PDF, keep Mermaid code in markdown
- Verify text readability at 200% zoom

**When to Apply:** ALL diagram generation tasks

---

### 4. Mermaid Diagram Standards
**File:** `mermaid-diagram-standards.md`
**Priority:** HIGH
**Purpose:** Ensure clean, professional Mermaid diagrams in all VA documentation

**Key Rules:**
- Remove all inline style directives (fill, stroke, color)
- Generate PNG images for Word documents
- Keep Mermaid code blocks in markdown
- Use proper naming convention for diagram files
- Include legends for all diagrams

**When to Apply:** All technical documentation containing diagrams

---

### 5. Prompt Tracking Standards
**File:** `prompt-tracking-standards.md`
**Priority:** HIGH
**Purpose:** Automatic prompt saving for task audit trail and session recovery

**Key Rules:**
- Save prompt before starting multi-step tasks
- Use PROMPT_YYYYMMDD_HHmm.md naming pattern
- Include user request, context, planned approach, success criteria
- Store in documentation/COPILOT-TASK-STATE/prompts/
- Reference prompt in DONE report

**When to Apply:**
- Multi-step task execution (2+ phases)
- Tasks requiring achievement reports
- Tasks estimated >15 minutes duration
- Resuming interrupted work sessions

---

### 6. Next Report Generation
**File:** `next-report-generation.md`
**Priority:** HIGH
**Purpose:** Automated project status tracking and aggregation

**Key Rules:**
- Automatic incremental update after each DONE report
- Comprehensive report on manual trigger
- Store in documentation/COPILOT-TASK-STATE/0_next/
- Archive previous versions with timestamp
- Include statistics, goals, recommendations

**When to Apply:**
- Automatically after completing any task
- Manually for comprehensive project status

---

## How to Use These Skills

### For AI Assistants (GitHub Copilot)
- These skill files are automatically loaded when working in the VA workspace
- Follow the standards defined in each skill file
- Reference skills when clarification is needed
- Report any conflicts or ambiguities

### For Human Contributors
- Read relevant skill files before creating documentation
- Use skills as templates for new types of documents
- Propose updates via pull request if standards need revision
- Ensure tools and scripts align with skill requirements

---

## Skill Development

### Adding New Skills
1. Create skill file in `.github/skills/` directory
2. Use existing skills as template
3. Include Purpose, Priority, Key Rules, When to Apply sections
4. Update this README with new skill entry
5. Reference in [../copilot-instructions.md](../copilot-instructions.md)

### Updating Existing Skills
1. Edit skill file with proposed changes
2. Update "Last Updated" date
3. Test changes with sample documents
4. Document breaking changes
5. Update references in copilot-instructions.md if needed

---

## VA Project Context

These skills are specifically adapted for the iCompass VA Integration Architecture project, which includes:

**Key Components:**
- iCompass VA (Virtual Assistant platform)
- Cognigy (Conversational AI platform)
- TIPS (Backend integration system)
- DCT (Document/Content transformation)
- IRR (Integration requirements repository)

**Document Types:**
- Architecture designs and specifications
- API documentation (Cognigy, TIPS)
- Integration guides and procedures
- Meeting documentation and status reports
- Demo materials and presentations

**Audience:**
- Technical teams (developers, architects, QA)
- Business stakeholders (product, executives)
- Integration partners (TIPS, Cognigy)

---

## References

- [GitHub Copilot Instructions](../copilot-instructions.md) - Global instructions
- [Demo Creation Standards](../demo-creation-standards.md) - Demo preparation
- [Bug Prevention Standards](../bugs-prevention-standard.md) - Anti-pattern avoidance
- [VA Project Documentation](../../documentation/README.md) - VA-specific documentation

---

**Last Updated**: February 24, 2026
**Maintained by**: VA Project Team

````