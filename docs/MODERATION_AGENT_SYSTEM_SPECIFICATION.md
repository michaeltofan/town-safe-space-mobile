# TOWN — Moderation Agent System Specification

Status: Approved canonical document  
Language: English  
Scope: Product, governance and operational control specification  
Implementation status: Not implemented  
Repository status: Not yet added  

---

## 1. Purpose

This document defines the approved Moderation Agent System for TOWN.

It establishes:

- the six moderation-agent roles;
- the limits of agent authority;
- meaningful human control;
- the complete report-to-case lifecycle;
- typed agent inputs and outputs;
- least-privilege data access;
- emergency actions;
- zero-tolerance handling;
- permanent-ban safeguards;
- auditability;
- multilingual and adversarial testing;
- manual fallback;
- incident response;
- kill-switch requirements;
- pilot and operational-readiness gates.

This document does not select:

- AI vendors;
- foundation models;
- hosting providers;
- cloud architecture;
- final prompts;
- databases;
- cryptographic voting systems;
- incident-response vendors;
- final legal wording.

The following canonical documents are mandatory dependencies:

- `MEMBERSHIP_FOUNDATION_V1.md`
- `DEMOCRATIC_GOVERNANCE_PROTOCOL.md`

No real moderation-agent system may be implemented by interpreting this document in isolation.

---

# Part I — Authority, Roles and Human Control

## 2. Agents assist; they do not rule

**Decision reference: M1**

Moderation agents may:

- detect;
- classify;
- organise;
- preserve;
- redact;
- translate;
- structure;
- prioritise;
- administer approved procedural steps;
- generate audit records;
- identify uncertainty and risk.

Moderation agents may not independently decide:

- guilt;
- suspension;
- permanent ban;
- appeal outcome;
- democratic verdict;
- final legal responsibility.

The governing principle is:

```text
agents detect and prepare
humans supervise
members decide
operator protects legality and immediate safety
```

No suspension or permanent ban may result exclusively from an automated decision.

---

## 3. Six separated agent roles

**Decision reference: M2**

The Moderation Agent System consists of six separate roles:

1. Intake Agent
2. Safety Triage Agent
3. Evidence Agent
4. Democratic Process Agent
5. Appeal Agent
6. Audit and Transparency Agent

No single agent may control the full moderation lifecycle.

The following separations are mandatory:

```text
Intake ≠ Evidence
Evidence ≠ Jury Selection
Jury Selection ≠ Verdict Authority
Appeal ≠ Initial Process
Audit ≠ Operational Editing
```

Each agent must have:

- minimum necessary permissions;
- defined inputs;
- typed outputs;
- explicit prohibitions;
- separate logging;
- versioning;
- shutdown capability;
- manual fallback.

---

## 4. Intake Agent

### Purpose

The Intake Agent converts unstructured reports into structured moderation inputs.

### It may

- verify required fields;
- classify the report reason;
- identify the reported target;
- detect language;
- group duplicates;
- identify linked reports;
- flag probable spam;
- identify possible coordinated reporting;
- request missing information.

### It may not

- declare the report true;
- declare the reported member guilty;
- impose any sanction;
- hide an admissible report;
- rewrite the reporter’s original statement without traceability;
- create a serious governance case without required review.

### Required output

```text
intake_id
language
normalised_reason
target_resolved
missing_fields
duplicate_candidates
coordination_flags
urgency_candidate
confidence
uncertainties
```

The original report must remain preserved and linked to every normalised or translated version.

---

## 5. Safety Triage Agent

### Purpose

The Safety Triage Agent identifies situations that may require immediate protection.

### It may identify

- credible threats;
- immediate physical danger;
- doxxing;
- exposed personal data;
- compromised accounts;
- automated attacks;
- serious fraud;
- apparently illegal content;
- risk of evidence destruction.

### It may automatically trigger only

