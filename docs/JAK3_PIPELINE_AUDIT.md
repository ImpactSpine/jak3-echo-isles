# Jak 3 OpenGOAL integration audit

**Research date:** 2026-11-08  
**Status:** Echo Isles source package passes repository validation. Local source-tree preparation and game.gp registration are scripted. No custom-level build or in-game test has passed.

## Confirmed Jak 3 build pipeline

Reference source: https://github.com/whozghiar/jak3-mod-battle-of-spargus

The Jak 3 project file loads `goal_src/jak3/lib/project-lib.gp`. Its relevant definitions have now been inspected directly:

- `build-custom-level` is a macro that registers a build step using tool `build-level3`.
- Its input is `custom_assets/jak3/levels/<name>/<name>.jsonc`.
- Its declared output is `$OUT/obj/<name>.go`.
- `custom-level-cgo` registers a DGO build step using tool `dgo`, with the descriptor under `custom_assets/jak3/levels/` and output under `$OUT/iso/`.
- The DGO descriptor is therefore not itself the geometry generator. It packages the generated objects and any referenced art groups into the final DGO.

This confirms the Echo Isles project registration is structurally aligned with the Jak 3 build macros, but it does not prove either tool has run successfully on Echo Isles.

## Echo Isles registration

```lisp
(build-custom-level "echo-isles")
(goal-src "levels/echo-isles/echo-isles-obs.gc" "process-focusable")
(custom-level-cgo "EIS.DGO" "echo-isles/echo-isles.gd")
```

The level macro should generate `out/jak3/obj/echo-isles.go`. The GOAL compiler should compile `echo-isles-obs.gc` to an object file. The DGO step should then consume the descriptor and the generated object files to create `out/jak3/iso/EIS.DGO`. These are expected output paths derived from the inspected project macros and project output mapping; they have not yet been observed on a successful build.

## DGO descriptor

The current `echo-isles.gd` lists:
- `echo-isles-obs.o` — the level-specific GOAL object;
- `echo-isles.go` — the generated level geometry object.

The level file is last, matching the convention documented by OpenGOAL's custom actor/DGO guide. If actors or custom art groups are added later, their required files must be included before the level file and in dependency order.

## Current repository checks

The GitHub Actions workflow runs `tools/validate_echo_isles.py`. The latest run for commit `435da0aa461bab27e1918901b3951f12b00eb7e7` passed.

The validator checks JSONC syntax and required fields, GLB v2 container structure, mesh primitives, vertex color attributes, and the DGO descriptor's ordered list. It does not execute `build-level3`, the GOAL compiler, the DGO builder, or the game runtime.

## Local preparation and remaining blockers

The one-click Windows setup script prepares a separate developer checkout and registers the level. It does not alter the Launcher-managed installation. The following still need to be solved and verified:

1. **Native tools:** the reference project requires its C++ tools (including `build-level3`, compiler and DGO toolchain). Launcher binaries have not been proven compatible drop-in replacements for this source checkout.
2. **Submodules:** the setup script currently clones with `--depth 1` and without `--recurse-submodules`. Before a real build, verify whether required submodules are initialized and amend the setup to fetch them if needed.
3. **PAL data:** the user's extracted PAL data is in the Launcher-managed installation. A safe read-only way to point the developer checkout at it has not yet been confirmed. Proprietary data must stay on the user's PC and must not be uploaded to CI.
4. **Level flow:** no Jak 3 continue-point registration for Echo Isles has been added. The public custom-level walkthrough's concrete continue-point example is for Jak 1; it must not be copied into Jak 3 without locating the corresponding Jak 3 data structures.
5. **Runtime:** no DGO has been loaded; spawn, collision, falling/recovery and reload behavior remain untested.

## Next test sequence

After the native tools and PAL data paths are verified:
1. Run the project build step that executes `build-level3` for Echo Isles.
2. Confirm `out/jak3/obj/echo-isles.go` exists and inspect the build log.
3. Run the GOAL compile step and confirm `echo-isles-obs.o` exists.
4. Run the DGO build step and confirm `out/jak3/iso/EIS.DGO` exists.
5. Boot the development game, load the level in debug mode, and test spawn and collision.
6. Only after a repeatable successful runtime test should a Launcher Mod Source manifest or release archive be published.

## Official background

The official OpenGOAL custom-level documentation describes the JSONC/GLB/DGO workflow and notes that custom-level tooling remains early-stage. Its detailed first-level walkthrough is for Jak 1, so Jak 3-specific source must remain authoritative for integration.

- https://opengoal.dev/docs/developing/custom_levels/your_first_level/
- https://opengoal.dev/docs/developing/custom_levels/intro/
- https://opengoal.dev/docs/developing/custom_levels/custom_actors/
