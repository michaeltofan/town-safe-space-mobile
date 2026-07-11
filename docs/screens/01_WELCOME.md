# SCREEN SPEC — 01 WELCOME

## Screen name

Welcome Screen / Manifest Screen

## Purpose

This is the first screen the user sees.

Its job is to explain the purpose of TOWN in less than three seconds.

The screen must immediately communicate:

- real communities;
- real stories;
- no noise;
- premium local civic calm;
- not social media;
- not a global feed;
- not hate-engagement.

## Product role

This screen introduces TOWN as a calm, premium, hyper-local civic app.

It should make the user feel that they are entering a trusted local space, not another noisy social platform.

## Required copy

App title:

TOWN

Main message:

Real communities.
Real stories.
No noise.

Primary button:

Welcome

Secondary button:

Learn more

Optional small footer text:

A local civic space for thoughtful neighbourhood stories.

## Visual reference

Use the approved visual direction from the Welcome reference image:

- warm ivory / off-white background;
- large centered serif-style title;
- calm centered text;
- soft European street illustration area in the lower-middle section;
- dark rounded primary button;
- pale rounded secondary button;
- premium editorial spacing;
- minimal interface noise.

The reference image is a visual guide, not a pixel-perfect requirement.

Cursor must not claim it can perfectly recreate the image.

## Layout direction

The screen should be mobile-first and vertically centered.

Suggested structure:

1. Top safe area spacing.
2. Large centered title: TOWN.
3. Centered three-line message:
   - Real communities.
   - Real stories.
   - No noise.
4. Soft illustration area below the text.
5. Primary button: Welcome.
6. Secondary button: Learn more.
7. Optional footer note.

## Visual tone

The screen must feel:

- premium;
- calm;
- civic;
- European;
- editorial;
- warm;
- trustworthy;
- minimal.

The screen must not feel:

- childish;
- generic startup;
- aggressive;
- gamified;
- TikTok-like;
- cluttered;
- corporate dashboard-like.

## Implementation status

This screen is implemented in:

`lib/screens/welcome_screen.dart`

It is part of **LOCAL ACCESS FOUNDATION V1 — IMPLEMENTED**.

## Asset guidance

Approved street illustration asset:

- `reference/screen_01_welcome.png`
- `assets/images/welcome_screen.png`

## Interaction behavior

- Welcome opens Select Country and continues the local-access flow.
- Learn more opens a simple bottom sheet on the same Welcome Screen.
- Learn more must not open a new screen, external link, account flow, membership flow, feed, or backend action.
- The user remains on the Welcome Screen while the sheet is open.

### Approved Learn more bottom sheet copy

Title:

What is TOWN?

Body:

TOWN is local civic infrastructure for real people, useful information, and community.

It helps people access and share relevant information about the city they live in.

TOWN is not social media. It has no global feed, no follower race, and no advertising-driven engagement.

Button:

Close

Close dismisses the sheet. Normal platform dismissal may also dismiss it.
No additional actions or links.
