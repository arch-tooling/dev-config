````markdown
# Prompt Tracking Standards - VA Project

**Purpose:** Define automatic prompt saving and task instruction tracking for all Copilot work sessions.

**Priority:** HIGH
**Applies To:** All task executions in VA workspace
**Last Updated:** February 24, 2026

---

## Overview

Every task execution must begin with saving the task prompt to establish clear audit trail, enable session recovery, and maintain project context across interruptions.

**Key Principle:** "Prompt First, Execute Second"

---

## Automatic Prompt Saving

### When to Save Prompts

**REQUIRED - Save at task session start:**
- User provides multi-step work instructions
- User requests specific VA integration task execution  
- Starting work after resuming interrupted session
- Beginning any achievement-worthy task

**REQUIRED - Save during interactive updates:**
- User provides clarifications during task execution
- Significant scope or approach changes occur
- Task splits into multiple phases with user decisions

**OPTIONAL - Not required:**
- Simple informational queries ("what's in this file?")
- Quick status checks ("show me errors")
- Trivial single-action requests ("format this code")

### Saving Trigger Pattern

```
IF user_request requires:
  - Multiple steps/phases
  - OR achievement report creation
  - OR >15 minutes estimated duration
  - OR clarification/decision-making

THEN:
  1. Create documentation/COPILOT-TASK-STATE/prompts/ directory if not exists
  2. Save PROMPT_<timestamp>.md
  3. Proceed with task execution
```

---

## Naming Convention

### Prompt Files

**REQUIRED PATTERN:** `PROMPT_<YYYYMMDD>_<HHMM>.md`

**Components:**
- `PROMPT` = Fixed prefix (uppercase)
- `<YYYYMMDD>` = Date in YYYYMMDD format (e.g., 20260224)
- `<HHMM>` = Time in HHMM 24-hour format (e.g., 1120 for 11:20 AM)
- `.md` = Markdown format

**Examples:**
- `PROMPT_20260224_1120.md` - VA task started at 11:20 AM on Feb 24, 2026
- `PROMPT_20260224_1435.md` - Integration task started at 2:35 PM
- `PROMPT_20260224_0915.md` - Architecture review started at 9:15 AM

**Storage Location:** `documentation/COPILOT-TASK-STATE/prompts/` (VA project root)

**Unique Identifier:** Timestamp ensures uniqueness (assuming <1 task per minute)

---

## Prompt File Structure

### Required Sections

```markdown
# Task Prompt - <Date Time>

**Date**: YYYY-MM-DD HH:mm
**Task Session**: <Brief description>
**Project**: iCompass VA Integration Architecture
**Task IDs**: <DONE report IDs if known, or TBD>

---

## User Request

\`\`\`
<Exact user request text in code block>
\`\`\`

<Any follow-up user responses during clarification>

---

## Context

### Recent Completions
<List of recently completed DONE reports related to VA project>

### Current Project State
<Active blockers, tasks completed, time invested in VA, key metrics>
<Status of Cognigy integration, TIPS integration, DCT, IRR>

### Key Findings
<Recent discoveries, integration issues, API updates, critical decisions>

---

## Planned Approach

### Phase 1: <Phase Name> (<Duration>)
**Goal**: <What this phase achieves>
**Actions**:
1. <Specific action>
2. <Specific action>

**Deliverables**:
- <File or outcome>
- <File or outcome>

<Repeat for each phase>

---

## Success Criteria

### Phase 1: <Phase Name>
- [ ] Criterion 1
- [ ] Criterion 2

<Repeat for each phase>

---

## Dependencies

<Phase relationships, blocking conditions, parallel opportunities>
<External dependencies: Cognigy API, TIPS endpoints, meeting outcomes>

---

## Estimated Timeline

| Phase | Duration | Start | End |
|-------|----------|-------|-----|
| Phase 1 | 15 min | HH:MM | HH:MM |
| **Total** | **XX min** | **HH:MM** | **HH:MM** |

---

## Risk Assessment

### Low/Medium/High Risk
<Identify risky phases and mitigation strategies>
<External risks: API changes, TIPS availability, stakeholder approvals>

---

## Notes

<User preferences, implementation decisions, special instructions>
<VA-specific considerations: Cognigy versioning, TIPS compatibility>

---

**Prompt Saved**: YYYY-MM-DD HH:mm
**Saved By**: GitHub Copilot (Claude Sonnet 4.5)
**Next Action**: <First concrete action>
```

