# MVP SCOPE — TOWN

## Purpose

This document defines the controlled scope for the first TOWN prototype.

The purpose of the first prototype is not to build the full app.

The purpose is to prove the visual, emotional, and UX direction of the product before implementing real accounts, payments, GPS, backend, moderation, or publishing.

## Current build stage

The current project stage is:

Flutter visual prototype.

This means:
- static screens are allowed;
- mock data is allowed;
- local placeholder interactions are allowed;
- visual references are allowed;
- no real user data is allowed;
- no production functionality is allowed.

## Product direction

TOWN is a hyper-local civic app.

The prototype must communicate:
- real communities;
- real stories;
- no noise;
- local trust;
- civic calm;
- editorial depth;
- no hate-engagement;
- no global feed;
- no ghost-account culture.

The prototype should feel premium, calm, civic, local, and editorial.

It must not feel like a generic social media clone.

## Prototype goal

The first prototype must answer these questions:

1. Does the app feel premium and trustworthy?
2. Can the user understand the product in a few seconds?
3. Does the local-only concept feel clear?
4. Does the app avoid the feeling of toxic social media?
5. Does the Substack Card feed concept feel strong enough to build further?
6. Does the tap-to-expand reading experience feel natural?
7. Does the app feel suitable for a European local civic space?

## Included in the first prototype

The first prototype may include these mock screens:

1. Welcome / Manifest Screen
   - introduces TOWN;
   - communicates real communities, real stories, no noise;
   - establishes premium civic calm.

2. Local Space Selection Screen
   - mock country/city/neighbourhood selection;
   - pilot context: Italy / Milano / Brera;
   - no real GPS.

3. Civic Guarantee Screen
   - explains why the future app may use paid membership;
   - frames membership as anti-bot and anti-hate-engagement;
   - no real payment.

4. Local Access Confirmed Screen
   - mock confirmation that the user is entering the local civic space;
   - no real account verification.

5. Substack Card Feed Screen
   - vertical full-screen card layout;
   - mock local civic/editorial cards;
   - no real backend feed.

6. Expanded Reading Screen
   - tap-to-expand long-form reading concept;
   - clean editorial reading experience;
   - mock content only.

7. Constructive Response Screen
   - mock structured civic response;
   - examples: Question, Proposal, Perspective;
   - no real comments.

8. Settings / Safety Placeholder Screen
   - mock Privacy Policy link;
   - mock Terms link;
   - mock Delete Account button;
   - mock Report / Block explanation;
   - no real legal or backend function.

## Excluded from the first prototype

Do not build:

- real authentication;
- real accounts;
- real email/password forms;
- real payments;
- RevenueCat;
- Apple Pay;
- Google Play Billing;
- real GPS permission;
- real location tracking;
- Supabase;
- Firebase;
- backend APIs;
- database;
- real user-generated content submission;
- real comments;
- real moderation dashboard;
- creator studio;
- notifications;
- analytics;
- admin panel;
- app store submission logic.

## Data rule

The prototype must not collect, store, transmit, or process real personal data.

All names, places, stories, authors, and feed items must be mock data.

If a screen requires a user state, use fake local state only.

## Visual rule

The prototype should use a calm premium visual language:

- warm ivory / off-white backgrounds;
- dark charcoal or deep brown text;
- elegant typography;
- generous spacing;
- soft European local imagery;
- rounded premium buttons;
- minimal interface noise;
- no aggressive social media patterns.

## Pilot context

Use this pilot context for prototype copy and examples:

- Country: Italy
- City: Milano
- Neighbourhood: Brera

Do not switch to Munich unless explicitly requested.

## Cursor scope rule

Cursor must not build multiple screens in one task unless explicitly approved.

Each screen must have its own screen specification before implementation.

The correct sequence is:

1. product context;
2. cursor rules;
3. legal constraints;
4. MVP scope;
5. screen specifications;
6. reference assets;
7. one screen implementation at a time.

## Acceptance criteria for this document

This task is complete only if:

- docs/MVP_SCOPE.md is created;
- no other files are modified;
- no code is written;
- no UI is built;
- no package or config file is changed.