- temporary concealment of exposed personal data;
- quarantine of a suspicious file;
- revocation or freezing of a compromised session;
- rate limiting;
- temporary pause of distribution;
- placement into `pending_urgent_review`.

### It may not

- impose a permanent ban;
- impose a long-term suspension;
- declare content definitively illegal;
- treat a risk score as a verdict;
- send a case directly to jury without procedural review.

---

## 6. Evidence Agent

### Purpose

The Evidence Agent prepares an attributable and reviewable case record.

### It may

- collect authorised internal material;
- preserve provenance;
- generate integrity hashes;
- build a timeline;
- classify evidence;
- redact unnecessary personal data;
- identify inconsistencies;
- identify missing material;
- prepare neutral summaries;
- link transformations to originals.

### It may not

- fabricate missing evidence;
- alter original evidence;
- treat intent as a verified fact;
- omit exculpatory material;
- declare external evidence authentic without verification;
- recommend a verdict;
- destroy or overwrite source material.

All transformations must follow:

```text
original evidence
→ immutable reference
→ documented transformation
→ reviewable output
```

---

## 7. Democratic Process Agent

### Purpose

The Democratic Process Agent administers the voting mechanics approved in the Democratic Governance Protocol.

### It may

- calculate voter eligibility;
- perform verifiable random jury selection;
- process recusals;
- replace ineligible jurors;
- open and close voting windows;
- prevent duplicate voting;
- calculate quorum;
- apply approved thresholds;
- generate procedural evidence;
- publish aggregated results after closure.

### It may not

- recommend a verdict;
- expose partial results;
- modify voting thresholds;
- manually select favourable jurors;
- exclude members based on presumed opinion;
- identify how an individual voted to ordinary operators;
- invalidate a vote independently.

---

## 8. Appeal Agent

### Purpose

The Appeal Agent prepares an independent appeal record.

### It may

- compare the first process with the approved protocol;
- identify procedural errors;
- identify conflicts of interest;
- evaluate the presence of relevant new evidence;
- identify integrity concerns;
- identify formal proportionality issues;
- prepare a neutral appeal file.

### It may not

- confirm the original sanction automatically;
- reject an appeal because the first vote was decisive;
- reuse the original jury;
- omit new relevant evidence;
- determine the final appeal outcome.

---

## 9. Audit and Transparency Agent

### Purpose

The Audit and Transparency Agent produces internal traceability and public procedural transparency.

### It may produce

- `case_id`;
- complete timeline;
- applicable rule version;
- agent actions;
- human actions;
- emergency measures;
- voting metadata;
- aggregated result;
- appeal history;
- implementation status;
- transparency statistics.

### It may not

- publish protected personal data;
- reveal juror identities;
- reveal reporter identity without lawful justification;
- rewrite history;
- delete inconvenient events;
- alter past audit records;
- expose security controls that would enable abuse.

---

## 10. Reversible emergency automation only

**Decision reference: M3**

Automated emergency action is permitted only where the action is:

- temporary;
- narrow;
- reversible where possible;
- limited to immediate harm prevention;
- fully logged;
- automatically expiring unless confirmed;
- rapidly reviewed by a human.

Any restriction affecting participation rights requires prompt human review.

An automated emergency action is not a democratic verdict.

---

## 11. Meaningful human control

**Decision reference: M4**

Meaningful human control is mandatory for:

- acceptance of serious cases;
- ambiguous classification;
- confirmation of participation restrictions;
- approval of the neutral case file;
- vote invalidation;
- legal escalation;
- confirmation or removal of emergency measures.

The human reviewer must be able to:

- inspect relevant source material;
- reject the agent output;
- request corrections;
- narrow the action;
- stop the case;
- document the reason.

Human review must be substantive, not symbolic.

---

## 12. Complete audit trail

**Decision reference: M5**

Every input, transformation, recommendation, automated action, human decision, state change, democratic action and final result must be recorded.

The audit trail must be:

