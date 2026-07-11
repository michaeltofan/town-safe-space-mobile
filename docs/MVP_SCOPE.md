# MVP SCOPE — TOWN

## Purpose

This document defines the controlled scope for TOWN prototype work.

The purpose of early prototype work is not to build the full app.

The purpose is to prove the visual, emotional, and UX direction of the product before implementing accounts, payments, backend, moderation, or publishing.

## Current build stage

### LOCAL ACCESS FOUNDATION V1 — IMPLEMENTED

Completed flow:

```text
Welcome
→ Country
→ City
→ Official city language
→ One-time location verification
→ Visible verification result
```

This phase is implemented and closed for owner review.

It includes real one-time foreground location verification and local offline city-boundary classification for Milano and Munich.

It does **not** include:
- accounts;
- membership or payment;
- persisted city membership / access entitlement;
- civic cards, articles, or feed;
- neighbourhood selection;
- post-verification product navigation;
- backend;
- Creator Studio;
- moderation;
- legal certification.

## Product direction

TOWN is local civic infrastructure for real people, useful information, and community.

TOWN is not social media.

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

Later prototype work must answer these questions:

1. Does the app feel premium and trustworthy?
2. Can the user understand the product in a few seconds?
3. Does the local-only concept feel clear?
4. Does the app avoid the feeling of toxic social media?
5. Does the local civic-card feed concept feel strong enough to build further?
6. Does the tap-to-expand reading experience feel natural?
7. Does the app feel suitable for a European local civic space?

## Included in LOCAL ACCESS FOUNDATION V1

1. Welcome / Manifest Screen
   - introduces TOWN;
   - communicates real communities, real stories, no noise;
   - Learn more opens an in-place bottom sheet on the same screen.

2. Country selection
   - Italy and Germany.

3. City selection
   - Milano and Munich;
   - official city language applied after city selection.

4. One-time location verification
   - foreground permission;
   - one foreground GPS read;
   - local offline boundary classification;
   - visible result states;
   - raw coordinates are not retained, transmitted, logged, or displayed.

## Planned later prototype screens (not started)

These remain future owner-approved work and are **not** part of LOCAL ACCESS FOUNDATION V1:

1. Civic Guarantee Screen
   - explains why the future app may use paid membership;
   - frames membership as anti-bot and anti-hate-engagement;
   - no real payment.

2. Local Access Confirmed / post-verification product entry
   - not implemented; verification currently ends on the verification result screen.

3. Local Civic Card Feed Screen
   - vertical full-screen card layout;
   - mock local civic/editorial cards;
   - no real backend feed.

4. Expanded Reading Screen
   - tap-to-expand long-form reading concept;
   - clean editorial reading experience;
   - mock content only.

5. Constructive Response Screen
   - mock structured civic response;
   - examples: Question, Proposal, Perspective;
   - no real comments.

6. Settings / Safety Placeholder Screen
   - mock Privacy Policy link;
   - mock Terms link;
   - mock Delete Account button;
   - mock Report / Block explanation;
   - no real legal or backend function.

## Excluded until explicitly approved

Do not build:

- real authentication;
- real accounts;
- real email/password forms;
- real payments;
- RevenueCat;
- Apple Pay;
- Google Play Billing;
- continuous location tracking or background location;
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
- app store submission logic;
- neighbourhood selection;
- civic card / feed / article screens.

Note: one-time foreground location verification for LOCAL ACCESS FOUNDATION V1 is already implemented and is not a future exclusion.

## Data rule

Do not collect, store, transmit, or process personal data beyond what an approved feature requires.

For the implemented location verification:
- coordinates exist only transiently during local classification;
- raw coordinates are not retained, transmitted, logged, or displayed;
- only safe derived UI fields are shown (for example city result / accuracy class).

All future feed names, places, stories, authors, and cards must use mock data until a later approved phase.

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

Current pilot cities for the implemented local-access phase:

- Country: Italy — City: Milano
- Country: Germany — City: Munich

Neighbourhood selection (for example Brera / Maxvorstadt) is not implemented.

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
