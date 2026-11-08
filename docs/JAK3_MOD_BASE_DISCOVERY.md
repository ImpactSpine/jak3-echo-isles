# Jak 3 mod-base discovery

**Date:** 2026-11-08  
**Status:** candidate integration base identified; Echo Isles is not yet integrated or tested against it.

## Candidate repository

- Repository: https://github.com/whozghiar/jak3-mod-battle-of-spargus
- Its README identifies it as a Jak 3 OpenGOAL mod and documents a developer workflow with `task set-game-jak3`, `task extract`, and `task boot-game`.
- The repository contains a complete Jak 3 source tree, including `goal_src/jak3/game.gp`, a Jak 3 custom-level fixture under `custom_assets/jak3/levels/test-zone/`, and the corresponding Jak 3 decompiler configuration.
- It is therefore a much better technical reference than the older multi-target mod-base repository, which only had Jak 1 and Jak 2 game source trees.

## Confirmed Jak 3 custom-level fixture

The repository's `custom_assets/jak3/levels/test-zone/test-zone.jsonc` declares:
- `long_name`: `test-zone`
- `iso_name`: `TESTZONE`
- `nickname`: `tsz`
- GLB path: `custom_assets/jak3/levels/test-zone/test-zone2.glb`
- automatic wall detection enabled at 45 degrees
- double-sided collision disabled
- actor base ID 100 and region base ID 0
- custom model `test-actor`

Its DGO descriptor `testzone.gd` builds `TSZ.DGO` from the test art group, `test-zone-obs.o`, `test-actor-ag.go`, and `test-zone.go`.

These values are a working-format reference, not values to copy blindly. Echo Isles needs unique identifiers and must include only assets it actually uses.

## Important caveat

The repository's own Battle of Spargus documentation says its scenarios are implemented but their in-game behavior is not verified, and the README says the mod has no release yet. We can rely on its Jak 3 project layout and custom-level fixture as a structural reference, but we must independently build and test Echo Isles.

## Immediate next steps

1. Compare Echo Isles JSONC and DGO descriptor with the Jak 3 fixture.
2. Inspect the Jak 3 `game.gp` registration points and the corresponding Jak 3 level-info continue-point structures.
3. Confirm the mod's current build scripts and whether the custom-level fixture is actually compiled in the checked-out branch.
4. Port Echo Isles incrementally, using distinct names/IDs.
5. Validate compilation and runtime behavior before changing project status.