- append-only;
- version-linked;
- resistant to unauthorised alteration;
- access-controlled;
- separate from commercial analytics;
- exportable for appeal and audit;
- subject to a future Retention Schedule.

The audit trail must not become a general behavioural-surveillance system.

---

# Part II — Case Flow, Data and Agent Outputs

## 13. End-to-end case lifecycle

**Decision reference: M6**

Every report must move through an explicit state model.

Approved conceptual states:

```text
received
intake_processing
needs_information
duplicate_or_linked
urgent_safety_review
admissibility_review
rejected_as_inadmissible
accepted_as_case
evidence_preparation
awaiting_member_response
human_procedural_review
ready_for_jury
voting
decision_pending_execution
decided
appeal_requested
appeal_preparation
appeal_voting
final
invalidated
archived
```

No sanctioning stage may be skipped.

Every transition must include:

```text
author
reason
timestamp
previous_state
new_state
```

---

## 14. Intake stage

### Input

```text
reporter_id
target_type
target_id
reason_selected
reporter_explanation
attachments
submitted_at
community_id
```

### Output

```text
intake_id
language
normalised_reason
target_resolved
missing_fields
duplicate_candidates
coordination_flags
urgency_candidate
confidence
uncertainties
```

### Allowed transitions

- `needs_information`
- `duplicate_or_linked`
- `urgent_safety_review`
- `admissibility_review`

---

## 15. Safety triage stage

### Input

Only the data necessary to evaluate immediate risk.

### Output

```text
safety_level
identified_risk_types
immediacy
potential_harm
recommended_reversible_action
required_review_deadline
reasoning_summary
confidence
uncertainties
```

Any participation restriction requires a human checkpoint.

---

## 16. Admissibility review

A report may become a formal case only when:

- the target is identifiable;
- a published rule is applicable;
- the alleged facts are sufficiently clear;
- the matter is within TOWN’s scope;
- the report is not merely duplicative;
- the report is not manifestly abusive;
- sufficient material exists for examination.

### Output

```text
admissibility_status
applicable_rule_version
scope
rejection_reason
linked_cases
human_reviewer_id
reviewed_at
```

Only a human reviewer may accept a serious or potentially sanctionable case.

---

## 17. Evidence stage

Each evidence item must include:

```text
evidence_item_id
source_type
source_reference
submitted_by
collected_at
integrity_hash
verification_level
disputed_status
redactions
access_class
agent_transformations
human_validation_status
```

Approved evidence classifications:

```text
verified_internal
technically_correlated
externally_submitted_unverified
disputed
insufficient_provenance
inadmissible
```

The original material must never be overwritten by a translation, summary or redaction.

---

## 18. Member response stage

The affected member must receive:

- `case_id`;
- applicable rule;
- essential allegation;
- accessible evidence;
- possible consequences;
- response deadline;
- explanation of any temporary restriction.

The member may:

- contest facts;
- explain context;
- submit evidence;
- identify mistaken attribution;
- raise procedural objections;
- declare conflicts of interest.

### Output

```text
member_response_status
original_response
translated_response
submitted_evidence
conflict_of_interest_claims
procedural_objections
submitted_at
```

---

## 19. Human procedural review

Before a case reaches a civic jury, a human reviewer must verify:

- admissibility;
- evidence classification;
- meaningful defence;
- necessary redaction;
- no retroactive rule;
- neutral language;
- allowed sanction range;
- procedural completeness.

### Output

```text
procedural_review_status
reviewer_id
approved_case_scope
approved_evidence_set
excluded_evidence
required_corrections
jury_ready
reasoning
timestamp
```

---

## 20. Democratic-process output

The Democratic Process Agent receives only the approved neutral file and authorised governance data.

### Input

```text
case_id
approved_neutral_case_file
community_id
case_type
allowed_sanctions
jury_size
quorum
thresholds
voting_window
```

### Output

