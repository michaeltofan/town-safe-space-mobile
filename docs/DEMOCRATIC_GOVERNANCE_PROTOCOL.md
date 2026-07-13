# TOWN — Democratic Governance Protocol

Status: Approved canonical document  
Language: English  
Scope: Constitutional governance protocol  
Implementation status: Not implemented  
Repository status: Not yet added  

---

## 1. Purpose

This document defines the constitutional governance framework for democratic sanctions in TOWN.

It establishes:

- the authority of members;
- the limits of democratic power;
- how reports become formal cases;
- how evidence and defence are handled;
- who may vote;
- how civic juries are selected;
- quorum and voting thresholds;
- appeal rights;
- anti-brigading protections;
- transparency requirements;
- bootstrap rules for new or small communities.

This document does not define the technical implementation of voting, identity verification, cryptography, moderation agents or backend systems.

Those matters depend on:

- `MEMBERSHIP_FOUNDATION_V1.md`
- `MODERATION_AGENT_SYSTEM_SPECIFICATION.md`

No democratic sanction system may be implemented by interpreting this document in isolation.

---

# Part I — Constitutional Boundaries

## 2. Member sovereignty

**Decision reference: G1**

Members have primary authority over ordinary community sanctions.

This authority is exercised only within:

- the published TOWN constitution;
- applicable law;
- fundamental rights;
- procedural fairness;
- minority protections;
- approved rules existing before the alleged conduct.

Member sovereignty does not mean unrestricted majority power.

The community may judge ordinary community violations, but may not vote to remove constitutional protections or legal obligations.

---

## 3. Non-votable protections

**Decision reference: G2**

No vote may validly authorise:

- illegal conduct;
- discrimination;
- disclosure of personal data;
- retroactive punishment;
- elimination of the right to respond;
- elimination of the right to appeal;
- punishment for protected characteristics;
- punishment for exercising lawful procedural rights;
- non-compliance with a valid legal obligation.

These protections remain binding even when a majority would prefer otherwise.

---

## 4. Operator as guardian, not sovereign

**Decision reference: G3**

The TOWN operator protects:

- legality;
- immediate safety;
- technical security;
- procedural integrity;
- evidence preservation;
- proper execution of valid democratic outcomes.

The operator must not:

- decide permanent ordinary sanctions arbitrarily;
- manipulate the jury;
- alter votes;
- suppress valid evidence;
- hide results;
- invalidate a result because of disagreement with the outcome;
- use safety as an unlimited justification for permanent exclusion.

The operator maintains the constitutional system but does not replace the democratic authority of members.

---

## 5. Democratic and mandatory decisions

**Decision reference: G4**

The following are subject to democratic decision:

- community warning;
- temporary participation restriction;
- suspension;
- permanent community ban;
- removal or modification of a democratic sanction;
- appeal outcomes where the protocol provides for member decision.

The following are not subject to community vote:

- compliance with valid legal orders;
- immediate response to physical danger;
- removal or restriction of apparently illegal material where required;
- technical security measures;
- protection of exposed personal data;
- voluntary account deletion;
- fundamental procedural rights.

Mandatory interventions must still be documented, limited and reviewable.

---

## 6. No retroactive rules

**Decision reference: G5**

No member may be sanctioned under a rule that:

- did not exist at the time of the alleged conduct;
- was not published;
- was materially unclear;
- was expanded after the conduct occurred.

Future constitutional or policy changes must follow a separate process of:

- proposal;
- deliberation;
- approval;
- publication;
- future effective date.

A moderation case may not be used to invent a new rule retroactively.

---

# Part II — Case, Evidence and Defence

## 7. Report and case are separate

**Decision reference: G6**

A report is an allegation or notice.

It does not automatically become a democratic case.

Before formal case creation, TOWN must verify:

- the target of the report;
- the rule allegedly violated;
- the minimum factual information;
- duplicate or linked reports;
- whether the matter falls within TOWN’s scope;
- whether the report is manifestly abusive;
- whether sufficient material exists for examination.

A high number of reports does not automatically prove wrongdoing.

---

## 8. Moderation agents prepare; humans and members decide

**Decision reference: G7**

Moderation agents may:

- classify;
- organise;
- preserve;
- redact;
- translate;
- structure;
- identify missing information;
- detect procedural risks.

They may not independently decide:

- guilt;
- suspension;
- permanent ban;
- the result of an appeal.

