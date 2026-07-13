# TOWN — Membership Foundation v1

Status: Approved canonical document  
Language: English  
Scope: Product contract  
Implementation status: Not implemented  
Repository status: Not yet added  

---

## 1. Purpose

This document defines the approved membership foundation for TOWN.

It establishes:

- who may access TOWN;
- who may participate;
- what local verification means;
- how paid membership works;
- how account, verification, entitlement, suspension and deletion differ;
- what personal data TOWN may process;
- the participation and moderation rights attached to membership.

This document is a product contract. It does not select:

- authentication providers;
- payment providers;
- backend technologies;
- AI models;
- database architecture;
- hosting infrastructure;
- legal entities;
- final Terms of Use language.

No membership, sanction, voting or moderation system may be implemented by interpreting this document in isolation.

The following approved documents are mandatory dependencies:

- `DEMOCRATIC_GOVERNANCE_PROTOCOL.md`
- `MODERATION_AGENT_SYSTEM_SPECIFICATION.md`

---

## 2. Product principles

TOWN is a paid, local and democratic civic community.

Its membership model is based on these principles:

1. People may see enough to understand TOWN before joining.
2. Participation requires accountability.
3. Participation is local, not global.
4. An account is not automatically a membership.
5. Local verification is not automatically a membership.
6. Payment alone is not sufficient for participation.
7. Members exercise democratic power within published constitutional limits.
8. The operator protects legality, immediate safety and procedural integrity, but does not rule the community arbitrarily.
9. TOWN collects the minimum data required to operate.
10. Civic activity is not used for advertising or political profiling.

Core access principle:

> See enough to understand. Join to participate. Leave if not ready.

---

# Part I — Access Model

## 3. Visitor access

**Decision reference: D1**

A Visitor is a person who does not have an authenticated TOWN account or is not signed in.

A Visitor may:

- open TOWN;
- select a supported country and city;
- view the local feed sufficiently to understand the product;
- view public civic information permitted by TOWN;
- encounter the membership invitation;
- leave the experience.

A Visitor may not:

- confirm a signal;
- create a signal;
- comment;
- vote;
- participate in community governance;
- act as a verified local member.

Attempting a participation action must open the membership path rather than record the action.

Visitor access is intended for product understanding, not passive unlimited browsing.

---

## 4. Authenticated account requirement

**Decision reference: D2**

Every participation action requires an authenticated account.

An account may be used to:

- authenticate the person;
- manage local verification;
- manage membership;
- maintain account settings;
- receive procedural notices;
- request correction, export or deletion of personal data.

Creating an account does not automatically create:

- local verification;
- paid membership;
- participation rights.

---

## 5. Verified Local status

**Decision reference: D3**

Before participating, an account must have one valid local-community verification.

`Verified Local` means only:

> The account has a currently valid verification for one TOWN community.

It does not automatically mean:

- paid membership;
- full civil-identity verification;
- permanent residence;
- public disclosure of the member’s address;
- good standing;
- unlimited participation rights.

TOWN v1 permits one active local community per account.

Changing community requires a separate controlled process and renewed verification. It must not be achieved merely by changing a dropdown.

The exact verification method is not approved in this document.

---

## 6. Active Member status

**Decision reference: D4**

An account becomes an `Active Member` only when all of the following are true:

```text
authenticated_account = true
local_verification = valid
membership_entitlement = active
account_status = active
```

Only an Active Member may receive participation rights.

An Active Member may participate only in the verified local community attached to the account.

---

# Part II — Paid Membership Lifecycle

## 7. Membership price and renewal

**Decision reference: D5**

TOWN membership is:

```text
€12 per year
```

The approved product model is annual automatic renewal until cancellation.

Before purchase, TOWN must clearly disclose:

- the price;
- the currency;
- the annual duration;
- whether renewal is automatic;
- the next renewal date when known;
- how renewal can be cancelled;
- when access ends after cancellation.

The billing implementation and payment provider are not selected in this document.

---

## 8. Cancellation

**Decision reference: D6**

Cancellation stops the next automatic renewal.

