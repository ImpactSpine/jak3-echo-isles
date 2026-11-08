# Jak 3 OpenGOAL integration audit

**Status:** candidate Jak 3 development base found; Echo Isles is not yet ported, compiled, or runtime-tested.

## Confirmed findings (2026-11-08)

### Official documentation

The official OpenGOAL custom-level guide's concrete walkthrough edits Jak 1 paths such as `goal_src/jak1/game.gp` and `goal_src/jak1/engine/level/level-info.gc`. It is useful for concepts, but its snippets must not be copied into Jak 3 without checking the Jak 3 source.

Source: https://opengoal.dev/docs/developing/custom_levels/your_first_level/

The official introduction warns that custom-level tooling is early-stage. In particular, moving enemies/NPCs require navigation meshes, which are not generally available in the documented custom-level workflow without substantial hard-coding.

Source: https://opengoal.dev/docs/developing/custom_levels/intro/

### Older multi-target mod base is not our Jak 3 reference

The inspected repository https://github.com/OpenGOAL-Unofficial-Mods/opengoal-multitarget-mod-base contains Jak 1 and Jak 2 source trees, but no Jak 3 source tree. It is not a suitable source of Jak 3 level registration.

### Jak 3 candidate base found

Repository: https://github.com/whozghiar/jak3-mod-battle-of-spargus

Its source tree includes:
- `goal_src/jak3/game.gp`;
- `custom_assets/jak3/levels/test-zone/test-zone.jsonc`;
- `custom_assets/jak3/levels/test-zone/testzone.gd`;
- Jak 3 decompiler configuration;
- a documented Jak 3 development workflow (`task set-game-jak3`, `task extract`, `task boot-game`).

The Jak 3 `game.gp` contains a concrete custom-level build example:
```lisp
(build-custom-level "test-zone")
(goal-src "levels/test-zone/test-zone-obs.gc" "process-focusable")
(custom-level-cgo "TSZ.DGO" "test-zone/testzone.gd")
```
The test fixture JSONC uses a unique actor base ID and names its GLB under `custom_assets/jak3/levels/test-zone/`. Its DGO descriptor references the generated level object and supporting art group.

Important caveat: the candidate repository's own README says its mod has no release yet, and its Battle of Spargus documentation says in-game behavior is not verified. Its project layout and custom-level fixture are useful structural references, but do not prove that Echo Isles will build or run.

## Current Echo Isles status

The existing Echo Isles `.gd` and `.jsonc` files are still prototype inputs. No Jak 3 registration has yet been added to this repository. No successful compile or in-game test is claimed.

## Next engineering sequence

1. Compare Echo Isles JSONC/DGO files against the Jak 3 test-zone fixture.
2. Inspect the exact Jak 3 `game.gp` and level-info continue-point registration before choosing names and IDs.
3. Port Echo Isles using unique names/IDs and only the assets it actually needs.
4. Run validation and the OpenGOAL compiler against the Jak 3 base.
5. Load in debug mode and verify spawn, geometry, walkable collision, walls, and falling/recovery.
6. Mark the prototype playable only after repeatable build and runtime checks pass.

## First playable acceptance criteria

- Jak 3 starts from the development base without regressions.
- Echo Isles DGO builds and is loaded by Jak 3.
- Jak spawns at the intended marker.
- Ground, steps, pillars, walls, and gateway have correct collision.
- Traversal does not crash or softlock.
- Build steps are repeatable from a clean checkout.

Until all criteria pass, the project status remains **prototype / not yet playable**.
