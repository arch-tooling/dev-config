# Master Report Workflow

**Purpose**: Document how the Master Next Report (0_NEXT_MASTER.md) is automatically updated

**Location**: `C:\Users\alk\src\alex\.copilot-task-state\0_NEXT_MASTER.md`

**Update Trigger**: Automatic after EVERY task completion (via DONE report creation)

---

## Auto-Update Workflow

### Trigger Condition

When Copilot creates a DONE report in ANY project:
```
C:\Users\alk\src\alex\.copilot-task-state\<project>\reports\DONE-*.md
```

### Update Sequence

1. **Update Project-Specific Next Report**
   - Archive current `<project>\0_next\0_NEXT_LATEST.md`
   - Read latest DONE report
   - Merge into project Next report
   - Update project statistics
   - Save updated project Next report

2. **Update Master Portfolio Report** (Automatic)
   - Read current `0_NEXT_MASTER.md`
   - Read all 6 project Next reports:
     - `gga-standards\0_next\0_NEXT_LATEST.md`
     - `arch-standards\0_next\0_NEXT_LATEST.md`
     - `VA\0_next\0_NEXT_LATEST.md`
     - `gga-standards-rnd\0_next\0_NEXT_LATEST.md`
     - `arch-standards-rnd\0_next\0_NEXT_LATEST.md`
     - `arch-standards-copilot-github\0_next\0_NEXT_LATEST.md`
   - Aggregate statistics:
     - Total tasks across all projects
     - Total time across all projects
     - Last activity per project
   - Update "Recent Activity" section (latest 10 tasks from all projects)
   - Update "Active Focus Areas" (from each project Next)
   - Update cross-project dependencies (if any)
   - Update cross-project risks
   - Refresh strategic recommendations
   - Save updated Master report

3. **Archive**
   - No archive for Master report (always current)
   - Archive policy: Keep last 30 days of project Next reports in archive/

---

## Aggregated Sections

### Portfolio Quick Stats

Aggregates from ALL 6 project Next reports:
- **Tasks**: Sum of tasks completed per project
- **Time**: Sum of time invested per project
- **Last Activity**: Most recent task date per project

### Recent Activity (Last 10 Tasks)

Reads all DONE reports from all projects, sorts by date descending, shows top 10:
- Format: `[YYYY-MM-DD] **[Project]** - [Task Name] - [Key outcome]`

### Active Focus Areas

For each project, extract from project-specific Next report:
- Current priority level
- Current focus description
- Active blockers

### Cross-Project Dependencies

Scans all project Next reports for dependencies mentioning other projects:
- Example: gga-standards depends on arch-standards approval

### Cross-Project Risks

Aggregates risks that affect multiple projects:
- De-duplicates similar risks
- Highlights risks with "High" impact affecting >1 project

---

## Manual Comprehensive Update

**Trigger**: User requests "Update master portfolio report comprehensively"

**Process**:
1. Re-read ALL DONE reports from ALL projects
2. Full aggregation from scratch
3. Recalculate all statistics
4. Regenerate all sections
5. Save with note: "Report Type: Comprehensive"

**Use Cases**:
- After major milestones
- Before executive presentations
- Monthly status reviews
- After bulk task completions

---

## Performance Considerations

**Auto-Update Overhead**:
- Reads 6 Next reports (small files, <50KB each)
- Minimal processing (aggregation only)
- Total time: <1 second

**Accepted**: Auto-update after every task is acceptable overhead for always-current portfolio view

---

## Example Update Flow

```
1. User completes task in gga-standards
2. Copilot creates DONE-20260327-1430-Analysis.md
3. Copilot updates gga-standards/0_next/0_NEXT_LATEST.md
4. Copilot reads all 6 project Next reports
5. Copilot aggregates into 0_NEXT_MASTER.md
6. Master report now shows:
   - gga-standards: 1 task, updated today
   - Recent Activity: New task at top of list
   - Portfolio Total: Incremented by 1
```

---

## Future Enhancements

**Potential**:
1. Script to visualize portfolio trends over time
2. Email digest of weekly portfolio activity
3. Slack/Teams integration for milestone notifications
4. Dashboard web app for real-time portfolio view

**Defer**: Not in AK: 2 scope, consider after validation period

---

**Last Updated**: 2026-03-27