Cancellation does not terminate access already paid for.

After cancellation:

```text
membership_status = cancelled_but_active
```

The member remains active until:

```text
expires_at
```

At expiration, the account transitions to `Expired Member` unless another valid entitlement exists.

---

## 9. Expired membership

**Decision reference: D7**

An Expired Member becomes read-only.

An Expired Member may:

- sign in;
- view the local feed;
- view membership status;
- reactivate membership;
- access account settings;
- request account deletion;
- view the member’s own previous contributions where permitted.

An Expired Member may not:

- confirm signals;
- create signals;
- comment;
- vote;
- participate in democratic governance;
- perform any other participation action reserved for Active Members.

Expiration does not automatically delete the account.

---

## 10. Grace period and payment hold

**Decision reference: D8**

When renewal payment temporarily fails, TOWN may support a grace period.

During a valid grace period:

- access may remain active temporarily;
- the member must be informed of the payment issue;
- the entitlement status must remain distinguishable from fully active payment status.

When the subscription moves to payment hold:

- participation stops;
- the account remains available;
- the member may repair payment or reactivate membership.

Exact grace-period duration is not approved here.

---

## 11. Server-side entitlement

**Decision reference: D9**

Membership entitlement must not be determined solely by the client application.

A trusted server-side system must verify and synchronize at least:

- activation;
- renewal;
- cancellation;
- expiration;
- grace period;
- payment hold;
- refund;
- revocation.

The minimum conceptual entitlement states are:

```text
not_started
active
cancelled_but_active
grace_period
payment_hold
expired
refunded
revoked
```

The final billing architecture remains a separate technical and legal decision.

---

# Part III — Account Lifecycle and Democratic Sanctions

## 12. Separate account states

**Decision reference: D10**

The following are distinct states and must not be collapsed into one flag:

- account status;
- local-verification status;
- membership entitlement;
- moderation status;
- democratic-sanction status.

An account may exist without local verification.

A locally verified account may exist without active membership.

An active payment may not grant participation if:

- local verification is invalid;
- the account is suspended;
- the account is deleted;
- a legal or urgent safety restriction is active.

---

## 13. Democratic sanctions

**Decision reference: D11**

Ordinary community suspensions and bans are decided by eligible members of the relevant community through a democratic process.

The process must include:

- a report;
- admissibility review;
- attributable evidence;
- notice;
- meaningful right to respond;
- a neutral case file;
- quorum;
- secret voting;
- a reasoned outcome;
- appeal.

The operator may not impose arbitrary permanent community sanctions.

The binding details are defined in:

- `DEMOCRATIC_GOVERNANCE_PROTOCOL.md`

---

## 14. Temporary safety restrictions

**Decision reference: D12**

The operator may apply a temporary safety restriction when necessary to address:

- immediate safety risk;
- apparently illegal content;
- fraud;
- account compromise;
- technical attack;
- exposure of personal data;
- another urgent risk defined by approved policy.

Such a measure must be:

- temporary;
- narrow;
- reversible where possible;
- documented;
- reviewed rapidly by a human;
- prevented from becoming a permanent ban through inactivity.

A temporary safety restriction is not a democratic verdict.

---

## 15. Appeal rights

**Decision reference: D13**

Every suspension or ban must be contestable.

The appeal process must:

- be separate from the initial decision;
- exclude material conflicts of interest;
- permit relevant new evidence;
- examine procedural errors;
- examine compromised voting;
- examine incorrect application of rules;
- produce a reasoned result.

The detailed appeal rules are defined in:

- `DEMOCRATIC_GOVERNANCE_PROTOCOL.md`

---

## 16. Voluntary account deletion

**Decision reference: D14**

Every account holder may initiate voluntary account deletion.

Deletion:

- is not subject to member voting;
- cannot be replaced by mere account deactivation;
- must revoke active sessions;
- must disable participation;
- must remove or anonymise eligible personal data;
- may retain only data justified by applicable law, security, fraud prevention, dispute handling or other documented grounds.