```text
selection_proof
eligible_population_count
selected_jury
recusal_events
replacement_events
vote_opened_at
vote_closed_at
votes_cast
abstentions
quorum_status
threshold_result
integrity_flags
```

Individual voting identity must remain separated from the published result.

---

## 21. Appeal output

### Input

- original decision;
- procedural history;
- appeal grounds;
- new evidence;
- alleged conflicts;
- integrity concerns.

### Output

```text
appeal_admissibility
procedural_errors
new_evidence_status
conflict_findings
integrity_findings
sanction_proportionality_issue
neutral_appeal_file
```

The Appeal Agent prepares the case. It does not decide the result.

---

## 22. Audit outputs

### Internal case record

```text
complete_case_timeline
agent_versions
all_transformations
human_actions
automatic_actions
access_events
vote_proof
appeal_history
execution_status
```

### Public procedural summary

```text
case_id
rule
case_category
decision
duration
jury_size
quorum
aggregated_vote
appeal_status
final_status
```

---

## 23. Structured agent contracts

**Decision reference: M7**

Every agent must operate through a defined contract containing:

- limited inputs;
- typed outputs;
- confidence;
- uncertainty;
- source references;
- version;
- authorised actions;
- prohibited actions;
- error state.

The original user content must remain distinct from any agent-generated summary.

---

## 24. Mandatory human checkpoints

**Decision reference: M8**

Human review is mandatory for:

- serious-case admission;
- confirmation of urgent participation restrictions;
- approval of the neutral case file;
- vote invalidation;
- legal escalation;
- final emergency disposition.

No agent may bypass these checkpoints.

---

## 25. Least-privilege data access

**Decision reference: M9**

Each agent receives only the data required for its role.

| Agent | Permitted data |
|---|---|
| Intake | report and reported target |
| Safety Triage | urgent context and relevant technical signals |
| Evidence | authorised case evidence |
| Democratic Process | redacted case file, eligibility and voting data |
| Appeal | original process, appeal and new evidence |
| Audit | procedural events and required metadata |

Data must be redacted where unnecessary, including:

- address;
- precise coordinates;
- email;
- payment information;
- authentication tokens;
- unnecessary full IP data;
- reporter identity;
- juror identity;
- third-party personal data;
- sensitive data unrelated to the case;
- information concerning minors.

---

## 26. Uncertainty remains visible

**Decision reference: M10**

Missing information, contradictory evidence, unverified material and agent errors must remain explicitly visible.

Approved states include:

```text
needs_information
disputed
externally_submitted_unverified
agent_output_rejected
manual_review
```

Agents may not convert uncertainty into fact.

When the case is insufficient, it must be:

- completed;
- rejected;
- delayed;
- or closed without sanction.

---

# Part III — Zero-Tolerance, Emergency Actions and Permanent Ban

## 27. Zero-tolerance taxonomy

**Decision reference: M11**

The approved zero-tolerance categories are:

1. serious violence and credible threats;
2. doxxing and dangerous exposure of personal information;
3. severe or coordinated harassment;
4. grave discriminatory abuse;
5. sexual exploitation or non-consensual intimate content;
6. deliberate attacks on democratic integrity.

These categories must be defined precisely in Terms of Use and enforcement guidance.

A general phrase such as “behave like humans” may express the moral principle, but may not be the sole legal basis for a sanction.

---

## 28. Serious violence and credible threats

Includes conduct such as:

- credible threats of harm;
- organising or soliciting an attack;
- incitement to concrete violence;
- targeted glorification of violence against a member;
- operational instructions for harming a person.

It does not automatically include:

- metaphor;
- reporting a news event;
- lawful political condemnation;
- satire;
- non-credible rhetorical language.

Context is mandatory.

---

## 29. Doxxing

Includes unauthorised exposure of:

- private address;
- precise location;
- telephone number;
- family information;
- schedule or route;
- identity documents;
- information enabling tracking or attack.

Doxxing content may be concealed immediately because the harm continues while the information remains visible.

