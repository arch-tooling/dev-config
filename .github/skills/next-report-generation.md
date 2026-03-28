````markdown
# Next Report Generation - VA Project

**Purpose**: Automated project status summarization system for iCompass VA Integration Architecture
**Applies To**: VA workspace with achievement reports
**Priority**: HIGH (Auto-triggered after task completion)
**Version**: 1.0
**Last Updated**: February 24, 2026

---

## Overview

The Next Report system provides **automated project status tracking** for the VA integration project by analyzing DONE achievement reports and generating comprehensive status documents. This enables quick project health assessment, progress tracking, and priority identification for stakeholders.

### Two Report Types

1. **Comprehensive Report**: Full re-analysis of all DONE reports (manual trigger)
2. **Incremental Report**: Merge latest DONE into previous Next (automatic after task)

---

## Comprehensive Report Generation

### When to Generate

**Manual Trigger**: User explicitly requests with prompt:
- "Run comprehensive Next report analysis"  
- "Summarize all VA tasks"
- "Generate comprehensive VA project status"
- "Update Next report with full analysis"

**Use Cases for VA Project**:
- First report after establishing the system
- After major milestones (Cognigy integration complete, TIPS API finalized)
- Before stakeholder meetings or design reviews
- Monthly status reports
- After 5+ tasks completed

### Process Steps

1. **Discover DONE Reports**
   ```
   Find all DONE-*.md files in documentation/COPILOT-TASK-STATE/reports/
   ```

2. **Read All Reports**
   - Read each DONE report completely
   - Extract task metadata (date, time, effort)
   - Identify deliverables (architecture docs, API specs, meeting notes)
   - Note VA-specific accomplishments (Cognigy integration, TIPS endpoints)
   - Note open items and recommendations
   - Calculate statistics (time, cost if available)

3. **Aggregate VA Project Statistics**
   - Count total tasks completed
   - Sum time spent
   - Count deliverables by type (architecture docs, API specs, meeting recaps)
   - Track integration milestones (Cognigy, TIPS, DCT, IRR)
   - Document decisions and approvals

4. **Categorize Work**
   - Group by VA project area:
     - Cognigy integration
     - TIPS backend integration
     - Architecture documentation
     - API specifications
     - Meeting documentation
     - Demo preparation
   - Identify recurring themes
   - Track goal progression
   - Note dependencies and blockers

5. **Generate Report**
   - Create comprehensive 0_NEXT_LATEST.md
   - Include all sections with full VA context
   - Provide actionable recommendations
   - Highlight project health indicators

6. **Archive Previous Version**
   ```powershell
   # Create timestamped archive in VA project
   Copy-Item "documentation/COPILOT-TASK-STATE/0_next/0_NEXT_LATEST.md" `
             "documentation/COPILOT-TASK-STATE/0_next/archive/0_NEXT_$(Get-Date -Format 'yyyyMMdd-HHmm').md"
   ```

---

## Incremental Report Generation

### When to Generate

**Automatic Trigger**: Immediately after creating any DONE achievement report

**Recognition Pattern**: When you execute:
```powershell
# Storing VA achievement report
New-Item "documentation/COPILOT-TASK-STATE/reports/DONE-YYYYMMDD-HHmm-<task>.md" -Value $content
```

**Use Cases**:
- After every completed VA task
- Maintains current status without full re-analysis
- Efficient for continuous progress tracking

### Process Steps

1. **Read Latest DONE Report**
   - Identify most recently created DONE-*.md file
   - Extract task summary
   - Note VA-specific accomplishments (Cognigy updates, TIPS integration progress)
   - Note time spent and key deliverables
   - Identify new recommendations or open items

2. **Read Current Next Report**
   - Load existing 0_NEXT_LATEST.md
   - Parse current statistics
   - Note current VA goals and priorities

3. **Merge New Information**
   - **Quick Stats**: Increment task count, add time/cost
   - **Recent Completions**: Add new task to top of list (keep last 5)
   - **Upcoming Work**: Update priorities based on new VA recommendations
   - **Key Decisions**: Add if new decisions documented (e.g., Cognigy version, TIPS API choices)
   - **Blockers & Risks**: Update status of existing, add new ones
   - **Recommendations**: Refresh based on latest VA context
   - **Statistics Summary**: Update cumulative totals

4. **Generate Updated Report**
   - Preserve existing structure
   - Update "Generated" date and increment version
   - Note "Report Type: Incremental"
   - Reference source as "Latest DONE report + previous Next"

5. **Archive Previous Version**
   ```powershell
   # Always archive before updating LATEST
   Copy-Item "documentation/COPILOT-TASK-STATE/0_next/0_NEXT_LATEST.md" `
             "documentation/COPILOT-TASK-STATE/0_next/archive/0_NEXT_$(Get-Date -Format 'yyyyMMdd-HHmm').md"
   ```

