# OWNER FULL-JOURNEY TEST ROUTE

Public owner-testing route for Mihail to walk the full current TOWN journey
from Welcome through location verification into Experience Prototype V1.

## Exact public URL

https://michaeltofan.github.io/town-safe-space-mobile/owner-journey-v1/

## Start-to-current behavior

Welcome
→ Country
→ City (official city language switch)
→ Location verification (visible screens)
→ Successful visible location result
→ Continue to TOWN
→ Experience Prototype V1 (`/experience-v1/`)
→ 3 full-screen civic scenes

## Explicit status

- Public and non-secure — anyone with the URL can open it
- Visual testing only
- No authentication
- No authorization
- No entitlement
- No account, token, or backend privilege
- Normal production root unchanged
- Production Owner Preview unchanged
- Experience Prototype V1 unchanged
- PR #30 and PR #31 remain separate and unmerged
- Owner approval required before any product merge
- Remove or replace before production access control

## Isolation

EXPERIENCE / OWNER TEST PROTOTYPE ONLY.
NOT THE FLUTTER PRODUCT IMPLEMENTATION.
NOT APPROVED PRODUCT UI.
DO NOT MERGE INTO PRODUCT LOGIC.
OWNER VISUAL APPROVAL REQUIRED.

This shell lives under `prototype/owner-journey-v1/` and does not modify
`lib/`, `test/`, or normal production routing.
