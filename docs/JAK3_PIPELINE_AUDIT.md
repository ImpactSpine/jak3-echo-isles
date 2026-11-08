# Jak 3 OpenGOAL integration audit

**Status:** research checkpoint; no Jak 3 build has been produced yet.

## Why this audit exists

Echo Isles currently contains a greybox GLB, a JSONC level description, a DGO descriptor, and notes based on the OpenGOAL custom-level workflow. The next step is not to copy the Jak 1 example blindly: the target game is Jak 3, and level registration and build-system paths are game-specific.

## Findings confirmed on 2026-11-08

### 1. The public custom-level guide is not a Jak 3 recipe

The official OpenGOAL guide's worked example edits `goal_src/jak1/game.gp` and `goal_src/jak1/engine/level/level-info.gc`. Its instructions explicitly tell users to substitute the game when extracting an ISO, but the concrete level-registration walkthrough is Jak 1-specific. It cannot be treated as proof that the same snippets or indices work in Jak 3.

Source: https://opengoal.dev/docs/developing/custom_levels/your_first_level/

### 2. The public multi-target mod-base repository inspected here does not contain a Jak 3 source tree

Repository inspected: https://github.com/OpenGOAL-Unofficial-Mods/opengoal-multitarget-mod-base

Its recursive tree contains `data/goal_src/jak1/...` and `data/goal_src/jak2/...`, including `game.gp` and `engine/level/level-info.gc` for those games. It does not contain `data/goal_src/jak3/...` or `custom_assets/jak3/...`.

The base README describes a launcher-compatible template. Its custom-level README documents the `test-zone` workflow and a `(bg-custom 'test-zone-vis)` debug load, but does not establish Jak 3 compatibility.

### 3. Custom-level tooling is explicitly early-stage

The official introduction warns that custom-level tooling is in very early stages and lists missing navigation meshes as a limitation for moving enemies/NPCs without substantial hard-coding.

Source: https://opengoal.dev/docs/developing/custom_levels/intro/

## Consequence for Echo Isles

Do **not** add speculative Jak 1 snippets to the Jak 3 project and call the result installable. The current `.gd` and `.jsonc` files remain prototype inputs, not a validated Jak 3 build configuration.

The next engineering dependency is a real Jak 3 mod base or a Jak 3-specific mod project whose source tree exposes:
- the Jak 3 build target and DGO registration conventions;
- the Jak 3 level-info / continue-point registration path;
- the custom-level build tool invocation and output paths;
- a known-good Jak 3 custom-level or equivalent test fixture.

## Next implementation sequence

1. Locate and pin a maintained Jak 3-compatible mod base (or obtain the exact Jak 3 source tree used by the user's working OpenGOAL installation).
2. Compare its Jak 3 level/DGO registration with the existing Echo Isles descriptor.
3. Adapt the level definition and spawn/continue-point only after confirming the actual Jak 3 structures and unique IDs.
4. Run the project's validator and OpenGOAL compiler against the Jak 3 base.
5. Load the level in debug mode and verify spawn, visible geometry, walkable collision, walls, and falling/recovery.
6. Only after those checks, mark the first prototype as playable.

## Acceptance criteria for the first playable milestone

- Jak 3 starts from the mod base without regressions.
- Echo Isles DGO is built and loaded by Jak 3 (not merely parsed as text).
- Jak spawns at the intended marker.
- Ground, steps, pillars, walls, and gateway have correct collision from both sides.
- No crash or softlock when traversing the greybox.
- Build steps are repeatable from a clean checkout.

Until these criteria pass, the project status remains **prototype / not yet playable**.