---

## Report Template Structure for VA Project

### Required Sections

```markdown
# VA Project Status - Next Report
**Generated**: [Date Time]
**Report Type**: Comprehensive | Incremental
**Project**: iCompass VA Integration Architecture
**Source**: [Description]
**Version**: [x.y]

---

## Quick Stats

| Metric | Value |
|--------|-------|
| Total Tasks Completed | X |
| Time Invested | XX hours |
| Deliverables Created | X docs, X specs |
| Cognigy Integration | Status |
| TIPS Integration | Status |
| Active Blockers | X |
| Success Rate | XX% |

---

## Active Goals

### High Priority
1. **Complete Cognigy API Specification** - Due: [Date] - Status: [Status]
2. **Finalize TIPS Integration Design** - Due: [Date] - Status: [Status]

### Medium Priority
3. **Prepare Demo Materials** - Due: [Date] - Status: [Status]

### Low Priority
4. **Document DCT Module** - Due: [Date] - Status: [Status]

---

## Recent Completions (Last 5)

### 1. [Task Name] ✅
**Date**: YYYY-MM-DD (DONE-YYYYMMDD-HHmm)
**Area**: Cognigy Integration | TIPS Backend | Architecture | API Spec | Meeting
**Summary**: [Brief description]
**Impact**: [What changed]
**Time**: XX minutes

<Repeat for 5 most recent tasks>

---

## Upcoming Work (Prioritized)

### High Priority
**Task**: Complete Cognigy authentication documentation
**Reason**: Blocks TIPS integration testing
**Effort**: 2 hours
**Dependencies**: None
**Owner**: TBD

<Repeat for high priority items>

### Medium Priority
<Medium priority items>

### Low Priority
<Low priority items>

---

## Key Decisions Made

### 1. [Decision Title]
**Date**: YYYY-MM-DD
**Context**: [Why decision needed]
**Decision**: [What was decided]
**Rationale**: [Why this choice]
**Impact**: [Affected components: Cognigy, TIPS, DCT, etc.]

<Repeat for all major decisions>

---

## Blockers & Risks

### Active Blockers
1. **[Blocker Title]**
   - Impact: High/Medium/Low
   - Area: Cognigy | TIPS | DCT | IRR
   - Status: [Current status]
   - Mitigation: [Plan]

### Identified Risks
1. **[Risk Title]**
   - Probability: High/Medium/Low
   - Impact: High/Medium/Low
   - Mitigation: [Strategy]

---

## Recommendations

### Immediate Actions (This Week)
1. [Specific actionable item]
2. [Specific actionable item]

### Strategic Considerations (Next 2-4 Weeks)
1. [Strategic recommendation]
2. [Strategic recommendation]

---

## Statistics Summary

### Time Investment by Area
| Area | Tasks | Time | % of Total |
|------|-------|------|------------|
| Cognigy Integration | X | XX hours | XX% |
| TIPS Backend | X | XX hours | XX% |
| Architecture | X | XX hours | XX% |
| API Specifications | X | XX hours | XX% |
| Meeting Documentation | X | XX hours | XX% |
| Demo Preparation | X | XX hours | XX% |

### Deliverables by Type
| Type | Count | Examples |
|------|-------|----------|
| Architecture Docs | X | VA-Integration-Architecture.md |
| API Specifications | X | Cognigy-API-Reference.md |
| Meeting Recaps | X | Meeting-Recap-TIPS-2026-02-16.md |
| Technical Designs | X | TIPS-Integration-Design.md |
| Word Documents | X | Various .docx deliverables |

---

## Project Health

**Overall Status**: 🟢 On Track | 🟡 At Risk | 🔴 Blocked

**Strengths**:
- [What's going well]
- [Positive trends]

**Areas for Improvement**:
- [Challenges faced]
- [Process gaps]

**Momentum**: Increasing | Steady | Decreasing
[Explanation]

---

## Next Update

**Type**: Incremental (automatic after next task) | Comprehensive (manual)
**Trigger**: Task completion | User request
**Expected**: [Date/timeframe]

---

**Report Generated by**: GitHub Copilot (Claude Sonnet 4.5)
**Archive Location**: documentation/COPILOT-TASK-STATE/0_next/archive/
```

