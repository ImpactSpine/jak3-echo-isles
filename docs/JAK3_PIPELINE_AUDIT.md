# Jak 3 OpenGOAL integration audit

**Research date:** 2026-11-08  
**Status:** Echo Isles source package passes repository validation. Local source-tree preparation and game.gp registration are scripted. No custom-level build or in-game test has passed.

## Confirmed Jak 3 reference

Repository: https://github.com/whozghiar/jak3-mod-battle-of-spargus

The source tree contains a Jak 3 `game.gp`, Jak 3 decompiler configuration, a custom-level test fixture, and Taskfile workflows. We use it as a development-source reference, not as proof that its own mod is a tested release.

Its custom-level fixture registers a level using:
```lisp
(build-custom-level "test-zone")
(goal-src "levels/test-zone/test-zone-obs.gc" "process-focusable")
(custom-level-cgo "TSZ.DGO" "test-zone/testzone.gd")
```

The Echo Isles equivalent is:
```lisp
(build-custom-level "echo-isles")
(goal-src "levels/echo-isles/echo-isles-obs.gc" "process-focusable")
(custom-level-cgo "EIS.DGO" "echo-isles/echo-isles.gd")
```

The local Windows setup script copies the Echo Isles assets into the separate source checkout and inserts this block next to the test-zone fixture. It does not modify the Launcher-managed installation.

## Current repository checks

The GitHub Actions workflow runs `tools/validate_echo_isles.py`. The latest run for commit `435da0aa461bab27e1918901b3951f12b00eb7e7` passed.

The validator checks:
- JSONC syntax and required level naming fields;
- GLB v2 header and embedded JSON chunk;
- presence of mesh primitives and `COLOR_0` on every primitive;
- absence of additional vertex-color sets;
- the Echo Isles DGO descriptor's ordered object list.

These are source-package checks only. They do not execute the OpenGOAL custom-level generator, compile GOAL code, generate the DGO, or boot the game.

## DGO descriptor

The current `echo-isles.gd` follows the same one-list DGO descriptor structure as the Jak 3 test-zone fixture. It includes:
- `echo-isles-obs.o` — generated level geometry object;
- `echo-isles.go` — generated level GOAL object.

If future actors or custom art groups are added, their required objects must be appended to this DGO list in dependency order, following the fixture's example.

## Known blockers before a playable test

1. **Build toolchain:** the reference source project's documented build requires a native C++ toolchain to build its own decompiler and other tools. The user's Launcher binaries are not proven drop-in replacements for the source checkout's full toolchain.
2. **Local game data:** the user's PAL data is already extracted in the Launcher-managed installation. A safe, read-only way to expose the required data to the separate developer checkout has not yet been verified. Proprietary data must stay on the user's PC.
3. **Level generation:** no successful invocation of the custom-level generator against Echo Isles has been recorded.
4. **Runtime:** no DGO has been loaded; spawn, collision, falling/recovery, and reload behavior remain untested.
5. **Gameplay flow:** normal campaign transition/continue-point registration has not been investigated. First prove a debug load before adding speculative level-info changes.

## Why CI is not currently used for game builds

The repository's GitHub Actions workflow intentionally validates only the public source assets. A hosted runner does not have the user's Jak 3 PAL data, and that proprietary data must not be uploaded to CI. The C++ toolchain build is also materially heavier than the current lightweight validation job. Do not present a CI source check as a game build.

## Next verified engineering step

Use the already prepared local checkout at `%USERPROFILE%\OpenGOAL-Jak3-EchoIsles\jak3-base` and inspect:
- exact Taskfile build targets and generated output paths;
- the custom-level build macro implementation;
- the user's local Launcher PAL data layout and whether it can be referenced without modifying or copying the Launcher installation.

Only then run the actual level-generation task. Record the command, exit code, output files, and complete log. Do not claim a playable build until the DGO exists and Jak 3 loads it.

## Official background

The official OpenGOAL custom-level documentation warns that custom-level tooling is early-stage. Moving enemies/NPCs require navigation meshes, which are not generally available in the documented custom-level workflow without substantial hard-coding.

- https://opengoal.dev/docs/developing/custom_levels/your_first_level/
- https://opengoal.dev/docs/developing/custom_levels/intro/
