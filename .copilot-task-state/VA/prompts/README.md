# Task Prompts - VA Project

This directory contains task prompts saved BEFORE beginning work on significant VA integration tasks. Prompts establish audit trail, enable session recovery, and document original intent.

---

## Purpose

Task prompts document:
- User's original request
- Current project context
- Planned approach (phases, actions, deliverables)
- Success criteria
- Dependencies and risks
- Estimated timeline

---

## Naming Convention

**Pattern**: `PROMPT_YYYYMMDD_HHmm.md`

**Components**:
- `PROMPT` = Fixed prefix (uppercase)
- `YYYYMMDD` = Start date (e.g., 20260224)
- `HHmm` = Start time in 24-hour format (e.g., 1120 for 11:20 AM)

**Examples**:
- `PROMPT_20260224_1120.md` - Task started at 11:20 AM
- `PROMPT_20260224_1435.md` - Task started at 2:35 PM
- `PROMPT_20260224_0915.md` - Task started at 9:15 AM

---

## When to Create

**REQUIRED before starting:**
- Multi-step task execution (2+ phases)
- Tasks requiring achievement reports
- Tasks estimated >15 minutes duration
- Resuming interrupted work sessions
- Significant scope or approach changes during execution

**OPTIONAL:**
- Simple queries or trivial single actions

---

## Prompt Template

See complete template in [.github/skills/prompt-tracking-standards.md](../../../.github/skills/prompt-tracking-standards.md)

**Key sections**:
1. User Request (exact text)
2. Context (recent completions, project state, key findings)
3. Planned Approach (phases with goals, actions, deliverables)
4. Success Criteria (checkboxes for each phase)
5. Dependencies (phase relationships)
6. Estimated Timeline
7. Risk Assessment

---

## VA Project Context

### Recent Completions
List recently completed DONE reports related to:
- Cognigy integration
- TIPS backend
- Architecture documentation
- API specifications
- Meeting outcomes

### Current Project State
Document status of:
- **Cognigy Integration**: API version, endpoints documented, auth implemented
- **TIPS Integration**: Endpoints defined, integration patterns specified
- **DCT Module**: Status, pending items
- **IRR**: Repository structure, requirements captured
- **Active Blockers**: External dependencies, approvals needed

### Key Findings
Recent discoveries about:
- API updates or changes
- Integration challenges
- Stakeholder decisions
- Technical constraints

---

## Integration with Achievement Reports

Each DONE report should reference its originating prompt:

**In DONE report:**
```markdown
## Task Origin

**Original Prompt**: `prompts/PROMPT_20260224_1400.md`

**User Request Summary**:
Update VA Integration Architecture with new Cognigy endpoints

**Scope Changes**:
Added TIPS error handling section (not in original scope)
```

---

## Session Recovery

If work is interrupted:
1. Next session reads the prompt file
2. Identifies completed phases
3. Continues with remaining phases
4. Updates prompt with progress

**Example recovery:**
```markdown
## Update - 11:30 AM

**Resuming After Interruption**
- [x] Phase 1 completed (DONE-20260224-1015)
- [ ] Phase 2 (in progress)
- [ ] Phase 3 (not started)
```

---

## Related Documentation

- [Global Copilot Instructions](../../../.github/copilot-instructions.md) - Prompt tracking requirements
- [Prompt Tracking Standards](../../../.github/skills/prompt-tracking-standards.md) - Complete specification
- [Achievement Report README](../reports/README.md) - Linking prompts to reports

---

**Last Updated**: February 24, 2026
**Project**: iCompass VA Integration Architecture