---

## 30. Severe or coordinated harassment

Includes:

- repeated intimidation;
- cyberstalking;
- coordinated targeting;
- repeated contact after blocking;
- organised humiliation;
- repeated indirect threats;
- attempts to force a member out of the community.

An isolated rude statement is not automatically severe harassment.

---

## 31. Grave discriminatory abuse

Includes severe targeted abuse, threats or incitement based on protected characteristics.

Lawful disagreement, including political, religious or moral disagreement, is not automatically discriminatory abuse.

The conduct must meet a precise published rule.

---

## 32. Sexual exploitation and non-consensual intimate content

Includes:

- intimate material shared without consent;
- threats to publish intimate material;
- manipulated sexual material targeting a person;
- sexual exploitation;
- child sexual-abuse material;
- grooming or sexual coercion.

Such cases require restricted evidence access and legal escalation where required.

---

## 33. Attacks on democratic integrity

Includes:

- multiple identities used to capture voting;
- vote buying;
- voter intimidation;
- exposure of secret voting;
- technical manipulation of jury selection;
- deliberate evidence fabrication;
- coordinated evasion of a permanent ban.

---

## 34. Emergency protection

**Decision reference: M12**

Approved safety levels:

```text
S0 — no immediate danger
S1 — elevated concern
S2 — immediate member-safety risk
S3 — critical legal or physical danger
```

Permitted automated actions are limited to:

```text
hide_exposed_personal_data
quarantine_uploaded_file
freeze_compromised_session
rate_limit_account
pause_distribution
mark_urgent_review
```

Any participation restriction requires rapid human review and automatic expiry if not confirmed.

---

## 35. Human emergency review record

Every emergency action must create:

```text
emergency_action_id
triggering_material
agent_version
risk_category
action_taken
started_at
automatic_expiry
assigned_reviewer
review_status
review_reasoning
final_disposition
```

The human reviewer may:

- confirm temporarily;
- narrow;
- remove;
- request more information;
- open a case;
- escalate legally;
- send the matter to democratic process.

The reviewer may not convert an emergency action directly into a permanent ban.

---

## 36. Permanent-ban safeguards

**Decision reference: M13**

A permanent ban is valid only when all conditions are satisfied:

1. the rule existed before the conduct;
2. the case was admissible;
3. the zero-tolerance category was precisely identified;
4. evidence was attributable and classified;
5. the member received notice where possible;
6. the member had meaningful defence;
7. the neutral file was human-validated;
8. the civic jury was validly selected;
9. quorum was at least 31 of 51;
10. at least 75% of valid votes confirmed the grave violation;
11. Constitutional Safeguard Review found no discrimination, retaliation or material defect;
12. the result was reasoned;
13. appeal remained available.

---

## 37. Jury confirms the violation

**Decision reference: M14**

For zero-tolerance cases, the civic jury answers:

> Was the defined grave violation demonstrated under the applicable rule?

The jury does not invent a penalty.

If the valid result reaches the approved threshold, the predetermined sanction is permanent ban.

The operator and agents may not substitute a different penalty arbitrarily.

---

## 38. Terms of Use requirements

**Decision reference: M15**

Terms of Use must contain:

### Human principle

> Every member agrees to treat other human beings with dignity, non-violence and respect for their fundamental rights.

### Precise enforceable rules

Sanctions must rely on defined categories, evidence standards and approved procedures.

“Behave like humans” may remain a public principle or preamble, but may not be the sole basis for permanent exclusion.

The final legal language requires separate legal approval.

---

# Part IV — Auditability, Testing and Operational Readiness

## 39. Version-linked auditability

**Decision reference: M16**

Every case action must be linked to the exact version of:

```text
agent code
model
system prompt
policy prompt
classification taxonomy
Terms of Use
Democratic Governance Protocol
sanction thresholds
redaction rules
risk thresholds
human-review instructions
```

Minimum event record:

