# Echo Isles — Jak 3 integration steps

**Status:** source files are now arranged in the Jak 3 custom-level folder layout. This is not yet a compiled mod.

## 1. Copy the level folder into a Jak 3 mod-base checkout

Copy the contents of this repository's:

`custom_assets/jak3/levels/echo-isles/`

into the matching path in a Jak 3 development base:

`custom_assets/jak3/levels/echo-isles/`

The folder should contain:
- `echo-isles.jsonc`
- `echo-isles.gd`
- `echo-isles.glb`

Do not copy an ISO, extracted game data, or any copyrighted game assets into this repository.

## 2. Register the custom level in Jak 3 game.gp

In `goal_src/jak3/game.gp`, find the existing **Example Custom Level** section. Add an Echo Isles block alongside the test-zone example:

```lisp
(build-custom-level "echo-isles")
(goal-src "levels/echo-isles/echo-isles-obs.gc" "process-focusable")
(custom-level-cgo "EIS.DGO" "echo-isles/echo-isles.gd")
```

The paths and macros above are taken from the Jak 3 project structure in the candidate reference base. A copy-ready snippet is in [`patches/jak3-game.gp.snippet`](../patches/jak3-game.gp.snippet). Keep the existing test-zone example until Echo Isles builds successfully.

The verified Jak 3 fixture does not show a separate `level-info.gc` edit as part of this custom-level registration block. Do not modify level-info speculatively; first establish whether the selected base requires a standard continue-point entry beyond the custom debug loader.

## 3. Prepare and build

The installed disc has been identified as European PAL from its `SCES_524.60` identifier. Follow [`docs/PAL_SETUP.md`](docs/PAL_SETUP.md) and select the PAL decompiler mapping before extraction:

```powershell
task set-game-jak3
task set-decomp-pal
task settings
task extract
task repl
```

In the OpenGOAL REPL/compiler, run:

```lisp
(mi)
```

Do not treat a successful command as proof of a successful level load. Capture the complete compiler output and confirm that the Echo Isles level object and EIS.DGO were produced.

## 4. Runtime test

Use the Jak 3 custom-level debug workflow available in the selected mod base. The general custom-level guide documents `(bg-custom 'test-zone-vis)` for its test fixture; verify the generated symbol in the chosen Jak 3 checkout before using `(bg-custom 'echo-isles-vis)`.

Test in this order:
1. Level loads without a crash.
2. Player spawns above a broad, safe ground surface.
3. Ground and stepping-stone collision work.
4. Pillars, ruin walls, and gateway collision block from the intended side.
5. Player can traverse the island without falling through geometry.
6. Restart/reload does not strand the player or softlock the game.

## 5. Known remaining integration work

- Confirm the debug entry mechanism and whether a standard continue-point entry is required in the exact Jak 3 base.
- Confirm whether the generated level symbol is `echo-isles-vis` or another name; do not guess.
- The reference Jak 3 importer documentation says only the first vertex-colour attribute/group is used. The current Echo Isles asset report lists 28 vertex-colour material groups; inspect and consolidate the GLB to one compatible vertex-colour layer before relying on the build.
- Confirm the GLB imports correctly in the exact OpenGOAL compiler version.
- Inspect face orientation and collision in-game. The asset report notes a set of downward-facing near-horizontal triangles that may need correction.
- Only after successful compile and runtime tests should the README or release status say “playable”.

## Reference

Candidate Jak 3 source project: https://github.com/whozghiar/jak3-mod-battle-of-spargus

Its `goal_src/jak3/game.gp` contains the custom-level registration example, and its `custom_assets/jak3/levels/test-zone/` folder contains the corresponding JSONC, GLB, and DGO descriptor. Its own project documentation cautions that its mod behavior is not yet verified in-game, so Echo Isles still requires independent testing.