Final deletion flows, retention periods and treatment of civic contributions require separate legal and product decisions.

---

# Part IV — Data and Privacy Model

## 17. Data minimisation

**Decision reference: D15**

TOWN collects only data necessary for:

- account operation;
- local verification;
- membership;
- security;
- participation;
- democratic governance;
- moderation;
- legal compliance.

Any additional category of data requires:

- a documented purpose;
- a lawful basis;
- a defined access policy;
- a retention rule;
- separate product approval.

TOWN must apply privacy by design and privacy by default.

---

## 18. No location history

**Decision reference: D16**

When location is used for community verification:

```text
raw_location
→ temporary verification process
→ community verification result
```

TOWN must not create a history of the member’s movements.

After verification, TOWN should retain only the necessary result, such as:

```text
community_id
verification_status
verification_method
verified_at
verification_expires_at
```

Raw coordinates must not be retained as a location history.

The exact verification method remains unapproved.

---

## 19. No advertising or political profiling

**Decision reference: D17**

TOWN must not use member data for:

- behavioural advertising;
- cross-app tracking;
- political profiling;
- commercial profiling based on civic participation;
- sale of civic activity data.

A member’s civic activity must not be transformed into a commercial behavioural profile.

This restriction is a TOWN product commitment.

---

## 20. Payment-data separation

**Decision reference: D18**

TOWN must not store full payment-card data.

Payment instruments must be handled by an authorised payment provider or the relevant payment infrastructure.

TOWN may retain only the minimum references and statuses required for entitlement management, such as:

```text
membership_status
entitlement_source
starts_at
expires_at
renewal_status
tokenised_transaction_reference
last_verified_at
```

---

## 21. Retention and user control

**Decision reference: D19**

Every personal-data category must have:

- a documented purpose;
- a defined retention period;
- a deletion trigger;
- documented exceptions;
- an accountable system or role.

Members must be able to:

- access principal account information;
- correct inaccurate information;
- export their data in a useful form;
- request deletion;
- view local-verification status;
- view membership status;
- understand justified retention exceptions.

Exact retention periods require a separate Retention Schedule and legal review.

---

# Part V — Participation and Moderation Rights

## 22. Participation rights

**Decision reference: D20**

An Active Member may receive rights to:

- confirm signals;
- create signals;
- comment;
- report content;
- report members;
- block members personally;
- participate in democratic procedures;
- vote when eligible;
- respond to accusations;
- appeal sanctions.

These rights exist only:

- within the verified community;
- under published rules;
- while the account and membership remain active;
- subject to approved safety and governance controls.

Signal creation, comments and media functions require separate product specifications before implementation.

---

## 23. Reporting and personal blocking

**Decision reference: D21**

TOWN must provide in-app mechanisms for:

- reporting content;
- reporting a member;
- personally blocking another member.

Personal blocking is a user-protection mechanism.

It:

- does not require a vote;
- does not create a community sanction;
- does not automatically ban the blocked member;
- affects only the relevant user experience within the final feature design.

---

## 24. A report is not a verdict

**Decision reference: D22**

Neither a report nor a large number of reports automatically establishes wrongdoing.

A reported member has the right to:

- receive notice, where safety and law permit;
- understand the applicable rule;
- understand the material allegations;
- respond;
- submit evidence;
- receive a reasoned decision;
- appeal.

Safety, confidentiality and third-party rights may justify limited or delayed disclosure, but such limitations must be individually justified.

---

## 25. Democratic authority and legal limits

**Decision reference: D23**

Eligible members decide ordinary community sanctions.

Members may not vote validly to:

- authorise illegal conduct;
- disclose personal data;
- discriminate;
- eliminate appeal rights;
- punish retroactively;
- ignore a valid legal obligation;
- remove another member’s right to voluntary account deletion;
- impose a sanction absent from published rules.

Democratic power operates within constitutional and legal limits.

The complete constitutional framework is defined in:

- `DEMOCRATIC_GOVERNANCE_PROTOCOL.md`

---

## 26. Operator as guardian, not ruler

**Decision reference: D24**

