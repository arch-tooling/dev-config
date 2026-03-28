# Fact Verification Standards

**Purpose:** Establish rigorous methodology for verifying claims, assertions, and technical statements in VA project documentation.

**Applies to:** All technical documentation, architecture documents, API specifications, and design artifacts.

**Last Updated:** March 2, 2026

---

## Verification Tagging System

Use these tags to classify every factual claim in documentation:

### Core Tags

- ✅ **VERIFIED**: Direct source found in IN/ folders, directives, or meeting notes with clear attribution
  - Example: "ISL established ~2018" (source: user confirmation chat 2026-02-27)
  - Requires: File path, line number, or chat date reference

- 📝 **USER CONFIRMED**: Verbal confirmation from user in chat or meeting
  - Example: "Cognigy already in production" (confirmed: chat 2026-02-27)
  - Requires: Date of confirmation in parentheses

- ⚠️ **INFERRED**: Logical inference from verified sources (reasonable extrapolation)
  - Example: "ElasticSearch sync unchanged" (inferred from: DynamoDB Streams pattern established in TIPS architecture)
  - Requires: Brief reasoning or basis for inference
  - Use when: Standard patterns, architectural implications, or logical consequences

- 🔮 **SUPPOSITION**: Explicit assumption made for design/planning purposes, acknowledged as unconfirmed
  - Example: "Assuming GIP provides webhook capability [SUPPOSITION: pending GIP API confirmation]"
  - Example: "For planning, we suppose 7-9 week timeline [SUPPOSITION: methodology TBD]"
  - Requires: Explicit marker in text like [SUPPOSITION: ...] with context
  - Use when: Making planning assumptions that need validation before implementation

- ❌ **SPECULATIVE**: No source found, presented as fact without basis
  - Example: "Response time <300ms" (no requirement doc found)
  - Example: "542-line converter" (no code reference)
  - Requires: Flag for removal or conversion to SUPPOSITION with proper marking
  - Use when: Numbers, dates, or technical details lack supporting evidence

- ❓ **UNKNOWN**: Requires verification, not yet audited
  - Example: "OAuth2 credentials per environment" (status: not yet verified)
  - Requires: Action item to locate source
  - Use when: Initial audit pass, needs follow-up research

---

## Evidence Source Priority

When verifying claims, check sources in this order:

### 1. Primary Sources (Highest Priority)
- **VA-DIRECTIVES**: `va-docs/IN/VA-DIRECTIVES/`
  - IVR/ - Cognigy, Genesys, call flow specifications
  - DCT/ - Duck Creek integration specifications
  - IRR/ - Integration requirement specifications
- **Meeting Notes**: `VA/documentation/IN/VA-Meetings/`
- **Email Communications**: `VA/documentation/IN/*.txt`
- **Contract Documents**: GIP contracts, API specifications

### 2. Secondary Sources
- **User Confirmations**: Chat conversations with dated references
- **Code Repositories**: Actual implementation (if available)
- **Architecture Diagrams**: Existing validated designs
- **Risk Registers**: Documented uncertainties (D5, OPEN-QUESTIONS.md)

### 3. Tertiary Sources (Use with Caution)
- **Design Decisions**: Logical architecture choices (mark as INFERRED)
- **Standard Practices**: Industry patterns (OAuth2, exponential retry) - mark as INFERRED
- **Estimations**: LOC counts, timeline projections - mark as SUPPOSITION

---

## Detection Criteria

### Triggers for ❌ SPECULATIVE Classification

Automatic red flags requiring source verification:

1. **Numeric Claims Without Sources**
   - Performance metrics: "<300ms", "~200ms latency", "<50ms DDB read"
   - LOC counts: "542 lines", "~400 LOC", "6 files changed"
   - Component counts: "10+ unchanged components"
   - Timeline durations: "7-9 weeks", "3-month deployment"

2. **Dates Without Meeting Notes**
   - Meeting dates: "ADR decision on 2026-02-24"
   - Delivery dates: "Production launch Q3 2026"
   - Milestone dates without project plan reference

3. **API Details Without Contracts**
   - Endpoint paths: "POST /gip/v1/events"
   - Field names: "sourceSystem, gipQuoteId, partnerAffiliate"
   - Response schemas without GIP documentation

4. **Component Names Without Code References**
   - Class names: "CancellationStatusService", "GipEventAdapter"
   - File names: "GipProperties.java", "PolicyEntity.java"
   - Specific file counts or line changes

### Acceptable for ⚠️ INFERRED Classification

These may be inferred if basis is clear:

1. **Architectural Patterns**
   - "Event-driven architecture" (if eventing confirmed)
   - "Null defaults to TIPS" (backward compatibility pattern)
   - "Circuit breaker pattern" (standard resilience)

2. **Standard Practices**
   - "OAuth2 Bearer token" (industry standard)
   - "Exponential backoff retry" (standard pattern)
   - "Idempotency via eventId" (standard pattern)

