# Achievement Reports - VA Project

This directory contains achievement reports (DONE reports) for all completed tasks in the iCompass VA Integration Architecture project.

---

## Purpose

Achievement reports document:
- What was accomplished
- Technical details and implementation notes
- Test results and verification
- Files created/modified
- Known issues or follow-up items
- Success metrics

---

## Naming Convention

**Pattern**: `DONE-YYYYMMDD-HHmm-<short-task-name>.md`

**Components**:
- `DONE` = Fixed prefix (uppercase)
- `YYYYMMDD` = Completion date (e.g., 20260224)
- `HHmm` = Completion time in 24-hour format (e.g., 1430 for 2:30 PM)
- `<short-task-name>` = Kebab-case descriptor (e.g., VA-Architecture-Doc)

**Examples**:
- `DONE-20260224-1430-VA-Architecture-Doc.md`
- `DONE-20260224-0915-Cognigy-Integration-Spec.md`
- `DONE-20260224-1620-TIPS-API-Review.md`
- `DONE-20260224-1045-Meeting-Recap-TIPS.md`

---

## When to Create

**REQUIRED after completing:**
- Architecture documentation
- API specifications
- Integration designs
- Meeting documentation packages
- Demo preparation
- Technical reviews
- Word document generation

**OPTIONAL:**
- Simple queries
- Trivial formatting changes
- Minor corrections

---

## Report Contents

See template in [.github/copilot-instructions.md](../../../.github/copilot-instructions.md#achievement-report-storage)

**Key sections**:
1. Executive summary
2. Technical details
3. Files created/modified
4. Verification steps
5. Known issues
6. Recommendations

---

## Integration with Other Systems

### Prompt Tracking
Each DONE report should reference the original prompt file:
```markdown
**Original Prompt**: `prompts/PROMPT_20260224_1400.md`
```

### Next Report
After creating a DONE report, the Next report is automatically updated with:
- Incremented task count
- Updated statistics
- New task added to Recent Completions
- Refreshed recommendations

**See**: [../0_next/README.md](../0_next/README.md)

---

## VA Project-Specific Guidelines

### Task Categories
- **Architecture**: VA integration architecture, system design
- **API**: Cognigy API, TIPS integration endpoints
- **Meeting**: TIPS integration meetings, stakeholder reviews
- **Design**: Component specifications, interface definitions
- **Demo**: Demo preparation, presentation materials

### Key Components to Mention
- **iCompass VA**: Virtual Assistant platform
- **Cognigy**: Conversational AI platform
- **TIPS**: Backend integration system
- **DCT**: Document/Content transformation
- **IRR**: Integration requirements repository

---

## Related Documentation

- [Global Copilot Instructions](../../../.github/copilot-instructions.md) - Standards and requirements
- [Prompt Tracking Standards](../../../.github/skills/prompt-tracking-standards.md) - Linking prompts to reports
- [Next Report Generation](../../../.github/skills/next-report-generation.md) - Project status tracking

---

**Last Updated**: February 24, 2026
**Project**: iCompass VA Integration Architecture
