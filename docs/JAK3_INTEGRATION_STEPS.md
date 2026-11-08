# Echo Isles — Jak 3 integration steps

**Status:** source assets and a registration snippet are prepared. No Jak 3 build or runtime test has passed yet.

## 1. Use a real Jak 3 developer source tree

The current Echo Isles repository is an asset/prototype repository, not a full OpenGOAL source checkout. The verified reference route is documented in [BUILD_ENVIRONMENT.md](BUILD_ENVIRONMENT.md), using the Jak 3 source tree at:

https://github.com/whozghiar/jak3-mod-battle-of-spargus

That repository contains a Jak 3 `game.gp`, Jak 3 project build macros, decompiler config, and a custom-level fixture. Its own mod is not being treated as a tested game release; we use its source/build structure only.

## 2. Copy Echo Isles assets into the source tree

Copy this repository folder:

`custom_assets/jak3/levels/echo-isles/`

to the matching path in the source checkout. It contains:
- `echo-isles.jsonc`
- `echo-isles.gd`
- `echo-isles.glb`

Do not copy an ISO, extracted game data, or copyrighted game assets into this repository.

## 3. Register the custom level

In `goal_src/jak3/game.gp`, add the block alongside the existing `test-zone` fixture:

```lisp
(build-custom-level "echo-isles")
(goal-src "levels/echo-isles/echo-isles-obs.gc" "process-focusable")
(custom-level-cgo "EIS.DGO" "echo-isles/echo-isles.gd")
```

A copy-ready snippet is in [patches/jak3-game.gp.snippet](../patches/jak3-game.gp.snippet). Do not remove the test-zone example until Echo Isles builds and loads successfully.

The source fixture confirms this three-line registration pattern. It does not yet settle whether Echo Isles needs a separate continue-point or level-info entry for a normal game-flow transition. We will inspect that after a debug load is working rather than making speculative edits.

## 4. Build and test in the source checkout

The source tree documents the following Jak 3 developer commands:
- `task set-game-jak3` — select Jak 3.
- `task extract` — extract the user's local Jak 3 game data and bake configured assets.
- `task repl` — open the GOAL compiler/REPL.
- `task compile-check` — headless GOAL source compile check.
- `task boot-game` / `task boot-game-retail` — boot the game after the relevant outputs exist.

The exact custom-level build must also execute the project build steps registered by `game.gp`; a successful `compile-check` by itself does not prove the custom DGO was generated. Record the output paths and build log, then boot the game and use the custom-level debug entry available in that checkout.

Do not guess the debug symbol. The official generic guide's `test-zone-vis` example is not proof that the Jak 3 fixture exposes the same symbol; inspect the generated GOAL symbols or fixture's own test procedure first.

## 5. Runtime acceptance tests

1. The custom level DGO is generated without errors.
2. Jak 3 boots with the custom level registration.
3. The Echo Isles level can be loaded without a crash.
4. Jak spawns above a broad, safe ground surface.
5. Ground and stepping-stone collision work.
6. Pillars, ruin walls, and gateway collision block from the intended side.
7. Traversal does not fall through geometry or softlock.
8. Restart/reload does not strand the player.

The asset report flags downward-facing near-horizontal triangles that may need correction. Inspect and fix them if the in-game collision test confirms a problem.

## 6. Current limits

- The GLB/JSONC have passed repository-level checks only.
- No OpenGOAL custom DGO has yet been built.
- No in-game spawn or collision test has passed.
- No Launcher Mod Source manifest or release archive should be published before a tested package exists.

See [BUILD_ENVIRONMENT.md](BUILD_ENVIRONMENT.md) for prerequisites and the exact user-side setup needed.