3. **Logical Implications**
   - "Cognigy unchanged" → "Customer experience identical"
   - "TIPS path unchanged" → "Zero regression risk"
   - "ISL transparent to Cognigy" → "No Cognigy config changes"

### When to Use 🔮 SUPPOSITION

Use when making explicit planning assumptions:

1. **Unconfirmed Requirements**
   - "Assuming GIP supports webhooks [SUPPOSITION: pending API v2 spec]"
   - "Timeline 7-9 weeks [SUPPOSITION: based on similar project patterns]"

2. **Placeholder Designs**
   - "Proposed data model includes gipQuoteId [SUPPOSITION: GIP schema TBD]"
   - "Estimated ~400 LOC [SUPPOSITION: similar Spring Boot clients]"

3. **Risk Mitigation Planning**
   - "If GIP event format differs [SUPPOSITION: converter adds 100 LOC]"
   - "Fallback to polling [SUPPOSITION: webhook unavailable]"

**Critical Rule:** SUPPOSITION must include:
- Explicit marker: `[SUPPOSITION: reason/context]`
- Clear acknowledgment it's unconfirmed
- Plan to validate before implementation

---

## Documentation Standards

### How to Mark Claims in Documents

#### ✅ Do This:

**Example 1: VERIFIED with source**
```markdown
The ISL layer was established in 2018 (Source: User confirmation, 2026-02-27), 
predating the Cognigy integration by several years.
```

**Example 2: SUPPOSITION with explicit marker**
```markdown
### Timeline Estimate

The integration is estimated at 7-9 weeks [SUPPOSITION: Based on similar 
microservice additions; methodology pending project plan approval].

**Phases:**
- Phase 1: GIP client setup (2 weeks) [SUPPOSITION]
- Phase 2: Event adapter (3 weeks) [SUPPOSITION]
- Phase 3: Integration testing (2 weeks) [SUPPOSITION]
- Phase 4: Deployment (1 week) [SUPPOSITION]
```

**Example 3: INFERRED with reasoning**
```markdown
The TIPS ingestion path remains unchanged (Source: User confirmation that 
project only adds GIP support). By extension, the DynamoDB Streams → Lambda 
→ ElasticSearch synchronization pipeline also remains unchanged [INFERRED: 
TIPS path includes this sync mechanism].
```

#### ❌ Don't Do This:

**Bad Example 1: SPECULATIVE presented as fact**
```markdown
The gip-policy-adapter-service requires approximately 542 lines of code for 
the event converter logic.
```
**Why:** Specific LOC count without code reference is speculative.

**Bad Example 2: Hidden assumption**
```markdown
GIP will provide a webhook endpoint at POST /gip/v1/events for policy updates.
```
**Why:** Presents unconfirmed API design as established fact.

**Bad Example 3: Unsourced performance claim**
```markdown
The authentication API responds in under 300ms with 99.9% uptime.
```
**Why:** Metric lacks requirement doc or SLA source.

---

## Audit Workflow

### Phase 1: Initial Classification

For each document section:

1. **Extract Claims**: Identify all factual assertions
   - Technical specifications (APIs, schemas, LOC)
   - Architecture decisions (patterns, components)
   - Timeline statements (dates, durations)
   - Performance assertions (latency, throughput)

2. **Tag Each Claim**: Apply verification tag
   - Search evidence sources (priority order above)
   - Document source if found → ✅ VERIFIED or 📝 USER CONFIRMED
   - If logical inference → ⚠️ INFERRED with reasoning
   - If planning assumption → 🔮 SUPPOSITION with [marker]
   - If no source → ❌ SPECULATIVE (flag for review)
   - If not yet checked → ❓ UNKNOWN (research needed)

3. **Create Tracking Table**: Use FACT-SOURCE-MAPPING.md template

### Phase 2: Document Improvement

For documents with ❌ SPECULATIVE claims:

1. **Remove or Reframe**
   - Option A: Delete claim if non-essential
   - Option B: Convert to 🔮 SUPPOSITION with [marker]
   - Option C: Move to OPEN-QUESTIONS.md as research item

2. **Add Source Citations**
   - Inline references: "(Source: filename, lines X-Y)"
   - Footnotes for multiple sources
   - Link to meeting notes or emails

3. **Elevate Quality**
   - Replace vague terms: "cache" → "ISL datastore"
   - Add confidence levels: "High confidence (verified)" vs "Planning assumption (supposition)"
   - Distinguish current vs proposed architecture

### Phase 3: Continuous Verification

After improvements:

1. **Peer Review**: User validates sources and reasoning
2. **Update Mappings**: Keep FACT-SOURCE-MAPPING.md current
3. **Track Open Items**: Unknown/Supposition items → OPEN-QUESTIONS.md
4. **Version Control**: Note audit date and verification status

---

## Quality Metrics

### Document Grade Criteria

Based on claim distribution:

