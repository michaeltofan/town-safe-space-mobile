# PRODUCT CONTEXT — TOWN

## Product identity

TOWN is local civic infrastructure for real people, useful information, and community.

It is not social media.
It is not a global social network.
It is not a generic town bulletin board.
It is not a TikTok clone.
It is not a Substack clone.

Substack is only a benchmark for elegance and clarity, never branding or replication.
TikTok is only a benchmark for fluid navigation, never addiction mechanics.

TOWN combines:
- the vertical discovery mechanics of TikTok as a navigation benchmark only;
- the editorial depth and calm reading experience of Substack as a clarity benchmark only;
- strict local-only civic focus;
- anti-bot, anti-ghost-account, anti-hate-engagement principles.

Do not add:
- follower mechanics;
- vanity metrics;
- trends;
- engagement bait;
- third-party branding;
- Substack symbols;
- social-media-style interaction.

## Core product idea

The app helps local residents rediscover civic life in their own town or neighbourhood.

The app exists because people are overwhelmed by global breaking news, hate engagement, anonymous accounts, and algorithmic noise.

TOWN redirects attention toward local stories, local decisions, local creators, local businesses, local events, and constructive civic discussion.

## Product principle

Global fatigue should not destroy local civic energy.

Users should feel:
- calm;
- local;
- safe;
- respected;
- informed;
- not manipulated by rage-based engagement.

## Main UX concept

The future core experience is a vertical swipe feed of local civic cards.

Each feed item is a full-screen civic card.

A civic card contains:
- a strong local visual;
- a civic/editorial headline;
- a short summary;
- a verified local author or source;
- a tap-to-expand interaction into a clean long-form reading view.

The feed should feel fluid to navigate, but the content should feel thoughtful and local.

## Local-only model

The app is designed for European coverage, but strictly local usage.

A user in one town should see only that town or neighbourhood.

There is no global feed.
There is no trending page.
There is no cross-city outrage engine.

Current pilot cities:
- Milano (Italy)
- Munich (Germany)

Neighbourhood selection is not part of the current implemented phase.

## Anti-hate-engagement rules

The app must avoid:
- anonymous ghost accounts;
- follower-count culture;
- public like counters;
- rage bait;
- global trending;
- toxic comment mechanics;
- engagement loops designed around conflict.

Future versions may use:
- paid yearly membership;
- constructive comment formats;
- report/block/moderation systems;
- account deletion and privacy controls.

## LOCAL ACCESS FOUNDATION V1 — IMPLEMENTED

Status: **IMPLEMENTED**

This phase provides the local-access foundation only.

Completed flow:

```text
Welcome
→ Country
→ City
→ Official city language
→ One-time location verification
→ Visible verification result
```

What this phase includes:

- Welcome / Manifest screen;
- Learn more bottom sheet on the Welcome screen (same screen, no navigation away);
- country selection (Italy, Germany);
- city selection (Milano, Munich);
- official city-language behaviour after city selection;
- one-time foreground location permission and GPS read;
- local offline city-boundary classification;
- visible verification result states;
- privacy rule: raw coordinates are not retained, transmitted, logged, or displayed.

What this phase does **not** include:

- complete onboarding;
- accounts, login, profile, or account deletion;
- membership or payment;
- persisted city membership or access entitlement;
- local civic feed / civic cards / articles;
- neighbourhood selection;
- post-verification navigation into a product screen;
- backend, Creator Studio, or moderation;
- legal compliance certification;
- full production readiness.

## Current build stage

The project has completed **LOCAL ACCESS FOUNDATION V1**.

Later product work (civic cards, feed, accounts, membership, payment, backend, moderation) requires separate owner-approved tasks.

Do not build until explicitly approved:
- backend;
- authentication;
- payments;
- RevenueCat;
- Supabase;
- Firebase;
- moderation backend;
- creator studio;
- real user accounts;
- civic card / feed screens.

## First prototype goal

Later prototype work must still prove the visual and emotional direction of the local civic product.

Screens should communicate:
- premium civic calm;
- real communities;
- real stories;
- no noise;
- local trust;
- editorial depth;
- no social-media toxicity.

## Implementation rule

Cursor is not the product decision-maker.

Cursor executes small, controlled tasks only.

Each task must:
- touch only approved files;
- avoid scope expansion;
- stop after completion;
- report changed files;
- report assumptions.
