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

The paths and macros above are taken from the Jak 3 project structure in the candidate reference base. Keep the existing test-zone example until Echo Isles builds successfully.

## 3. Prepare and build

The candidate Jak 3 reference project documents this setup sequence:

```bash
task set-game-jak3
task extract
task repl
```

In the OpenGOAL REPL/compiler, run:

```lisp
(mi)
```

Do not treat a successful command as proof of a successful level load. Capture the complete compiler output and confirm that the Echo Isles level object and EIS.DGO were produced.

## 4. Runtime test

Use the Jak 3 custom-level debug workflow available in the selected mod base. The older general custom-level template documents `(bg-custom 'test-zone-vis)`, but verify the exact command and generated level symbol in the chosen Jak 3 checkout before using the Echo Isles equivalent.

Test in this order:
1. Level loads without a crash.
2. Player spawns above a broad, safe ground surface.
3. Ground and stepping-stone collision work.
4. Pillars, ruin walls, and gateway collision block from the intended side.
5. Player can traverse the island without falling through geometry.
6. Restart/reload does not strand the player or softlock the game.

## 5. Known remaining integration work

- Confirm the level-info / debug entry mechanism in the exact Jak 3 base.
- Confirm whether the generated level symbol is `echo-isles-vis` or another name; do not guess.
- Confirm the GLB imports correctly in the exact OpenGOAL compiler version.
- Inspect face orientation and collision in-game. The asset report notes a set of downward-facing near-horizontal triangles that may need correction.
- Only after successful compile and runtime tests should the README or release status say “playable”.

## Reference

Candidate Jak 3 source project: https://github.com/whozghiar/jak3-mod-battle-of-spargus

Its `goal_src/jak3/game.gp` contains the custom-level registration example, and its `custom_assets/jak3/levels/test-zone/` folder contains the corresponding JSONC, GLB, and DGO descriptor. Its own project documentation cautions that its mod behavior is not yet verified in-game, so Echo Isles still requires independent testing.