The operator may intervene directly only for:

- urgent safety;
- security;
- fraud;
- apparently illegal content;
- valid legal obligations;
- protection of procedural integrity.

For definitive ordinary community sanctions, the operator:

- maintains the process;
- protects integrity;
- executes a valid democratic outcome;
- keeps the audit trail;
- does not control the verdict arbitrarily.

The operator must not use safety as an unlimited basis for permanent administrative exclusion.

---

# Part VI — Mandatory Dependencies

## 27. Democratic Governance Protocol

No democratic suspension, ban, jury vote or appeal may be implemented before the approved governance protocol is present as a canonical document.

It must define at least:

- constitutional boundaries;
- admissibility;
- evidence;
- defence;
- voter eligibility;
- conflicts of interest;
- civic jury selection;
- quorum;
- voting thresholds;
- voting secrecy;
- appeal;
- anti-brigading;
- invalidation;
- revoting;
- transparency;
- bootstrap governance;
- minority protection.

Approved governance decisions: `G1–G20`.

---

## 28. Moderation Agent System

No real moderation-agent system may operate before the approved specification is present as a canonical document and all readiness gates are satisfied.

It must define at least:

- agent roles and authority;
- meaningful human control;
- case lifecycle;
- data access;
- typed outputs;
- emergency actions;
- zero-tolerance taxonomy;
- permanent-ban safeguards;
- auditability;
- multilingual testing;
- bias testing;
- adversarial testing;
- fallback;
- incident response;
- kill switch;
- pilot readiness.

Approved moderation-system decisions: `M1–M20`.

---

# Part VII — Explicitly Unresolved Matters

This document does not approve:

- the authentication provider;
- email versus phone authentication;
- legal name versus pseudonym;
- age requirements;
- minors’ access;
- exact local-verification method;
- exact billing architecture;
- direct website payment implementation;
- alternative billing arrangements;
- grace-period duration;
- refund rules;
- taxation and invoicing;
- trial periods;
- discounts;
- analytics providers;
- crash-reporting providers;
- cloud region;
- international transfers;
- subprocessors;
- exact retention periods;
- public profile fields;
- treatment of public contributions after deletion;
- final Terms of Use wording;
- final Privacy Policy;
- final sanction taxonomy outside approved zero-tolerance principles;
- legal qualification under the DSA or AI Act;
- pilot date;
- real-operation approval.

These matters require separate research, specification and owner approval.

---

# Part VIII — Implementation Prohibition

This document does not authorise implementation by itself.

Before any real membership system is implemented, TOWN must have:

1. the three approved canonical product documents;
2. legal and direct-distribution review;
3. approved authentication and billing architecture;
4. privacy and retention specifications;
5. security architecture;
6. backend data model;
7. testing strategy;
8. explicit owner approval for implementation.

No agent, developer or tool may infer permission to build unresolved functionality from this document.

---

# Part IX — Traceability

| Decision | Subject |
|---|---|
| D1 | Visitor may understand but not participate |
| D2 | Participation requires authenticated account |
| D3 | One valid local-community verification |
| D4 | Account + verification + entitlement required |
| D5 | €12/year auto-renewing membership |
| D6 | Cancellation preserves paid access until expiry |
| D7 | Expired member becomes read-only |
| D8 | Grace period and payment hold |
| D9 | Server-side entitlement |
| D10 | Account, verification and entitlement are separate |
| D11 | Ordinary sanctions are democratically decided |
| D12 | Temporary urgent safety restrictions |
| D13 | Independent appeal |
| D14 | Voluntary account deletion |
| D15 | Data minimisation by default |
| D16 | No location history |
| D17 | No advertising or political profiling |
| D18 | Payment-data separation |
| D19 | Transparent retention and user control |
| D20 | Participation rights of Active Members |
| D21 | Reporting and personal blocking |
| D22 | Report is not verdict |
| D23 | Democratic authority within legal limits |
| D24 | Operator is guardian, not ruler |

---

## Owner approval status

Approved as the canonical consolidation of decisions D1–D24.
