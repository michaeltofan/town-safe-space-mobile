# LEGAL CONSTRAINTS — TOWN

## Purpose

This document defines legal and platform constraints that must shape the TOWN app from the beginning.

This is not final legal advice.
This is a product and technical constraint document for building the prototype and future MVP safely.

This document does **not** certify legal compliance.

## Current stage

**LOCAL ACCESS FOUNDATION V1 — IMPLEMENTED**

The implemented local-access phase includes:
- Welcome / country / city / official city language;
- one-time foreground location permission and GPS read;
- local offline city-boundary classification for Milano and Munich;
- visible verification results;
- privacy rule that raw coordinates are not retained, transmitted, logged, or displayed.

The implemented phase does **not** include:
- real accounts;
- real payments;
- backend storage;
- user-generated content submission;
- public comments;
- moderation backend;
- persisted city membership or access entitlement;
- neighbourhood access;
- legal compliance certification.

## Core legal-by-design principle

Do not collect, store, or process personal data unless it is necessary for the approved feature.

Future MVP design must follow:
- data minimisation;
- purpose limitation;
- clear user consent where needed;
- user control over account and data;
- safety controls for user-generated content.

## GDPR / EU privacy constraints

For current and future implementation:

1. Location must be minimal.
   - LOCAL ACCESS FOUNDATION V1 uses GPS only for one-time local eligibility classification.
   - Raw GPS coordinates must not be retained, transmitted, logged, or displayed.
   - Prefer storing only a derived result later, such as verified_local_area_id or is_verified_local, if a future approved task adds persistence.
   - Continuous tracking and background location are not approved.

2. Personal data must be limited.
   - Do not collect unnecessary profile fields.
   - Do not collect advertising identifiers.
   - Do not create tracking profiles.
   - Do not sell user data.

3. Account deletion must exist.
   - If the app allows account creation, users must be able to request or initiate account deletion.
   - The deletion flow must be clear, accessible, and not hidden.
   - Accounts are not implemented in LOCAL ACCESS FOUNDATION V1.

4. Privacy information must be available before payment.
   - Privacy Policy and Terms links must be visible before subscription purchase.
   - Users must understand what data is collected and why.
   - Payment is not implemented in LOCAL ACCESS FOUNDATION V1.

## App Store / Google Play user-generated-content constraints

Future versions with posts, comments, cards, reports, or creator content must include safety controls.

The app must plan for:
- content reporting;
- user reporting;
- blocking abusive users;
- moderation review;
- timely response to reports;
- clear community rules;
- public contact information for safety concerns.

Do not build a real social feed with user-generated content before these controls are designed.

## Subscription / payment constraints

Future paid membership must be transparent.

For future implementation:
- price must be clear;
- billing period must be clear;
- auto-renewal must be clear if used;
- cancellation terms must be clear;
- purchase must use the approved platform payment flow where required;
- no dark patterns;
- no misleading free trial language;
- Privacy Policy and Terms must be visible before purchase.

Do not integrate RevenueCat, Apple payments, Google payments, or real purchase logic until explicitly approved.

## Local verification constraints

LOCAL ACCESS FOUNDATION V1 implements:
- selected city;
- one-time foreground location check;
- local offline classification against city boundaries;
- visible verification result.

It does **not** yet implement:
- payment membership status;
- persisted local access entitlement;
- neighbourhood verification.

The app must not:
- continuously track users without a specific approved purpose;
- store precise movement history;
- expose precise user location to other users;
- allow outsiders into local discussion spaces if local verification is required.

## Moderation constraints

Future moderation must be human-reviewable and transparent.

The app should avoid:
- automatic deletion based only on mass reports;
- anonymous abuse;
- unclear penalties;
- hidden moderation logic.

Future moderation may include:
- warning;
- temporary read-only suspension;
- permanent account removal;
- appeal flow;
- admin review queue.

## Prototype boundary

Allowed now in LOCAL ACCESS FOUNDATION V1:
- Welcome Learn more bottom sheet with approved static copy;
- country / city selection;
- one-time foreground location verification;
- local classification result UI.

Allowed later as mock UI only until separately approved:
- mock Privacy Policy link;
- mock Terms link;
- mock Report button;
- mock Block button;
- mock Delete Account button;
- mock subscription explanation.

Not allowed until explicitly approved:
- real payment;
- real account deletion;
- real personal data retention beyond transient location classification;
- continuous or background location access;
- real backend moderation;
- civic feed with user-generated content.

## Cursor rule

Cursor must not implement legal-sensitive functionality unless a future task explicitly allows it.

Legal-sensitive functionality includes:
- payments;
- subscriptions;
- continuous or background location;
- expanding location persistence beyond the approved one-time local classification;
- user accounts;
- real names;
- personal data storage;
- comments;
- publishing;
- reports;
- blocking;
- moderation actions;
- account deletion;
- backend integrations.

One-time foreground location verification for LOCAL ACCESS FOUNDATION V1 is already approved and implemented.

## Sources checked by product controller

This document is based on the product file and current baseline research into:
- Apple App Store Review Guidelines for user-generated content and in-app purchase;
- Apple account deletion requirement;
- Google Play user-generated content moderation requirements;
- Google Play Data Safety and account deletion requirements;
- EDPB / GDPR data minimisation principle.
