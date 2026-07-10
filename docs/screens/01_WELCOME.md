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

## Implementation guidance for future Flutter task

When this screen is later implemented in Flutter:

- use standard Flutter widgets;
- avoid external packages;
- avoid backend or navigation;
- use mock/static content only;
- create a dedicated screen file if approved later:
  lib/screens/welcome_screen.dart

Do not implement this screen in this task.

This task is only the screen specification document.

## Asset guidance

If a real street illustration asset is added later, it should be stored as:

reference/screen_01_welcome.png

or later as an app asset only after explicit approval.

Do not add image assets in this task.

## Interaction behavior

For the first prototype:

- Welcome button may later move to the next mock screen.
- Learn more may later show a short explanation or secondary screen.
- No interaction is implemented in this task.

## Acceptance criteria

This task is complete only if:

- docs/screens/01_WELCOME.md is created;
- no other files are modified;
- no Flutter code is written;
- no UI is built;
- no assets are added;
- no package or config file is changed.

## Stop condition

Stop after creating docs/screens/01_WELCOME.md and show the file created.