---

## VA Project-Specific Statistics

### Tracking VA Integration Progress

**Metrics to Extract:**
- **Cognigy Integration Progress**: API endpoints documented, authentication implemented, testing status
- **TIPS Backend Status**: Endpoints defined, integration patterns documented, error handling specified
- **Documentation Completeness**: Architecture docs, API specs, meeting recaps
- **Demo Readiness**: Demo materials prepared, Word documents generated
- **Stakeholder Engagement**: Meetings held, decisions made, approvals obtained

### VA-Specific Content Filtering

**INCLUDE (Substantive VA Work)**:
✅ Architecture design and specifications
✅ Cognigy API documentation
✅ TIPS integration designs
✅ Meeting recaps and decisions
✅ Demo preparation materials
✅ Word document generation
✅ Technical reviews and approvals

**EXCLUDE (Procedural/Trivial)**:
❌ Environment setup
❌ Minor formatting changes
❌ Typo corrections
❌ IDE configuration

---

## Automation Workflow

### After VA Task Completion

```
1. User completes VA integration task
2. Agent creates DONE-YYYYMMDD-HHmm-<task>.md in documentation/COPILOT-TASK-STATE/reports/
3. AUTOMATIC TRIGGER: Incremental Next report update
   a. Read latest DONE report
   b. Read current 0_NEXT_LATEST.md
   c. Create archive copy in documentation/COPILOT-TASK-STATE/0_next/archive/
   d. Merge new VA task info into report
   e. Update VA-specific statistics (Cognigy, TIPS progress)
   f. Update priorities and recommendations
   g. Save updated 0_NEXT_LATEST.md
4. Agent notifies user: "VA Next report updated (v1.2)"
```

---

## Best Practices for VA Project

### DO ✅

1. **Track integration milestones** - Cognigy, TIPS, DCT, IRR progress
2. **Document key decisions** - API choices, architecture patterns
3. **Monitor blockers** - External dependencies, approvals needed
4. **Update after meetings** - Capture decisions and action items
5. **Link to deliverables** - Reference specific files created
6. **Note stakeholder engagement** - Meeting attendance, approvals

### DON'T ❌

1. **Don't track trivial changes** - Environment setup, formatting
2. **Don't lose context** - Always archive before updating
3. **Don't delay updates** - Update immediately after task completion
4. **Don't forget VA context** - Always note which components affected

---

## Directory Structure

```
documentation/COPILOT-TASK-STATE/
├── 0_next/
│   ├── 0_NEXT_LATEST.md (Current status)
│   └── archive/
│       ├── 0_NEXT_20260224-1030.md
│       ├── 0_NEXT_20260224-1530.md
│       └── 0_NEXT_20260225-0930.md
├── reports/
│   ├── DONE-20260224-1015-VA-Architecture-Update.md
│   ├── DONE-20260224-1145-Cognigy-API-Spec.md
│   └── DONE-20260224-1530-TIPS-Integration-Design.md
└── prompts/
    ├── PROMPT_20260224_0915.md
    ├── PROMPT_20260224_1120.md
    └── PROMPT_20260224_1435.md
```

---

## Related Documentation

- [Achievement Report Standards](../copilot-instructions.md#achievement-report-storage)
- [Prompt Tracking Standards](prompt-tracking-standards.md)
- [Document Styles](document-styles.md)

---

**This standard ensures the VA project maintains accurate, up-to-date status tracking for all stakeholders.**

````