---

## VA Project-Specific Examples

### Example 1: Architecture Documentation

**File:** `PROMPT_20260224_1400.md`

```markdown
# Task Prompt - February 24, 2026 2:00 PM

**Date**: 2026-02-24 14:00
**Task Session**: Update VA Integration Architecture document
**Project**: iCompass VA Integration Architecture  
**Task IDs**: TBD

## User Request
\`\`\`
"Update the VA Integration Architecture document to include the new Cognigy API endpoints and TIPS backend integration patterns discussed in the 2026-02-16 meeting."
\`\`\`

## Context

### Recent Completions
- DONE-20260220-1530-Meeting-Recap-TIPS-Integration
- DONE-20260221-1015-Cognigy-API-Specification-Update

### Current Project State
- Cognigy API v2.0 integrated and documented
- TIPS integration design approved
- DCT module pending (Phase 2)
- IRR repository structure defined

### Key Findings
- New authentication flow for Cognigy requires Bearer tokens
- TIPS REST API endpoints finalized
- Meeting identified 3 new integration patterns

---

## Planned Approach

### Phase 1: Review Meeting Materials (10 min)
**Goal**: Extract key architectural decisions
**Actions**:
1. Read Meeting-Recap-TIPS-Integration-2026-02-16.docx
2. Review TIPS-Integration-Meeting-Package notes
3. Identify architecture changes

**Deliverables**:
- List of architecture updates

### Phase 2: Update Architecture Document (30 min)
**Goal**: Incorporate new integration patterns
**Actions**:
1. Update Cognigy API section with new endpoints
2. Add TIPS backend integration section
3. Update architecture diagrams
4. Generate PNG diagrams at 2x resolution

**Deliverables**:
- Updated VA-Integration-Architecture.md
- New/updated diagrams in diagrams/ directory

### Phase 3: Generate Word Document (10 min)
**Goal**: Create deliverable for stakeholders
**Actions**:
1. Run Pandoc conversion
2. Verify diagram embedding
3. Check UTF-8 encoding

**Deliverables**:
- VA-Integration-Architecture.docx

---

## Success Criteria

### Phase 1: Review
- [ ] Meeting materials reviewed
- [ ] Architecture changes identified
- [ ] Stakeholder decisions documented

### Phase 2: Documentation
- [ ] Architecture document updated
- [ ] New diagrams generated
- [ ] Legends added to all diagrams
- [ ] UTF-8 encoding verified

### Phase 3: Word Generation
- [ ] Pandoc conversion successful
- [ ] Diagrams display correctly
- [ ] Document ready for review

---

## Dependencies

- Phase 2 depends on Phase 1 completion
- Phase 3 depends on Phase 2 completion
- No external blockers

---

## Estimated Timeline

| Phase | Duration | Start | End |
|-------|----------|-------|-----|
| Phase 1 | 10 min | 14:00 | 14:10 |
| Phase 2 | 30 min | 14:10 | 14:40 |
| Phase 3 | 10 min | 14:40 | 14:50 |
| **Total** | **50 min** | **14:00** | **14:50** |

---

## Risk Assessment

### Medium Risk
- Meeting materials may be incomplete → Mitigate by requesting clarification
- Diagram complexity may require additional time → Allocate 10 min buffer

---

## Notes

- Follow VA project Mermaid diagram standards (clean syntax, 2x resolution)
- Ensure UTF-8 encoding for all files
- Reference meeting package for technical details
- Include legends for all diagrams

---

**Prompt Saved**: 2026-02-24 14:00
**Saved By**: GitHub Copilot (Claude Sonnet 4.5)
**Next Action**: Read Meeting-Recap-TIPS-Integration-2026-02-16.docx
```

