# LEGAL CONSTRAINTS — TOWN

## Purpose

This document defines legal and platform constraints that must shape the TOWN app from the beginning.

This is not final legal advice.
This is a product and technical constraint document for building the prototype and future MVP safely.

## Current stage

The current project is a Flutter visual prototype only.

At this stage, the prototype must not implement:
- real accounts;
- real payments;
- real GPS;
- backend storage;
- user-generated content submission;
- public comments;
- moderation backend;
- personal data collection.

Mock screens are allowed.
Real data flows are not allowed until explicitly approved.

## Core legal-by-design principle

Do not collect, store, or process personal data unless it is necessary for the approved feature.

Future MVP design must follow:
- data minimisation;
- purpose limitation;
- clear user consent where needed;
- user control over account and data;
- safety controls for user-generated content.

## GDPR / EU privacy constraints

For future real implementation:

1. Location must be minimal.
   - If GPS is used, it should verify local eligibility.
   - Raw GPS coordinates should not be stored unless legally reviewed and explicitly approved.
   - Prefer storing only a derived result, such as verified_local_area_id or is_verified_local.

2. Personal data must be limited.
   - Do not collect unnecessary profile fields.
   - Do not collect advertising identifiers.
   - Do not create tracking profiles.
   - Do not sell user data.

3. Account deletion must exist.
   - If the app allows account creation, users must be able to request or initiate account deletion.
   - The deletion flow must be clear, accessible, and not hidden.

4. Privacy information must be available before payment.
   - Privacy Policy and Terms links must be visible before subscription purchase.
   - Users must understand what data is collected and why.

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

The current visual prototype must not integrate RevenueCat, Apple payments, Google payments, or real purchase logic.

## Local verification constraints

Future local verification must be designed carefully.

The app may use:
- selected town/neighbourhood;
- one-time location check;
- payment membership status;
- local access status.

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

The prototype may show legal and safety concepts as mock UI only.

Allowed in prototype:
- mock Privacy Policy link;
- mock Terms link;
- mock Report button;
- mock Block button;
- mock Delete Account button;
- mock subscription explanation;
- mock local verification explanation.

Not allowed in prototype:
- real payment;
- real account deletion;
- real personal data collection;
- real location access;
- real backend moderation.

## Cursor rule

Cursor must not implement legal-sensitive functionality unless a future task explicitly allows it.

Legal-sensitive functionality includes:
- payments;
- subscriptions;
- location permission;
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

## Sources checked by product controller

This document is based on the product file and current baseline research into:
- Apple App Store Review Guidelines for user-generated content and in-app purchase;
- Apple account deletion requirement;
- Google Play user-generated content moderation requirements;
- Google Play Data Safety and account deletion requirements;
- EDPB / GDPR data minimisation principle.