Serious, ambiguous or potentially sanctionable cases require meaningful human procedural review before democratic voting.

Members retain authority over ordinary definitive sanctions.

---

## 9. Evidence must be attributable and classified

**Decision reference: G8**

Every evidence item must include:

- source;
- provenance;
- timestamp;
- integrity reference;
- submitter or collection origin;
- verification status;
- dispute status;
- access classification;
- any transformation applied.

Evidence must be classified, where applicable, as:

- verified internal evidence;
- technically correlated evidence;
- externally submitted but unverified material;
- disputed material;
- insufficiently attributable material;
- inadmissible material.

The case file must distinguish verified facts from allegations and uncertainty.

---

## 10. Notice and meaningful defence

**Decision reference: G9**

The affected member must be informed, where safety and law permit, of:

- the existence of the case;
- the applicable rule;
- the essential allegation;
- the relevant facts;
- the possible consequences;
- the response deadline;
- any temporary restriction;
- the next procedural step.

The member must be able to:

- contest facts;
- explain context;
- submit evidence;
- identify mistaken attribution;
- raise conflicts of interest;
- raise procedural objections;
- respond before voting.

Notification may be delayed or limited only where necessary to protect safety, evidence, third parties or a legal process.

Any limitation must be:

- specific;
- documented;
- temporary;
- reviewed.

---

## 11. Neutral case file

**Decision reference: G10**

Eligible jurors must receive a neutral case file containing:

- the allegation;
- verified facts;
- disputed facts;
- unverified material;
- the affected member’s response;
- the applicable rule;
- the permitted sanctions;
- procedural warnings.

The case file must not:

- declare the member guilty in advance;
- recommend a verdict;
- use persuasive or inflammatory language;
- omit relevant exculpatory material;
- conceal material uncertainty.

If the case file is incomplete or unreliable, the case must be:

- returned for completion;
- rejected;
- closed without sanction;
- or delayed pending further information.

---

# Part III — Electorate, Quorum and Voting

## 12. Civic jury model

**Decision reference: G11**

Ordinary sanctions are not decided by a public referendum of the entire city.

They are decided by a temporary civic jury selected randomly and verifiably from eligible members of the relevant community.

The civic-jury model is intended to:

- protect privacy;
- reduce mob dynamics;
- improve deliberation;
- limit brigading;
- prevent public humiliation;
- preserve member sovereignty.

The operator must not manually select jurors based on expected opinions.

---

## 13. Voter eligibility

**Decision reference: G12**

A member may enter the civic-jury selection pool only if the member:

- is an Active Member;
- belongs to the same verified community;
- had an active account before the case was opened;
- has at least 90 continuous days of membership;
- is not suspended;
- is not in payment hold;
- is not the reported person;
- is not the primary reporter;
- is not a direct participant in the incident;
- has no material conflict of interest;
- passes uniqueness and voting-integrity checks.

The following must be excluded:

- the reporter;
- the affected member;
- direct witnesses where their role creates a conflict;
- household members of a party;
- members with documented material relationships to a party;
- members involved in coordinated campaigning around the case;
- members who publicly committed to a verdict before reviewing the case.

Recusals must be documented and replaced through a new random selection.

---

## 14. Jury size and quorum

**Decision reference: G13**

### Standard case

For warnings, short restrictions or temporary suspensions:

```text
jury_size = 25
minimum_valid_quorum = 15
```

### Permanent ban

For permanent exclusion:

```text
jury_size = 51
minimum_valid_quorum = 31
```

If quorum is not reached:

- no democratic sanction is imposed;
- no temporary emergency measure becomes permanent automatically;
- one additional jury selection may be attempted;
- if quorum is still not reached, the case closes without a definitive democratic sanction.

Independent legal or safety obligations may still be executed separately.

---

## 15. Voting thresholds

**Decision reference: G14**

The approved thresholds are:

| Decision | Required threshold |
|---|---:|
| Warning | More than 50% |
| Participation restriction up to 7 days | At least 60% |
| Suspension from 8 to 90 days | At least two thirds |
| Permanent ban | At least 75% |

The threshold is calculated from valid votes for or against the sanction.

Abstentions count toward participation but not toward sanction approval.

If the relevant threshold is not reached, that sanction is not imposed.

No permanent ban may result from a narrow simple majority.

---

## 16. Secret, equal and time-bounded voting

**Decision reference: G15**