### Example 2: API Specification Update

**File:** `PROMPT_20260224_0930.md`

```markdown
# Task Prompt - February 24, 2026 9:30 AM

**Date**: 2026-02-24 09:30
**Task Session**: Cognigy API Specification Enhancement
**Project**: iCompass VA Integration Architecture
**Task IDs**: TBD

## User Request
\`\`\`
"Add authentication section to Cognigy API specification including Bearer token format, refresh token flow, and error handling."
\`\`\`

## Context

### Recent Completions
- DONE-20260223-1630-Initial-Cognigy-API-Spec

### Current Project State
- Cognigy API v2.0 endpoints documented
- Authentication flow not yet documented
- TIPS integration waiting for auth specification

### Key Findings
- Cognigy uses OAuth 2.0 Bearer tokens
- Token refresh required every 1 hour
- Error codes specific to auth failures

---

## Planned Approach

### Phase 1: Research Cognigy Auth (20 min)
**Goal**: Gather auth documentation
**Actions**:
1. Review Cognigy API documentation
2. Test auth endpoints
3. Document token format

**Deliverables**:
- Auth research notes

### Phase 2: Write Auth Section (30 min)
**Goal**: Complete auth documentation
**Actions**:
1. Add authentication section to API spec
2. Document token format
3. Add refresh token flow diagram
4. Document error codes

**Deliverables**:
- Updated Cognigy-API-Specification.md
- Auth flow diagram

---

## Success Criteria

- [ ] Authentication section complete
- [ ] Bearer token format documented
- [ ] Refresh flow diagram included
- [ ] Error codes documented
- [ ] Examples provided

---

**Prompt Saved**: 2026-02-24 09:30
**Next Action**: Review Cognigy auth documentation
```

---

## Integration with Achievement Reports

### Linking Prompts to DONE Reports

**In DONE Report:**
```markdown
## Task Origin

**Original Prompt**: `documentation/COPILOT-TASK-STATE/prompts/PROMPT_20260224_1400.md`

**User Request Summary:**
Update VA Integration Architecture document with new Cognigy API endpoints

**Scope Changes:**
Added additional section on TIPS error handling (not in original scope)
```

---

## Best Practices for VA Project

### DO ✅

1. **Save prompt BEFORE starting VA work** (establishes intent)
2. **Include VA project context** (Cognigy status, TIPS integration, etc.)
3. **Reference meeting materials** (TIPS meetings, design reviews)
4. **Note external dependencies** (API availability, stakeholder approvals)
5. **Update prompt if scope changes** (maintains accuracy)
6. **Reference prompts in DONE reports** (links artifacts)

### DON'T ❌

1. **Don't skip prompt for VA integration tasks** (required for traceability)
2. **Don't forget VA-specific context** (current integration status)
3. **Don't save prompts for trivial queries** (clutter)
4. **Don't duplicate DONE report content** (different purposes)

---

## Directory Structure

```
documentation/COPILOT-TASK-STATE/
├── prompts/
│   ├── PROMPT_20260224_0915.md  # Morning VA task
│   ├── PROMPT_20260224_1120.md  # Mid-morning task
│   ├── PROMPT_20260224_1435.md  # Afternoon task
│   └── PROMPT_20260225_0930.md  # Next day
├── reports/
│   ├── DONE-20260224-0950-VA-Architecture-Update.md
│   ├── DONE-20260224-1145-Cognigy-API-Spec.md
│   └── DONE-20260224-1530-TIPS-Integration-Design.md
└── 0_next/
    └── 0_NEXT_LATEST.md
```

---

**This standard ensures all VA project work is properly documented and traceable from original request to final delivery.**

````