```text
event_id
case_id
agent_role
agent_version
model_or_rule_version
input_references
output_hash
action_type
confidence
uncertainties
automatic_or_human
human_reviewer_id
timestamp
previous_state
new_state
reason
```

For material updates during a case:

```text
old output preserved
→ new evaluation recorded separately
→ difference explained
→ human procedural review
```

No update may rewrite the historical record.

---

## 40. Multilingual and bias testing

**Decision reference: M17**

No agent may enter pilot without testing in the active community languages.

Initial testing must cover at least:

- Italian;
- German;
- spelling errors;
- slang;
- irony;
- quoted abuse;
- reported speech;
- indirect threats;
- local expressions;
- mixed-language content;
- incomplete translations.

Testing must measure, where applicable:

- false positives;
- false negatives;
- precision;
- recall;
- missed urgent risks;
- unnecessary emergency referrals;
- inconsistent classifications;
- human rejection rates;
- language differences;
- group differences;
- drift over time.

Test sets must include lawful material that must not be sanctioned, such as:

- harsh criticism;
- lawful political opinion;
- lawful religious disagreement;
- satire;
- reporting an abusive statement;
- educational use of sensitive language;
- minority members describing their own experiences.

---

## 41. Adversarial testing and red-teaming

Mandatory scenarios include:

### Content manipulation

- hidden text;
- visually similar characters;
- coded language;
- ambiguous translation;
- prompt injection in reports or evidence;
- instructions embedded inside documents;
- truncation that changes meaning.

### Evidence manipulation

- fabricated evidence;
- altered timestamps;
- decontextualised screenshots;
- deepfakes;
- duplicates presented as separate events;
- selective omission of exculpatory evidence.

### Democratic manipulation

- multiple accounts;
- brigading;
- voter intimidation;
- jury deanonymisation;
- attacks on random selection;
- leaked partial results.

### Agent manipulation

- role overreach;
- fabricated policy;
- fabricated source;
- Evidence Agent recommending a verdict;
- Appeal Agent copying original bias;
- Audit Agent omitting events.

### Internal abuse

- unauthorised reviewer changes;
- operator interference with jury selection;
- altered logs;
- emergency actions extended without review;
- case-data access outside the case purpose.

---

## 42. Manual fallback

**Decision reference: M18**

Fallback must activate when:

- an agent is unavailable;
- output is invalid;
- confidence is insufficient;
- agents materially contradict each other;
- a security incident occurs;
- drift is demonstrated;
- prompt injection is suspected;
- the agent cannot process the language reliably;
- error thresholds are exceeded.

Functions that may continue manually:

- report intake;
- urgent protection;
- human admissibility review;
- evidence preservation;
- member notification;
- appeal intake;
- required legal actions.

Functions that must stop when they cannot be performed safely:

- automatic case opening;
- neutral-file generation;
- automatic jury selection;
- new voting processes;
- automatic sanction execution.

Manual fallback does not authorise the operator to replace member sovereignty.

---

## 43. Incident response and kill switch

**Decision reference: M19**

Incident categories include:

- agent safety incident;
- data incident;
- governance incident;
- model-integrity incident;
- internal-abuse incident.

Minimum incident flow:

```text
detect
→ contain
→ preserve evidence
→ stop affected function
→ assign human incident lead
→ assess member impact
→ notify where required
→ remediate
→ independent review
→ controlled restart
```

A kill switch is mandatory.

It must activate when a component:

- applies an unauthorised sanction;
- exposes protected data;
- compromises vote secrecy;
- uses an unapproved version;
- produces unauditable outputs;
- repeatedly ignores exculpatory material;
- shows material bias;
- is vulnerable to procedural prompt injection;
- loses source traceability;
- prevents meaningful human intervention;
- breaks the audit trail;
- exceeds approved error thresholds;
- is reasonably suspected to be compromised.

The stopped agent cannot reactivate itself.

---