Every eligible juror has:

```text
one member
→ one secret vote
```

The vote must be:

- secret from other members;
- technically verifiable;
- protected from coercion;
- free from live result disclosure;
- protected from modification after submission;
- auditable in aggregate;
- separated from public identity.

Voting periods are:

### Standard cases

```text
minimum = 72 hours
maximum = 5 days
```

### Permanent-ban cases

```text
minimum = 7 days
maximum = 10 days
```

The voting period begins only after:

- the neutral case file is complete;
- the member response is included;
- jurors are selected;
- conflicts are resolved;
- the voting window is formally opened.

---

# Part IV — Appeal, Anti-Abuse and Transparency

## 17. Independent democratic appeal

**Decision reference: G16**

Every suspension or permanent ban may be appealed by the affected member.

The appeal must be examined by a separate civic jury.

Appeal jurors must:

- not have participated in the first jury;
- not have served as replacements in the first jury;
- have no conflict of interest;
- not have publicly campaigned about the case;
- satisfy the same eligibility standards as original jurors.

An appeal may raise:

- procedural error;
- conflict of interest;
- new relevant evidence;
- falsified or wrongly attributed evidence;
- manipulation of the electorate;
- incorrect rule application;
- disproportionate sanction;
- denial of meaningful defence.

The appeal is not merely a repetition of the first vote.

---

## 18. Appeal jury and thresholds

For appeals, the approved jury model is:

| Appeal type | Jury size | Quorum |
|---|---:|---:|
| Warning or short restriction | 15 | 9 |
| Suspension | 25 | 15 |
| Permanent ban | 51 | 31 |

The approved reversal or confirmation thresholds are:

- simple majority for warning or short restriction;
- at least 60% for suspension;
- at least two thirds for permanent-ban appeal outcomes.

The final technical wording of how reversal and confirmation votes are framed must be specified later without changing these approved principles.

---

## 19. Anti-brigading and procedural invalidation

**Decision reference: G17**

TOWN must detect and investigate indicators such as:

- multiple coordinated accounts;
- unusual account creation or reactivation patterns;
- intimidation;
- vote buying;
- disclosure of juror identity;
- interference with vote secrecy;
- coordinated efforts to capture a case;
- falsified evidence;
- unauthorised distribution of the case file;
- attempts to manipulate jury selection.

Indicators are not automatic proof.

A vote may be invalidated only after:

```text
technical evidence
→ human integrity review
→ documented procedural decision
```

Valid grounds for invalidation include:

- demonstrated multiple voting;
- compromised secrecy;
- incorrect random selection;
- materially ineligible jurors;
- significant conflicts of interest;
- technical manipulation;
- exposure of partial results;
- material alteration of the case file after voting began;
- major technical unavailability affecting participation.

Operator disagreement with the result is not valid grounds for invalidation.

---

## 20. One controlled revote

**Decision reference: G18**

A compromised process may be repeated once.

The revote must use:

- a completely new jury;
- a corrected case file;
- the same applicable rule;
- the same thresholds;
- a complete new voting period;
- a public procedural explanation of what changed.

The operator may not repeat voting until a preferred outcome is obtained.

If the revote:

- remains compromised;
- fails quorum;
- or cannot be executed constitutionally;

then no definitive democratic sanction is imposed.

Temporary urgent restrictions must not become permanent through procedural failure.

---

## 21. Transparent results with protected identities

**Decision reference: G19**

For each final case, TOWN must publish an aggregated procedural result containing:

```text
case_id
rule_applied
case_category
sanction_or_no_sanction
duration
jury_size
eligible_population
votes_cast
abstentions
quorum_status
aggregated_result
appeal_status
final_execution_status
```

TOWN must not automatically publish:

- juror identities;
- reporter identity;
- personal addresses;
- raw evidence;
- sensitive data;
- technical logs;
- security controls;
- third-party personal data;
- information concerning minors;
- information that could cause doxxing or retaliation.

Transparency must explain the process without creating a permanent public archive of humiliation.

Serious cases and pilot operations may be reviewed by independent observers.

Observers:

- do not vote;
- do not decide the verdict;
- must declare independence;
- must disclose conflicts;
- must follow confidentiality rules;
- receive only the access necessary for procedural review.

---

## 22. Bootstrap governance and minority protection

**Decision reference: G20**

A community enters `bootstrap governance` when any of the following applies:

```text
active_members < 75
community_age < 90 days
eligible_jury_members < 51
```

During bootstrap:

- local permanent bans are not permitted;
- warnings and temporary safety restrictions remain available;
- serious cases may use a cross-community civic jury;
- jurors should, where reasonably possible, come from the same country and legal-language context;
- an independent observer is mandatory;
- long-duration sanctions should be reviewed after the community matures.

No result may be executed if it:

- violates constitutional protections;
- punishes a protected characteristic;
- results from retaliation;
- removes procedural rights;
- applies a retroactive rule;
- is materially compromised.

Before executing a permanent ban, TOWN must perform a Constitutional Safeguard Review confirming:

- the rule was valid and pre-existing;
- the jury and quorum were valid;
- the member received meaningful defence;
- the result was not discriminatory;
- there is no demonstrated retaliation;
- there is no material procedural defect.

The review does not replace the democratic verdict. It checks only constitutional validity.

---

# Part V — Zero-Tolerance Relationship

## 23. Zero-tolerance cases

Zero-tolerance categories are defined in:

- `MODERATION_AGENT_SYSTEM_SPECIFICATION.md`

For zero-tolerance cases:

- the jury decides whether the defined grave violation was demonstrated;
- the jury does not invent a penalty;
- if the approved 75% threshold is reached with quorum 31 of 51, the predetermined sanction is permanent ban;
- the member retains appeal rights;
- emergency protection may be applied temporarily before the final decision.

The zero-tolerance process must still comply with G1–G20.

---

# Part VI — Procedural Records

## 24. Minimum case record

Each case must preserve at least:

```text
case_id
rule_version
report_reference
admissibility_decision
evidence_index
member_notice
member_response
procedural_review
jury_selection_proof
conflict_and_recusal_record
voting_window
jury_size
quorum
threshold
aggregated_result
decision_reason
appeal_status
execution_status
audit_references
```

Records must be:

- versioned;
- access-controlled;
- resistant to unauthorised modification;
- subject to a future Retention Schedule;
- redacted for public transparency.

---

# Part VII — Explicitly Unresolved Matters

This document does not yet approve:

- the cryptographic voting architecture;
- the random-selection algorithm;
- public verification methods;
- juror notification mechanics;
- exact appeal deadlines;
- exact response deadlines;
- maximum emergency-restriction duration;
- exact standards for evidence sufficiency;
- treatment of minors;
- witness-protection procedures;
- deepfake verification;
- lawful-evidence standards;
- observer-selection mechanism;
- observer funding;
- independent dispute-resolution providers;
- authority-handling workflows;
- national-law variations;
- technical proof of one-member-one-vote;
- final public decision format;
- final governance Terms of Use language.

These require separate technical, legal and operational approval.

---

# Part VIII — Implementation Prohibition

This document does not authorise implementation by itself.

No real civic jury, sanction vote, appeal vote, suspension or permanent ban may be implemented until TOWN has:

1. this approved canonical protocol;
2. the approved Moderation Agent System Specification;
3. validated Terms of Use;
4. legal and direct-distribution review;
5. approved voting architecture;
6. identity and uniqueness controls;
7. audit infrastructure;
8. multilingual and adversarial testing;
9. manual fallback;
10. incident response;
11. owner approval for pilot implementation.

No developer, agent or tool may infer permission to build unresolved governance functionality from this document.

---

# Part IX — Traceability

| Decision | Subject |
|---|---|
| G1 | Member sovereignty within constitutional limits |
| G2 | Non-votable fundamental protections |
| G3 | Operator as guardian, not sovereign |
| G4 | Separation of democratic and mandatory decisions |
| G5 | No retroactive rules |
| G6 | Report and case are separate |
| G7 | Agents prepare; humans and members decide |
| G8 | Evidence must be attributable and classified |
| G9 | Notice and meaningful defence |
| G10 | Neutral case file |
| G11 | Randomly selected civic jury |
| G12 | Voter eligibility and conflicts |
| G13 | Jury size and quorum |
| G14 | Proportional voting thresholds |
| G15 | Secret, equal and time-bounded vote |
| G16 | Independent democratic appeal |
| G17 | Anti-brigading and procedural invalidation |
| G18 | One controlled revote |
| G19 | Transparent results with protected identities |
| G20 | Bootstrap governance and minority safeguards |

---

## Owner approval status

Approved as the canonical consolidation of decisions G1–G20.