| Grade | ✅ VERIFIED + 📝 CONFIRMED | ❌ SPECULATIVE | 🔮 SUPPOSITION (properly marked) |
|-------|---------------------------|----------------|-----------------------------------|
| **A+** | >90% | 0% | <10% with clear markers |
| **A** | >80% | 0-5% | <15% with markers |
| **B** | >70% | 6-15% | <20% |
| **C** | >50% | 16-25% | <30% |
| **D** | >30% | 26-40% | <40% |
| **F** | <30% | >40% | >50% or unmarked |

**Note:** ⚠️ INFERRED claims count as 0.5x toward VERIFIED percentage if reasoning is sound.

**Note:** 🔮 SUPPOSITION with proper [markers] is acceptable for planning docs but unacceptable for final deliverables.

### Target Quality by Document Type

| Document Type | Minimum Grade | Max SUPPOSITION | Max SPECULATIVE |
|---------------|---------------|-----------------|-----------------|
| Risk Register | A+ | 0% | 0% |
| Executive ADR | A | 5% | 0% |
| Architecture Summary | A- | 10% | 5% |
| Technical Companion | B+ | 15% | 10% |
| Leadership Brief | B+ | 15% | 10% |
| Execution Plan | B | 20% | 5% |
| Draft Proposals | C+ | 30% | 15% |

---

## Common Pitfalls

### Anti-Patterns to Avoid

1. **Fabricated Precision**
   - ❌ "542-line converter"
   - ✅ "Estimated ~500-600 LOC converter [SUPPOSITION: similar components]"

2. **Phantom Sources**
   - ❌ "According to the GIP specification..."
   - ✅ "Proposed GIP endpoint [SUPPOSITION: awaiting GIP API v2 spec]"

3. **Unqualified Estimates**
   - ❌ "Timeline: 7-9 weeks"
   - ✅ "Estimated timeline: 7-9 weeks [SUPPOSITION: based on Phase 1-4 breakdown, pending PM validation]"

4. **Mixing Layers**
   - ❌ Presenting IVR directives (Cognigy layer) as ISL internal decisions
   - ✅ "IVR directives orthogonal to ISL internals [INFERRED: layers independent]"

5. **Hidden Assumptions**
   - ❌ "GIP provides real-time webhooks"
   - ✅ "Assuming GIP provides event webhooks [SUPPOSITION: alternative is polling]"

---

## Integration with Other Standards

### Cross-References

This standard works with:

- **[Prompt Tracking](.github/skills/prompt-tracking-standards.md)**: Capture original intent before verification
- **[Next Report Generation](.github/skills/next-report-generation.md)**: Include verification metrics in status
- **[Document Styles](.github/skills/document-styles.md)**: Format citations consistently
- **[Bug Prevention](.github/standards/bugs-prevention-standard.md)**: Avoid filepath anti-patterns

### Mandatory Files

When auditing, maintain:

1. **FACT-SOURCE-MAPPING.md**: Tracking table (all claims → sources)
2. **AUDIT-REPORT.md**: Findings summary with statistics
3. **OPEN-QUESTIONS.md**: Unknown/Supposition items requiring research

---

## Example: Complete Audit Entry

```markdown
### Claim: Timeline Estimate

**Text:** "Integration timeline: 7-9 weeks (Phase 1: 2 weeks, Phase 2: 3 weeks, Phase 3: 2 weeks, Phase 4: 1 week)"

**Status:** ❌ SPECULATIVE → 🔮 SUPPOSITION (after rewrite)

**Issue:** No project plan, meeting notes, or estimation doc found in IN/ folders or directives.

**Source Search:**
- ❌ `VA/documentation/IN/` - No project plans
- ❌ `VA/documentation/IN/VA-Meetings/` - Timeline not discussed
- ❌ User confirmations - "Timeline not known" (chat 2026-02-27)

**Resolution:** Reframe as explicit supposition

**Improved Text:**
> ### Estimated Implementation Timeline
> 
> The following timeline is a planning estimate pending formal project plan approval 
> [SUPPOSITION: Based on typical microservice additions of similar scope (~1,250 LOC)]:
> 
> - **Phase 1:** GIP client setup (estimated 2 weeks) [SUPPOSITION]
> - **Phase 2:** Event adapter implementation (estimated 3 weeks) [SUPPOSITION]
> - **Phase 3:** Integration testing (estimated 2 weeks) [SUPPOSITION]
> - **Phase 4:** Deployment and validation (estimated 1 week) [SUPPOSITION]
> 
> **Total Estimate:** 7-9 weeks [SUPPOSITION: Methodology requires PM validation]
> 
> **Risk:** Timeline assumes GIP API availability and schema alignment (See Risk Register R-INT-01).

**Verification:** 🔮 SUPPOSITION (properly marked)
```

---

## Revision History

| Date | Version | Changes |
|------|---------|---------|
| 2026-03-02 | 1.0 | Initial standard created; added SUPPOSITION tag; integrated with copilot-instructions.md |

---

**Related Documentation:**
- [Global Copilot Instructions](..//copilot-instructions.md)
- [Document Styles](.//document-styles.md)
- [Prompt Tracking Standards](.//prompt-tracking-standards.md)