## 44. Pilot-readiness gates

**Decision reference: M20**

No pilot may begin until all of the following are complete:

### Governance and legal

- D1–D24 approved and canonical;
- G1–G20 approved and canonical;
- M1–M20 approved and canonical;
- Terms of Use legally reviewed;
- sanction taxonomy published;
- appeal procedure available;
- direct-distribution review completed.

### Technical

- agent permissions separated;
- audit trail functional;
- versioning complete;
- kill switch operational;
- manual fallback available;
- backup and recovery tested;
- vote secrecy protected;
- monitoring operational.

### Evaluation

- Italian and German testing completed;
- false-positive and false-negative benchmarks completed;
- red-team completed;
- privacy testing completed;
- security testing completed;
- voting-integrity testing completed;
- human-review testing completed;
- incident-response exercise completed.

### Operational

- trained personnel available;
- responsibilities assigned;
- escalation channels defined;
- member-contact channel available;
- independent observer available;
- pilot-stop procedure documented.

No real operation may begin until:

1. critical pilot incidents are closed;
2. no open defect can produce an incorrect sanction;
3. bias testing is accepted;
4. manual operations can take over;
5. civic jury works end-to-end;
6. appeal works end-to-end;
7. independent audit confirms protocol application;
8. legal review is closed;
9. required privacy assessments are complete;
10. the owner explicitly approves operational readiness.

Core rule:

```text
uncertain system
→ no sanction

compromised process
→ no democratic verdict

unsafe operation
→ stop the affected system
```

---

# Part V — Explicitly Unresolved Matters

This document does not approve:

- AI vendor;
- model provider;
- model version;
- final system prompts;
- confidence thresholds;
- exact human-review deadlines;
- exact emergency-action expiry;
- database schema;
- audit-storage technology;
- append-only implementation;
- cloud region;
- international transfers;
- log-retention periods;
- named staff roles;
- 24/7 operating model;
- law-enforcement workflow;
- national legal variations;
- minors policy;
- deepfake-detection provider;
- threat-assessment methodology;
- red-team provider;
- acceptable error thresholds;
- final legal Terms of Use wording;
- DPIA;
- AI Act classification;
- pilot date;
- production date.

All unresolved matters require separate research, specification and owner approval.

---

# Part VI — Implementation Prohibition

This document does not authorise implementation by itself.

No production moderation agent, democratic sanction engine or permanent-ban system may be built or deployed until TOWN has:

1. all three approved canonical documents;
2. final legal and direct-distribution review;
3. approved technical architecture;
4. approved data model;
5. approved identity and uniqueness model;
6. approved voting architecture;
7. approved retention schedule;
8. approved security architecture;
9. validated Terms of Use;
10. explicit owner approval for implementation.

No developer, Cursor agent, AI agent or external contractor may infer implementation permission from this document alone.

---

# Part VII — Traceability

| Decision | Subject |
|---|---|
| M1 | Agents assist; they do not rule |
| M2 | Six separated agent roles |
| M3 | Reversible emergency automation only |
| M4 | Meaningful human control |
| M5 | Complete audit trail |
| M6 | Typed end-to-end case lifecycle |
| M7 | Structured agent contracts |
| M8 | Mandatory human checkpoints |
| M9 | Least-privilege data access |
| M10 | Uncertainty remains visible |
| M11 | Defined zero-tolerance taxonomy |
| M12 | Temporary, narrow and reversible emergency protection |
| M13 | Permanent ban requires cumulative due process |
| M14 | Jury confirms violation; sanction predetermined |
| M15 | Human principle plus precise Terms of Use |
| M16 | Version-linked auditability |
| M17 | Multilingual, bias and adversarial testing |
| M18 | Manual fallback and no unsafe continuity |
| M19 | Incident response and kill switch |
| M20 | No pilot or operation without readiness gates |

---

## Owner approval status

Approved as the canonical consolidation of decisions M1–M20.
