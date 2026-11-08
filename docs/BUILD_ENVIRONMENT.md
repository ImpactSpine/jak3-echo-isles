# Jak 3 build environment — verified route

**Research date:** 2026-11-08  
**Status:** source-build route identified; Echo Isles is not yet compiled or playable.

## Recommended reference checkout

Use the Jak 3-capable source tree documented by the Battle of Spargus project:

- Repository: https://github.com/whozghiar/jak3-mod-battle-of-spargus
- Its README identifies it as a Jak 3 OpenGOAL mod project and documents local compilation.
- It contains `goal_src/jak3/game.gp`, `goal_src/jak3/lib/project-lib.gp`, the Jak 3 decompiler configuration, and a real custom-level fixture under `custom_assets/jak3/levels/test-zone/`.
- Its Taskfile documents `task set-game-jak3`, `task extract`, `task repl`, `task compile-check`, and game boot tasks.

This is a **developer source tree**, not an already-tested Echo Isles base. The Battle of Spargus README says that mod has no release; its technical document also says its own gameplay behavior has not been verified. Use it as a reproducible source/build reference, not as proof of a playable package.

## Why we need a source checkout

The OpenGOAL Launcher installation is a player runtime. The source workflow additionally needs the OpenGOAL source tree, compiler/decompiler build tools, a compatible Jak 3 game-data extraction, and a developer build. The Launcher does not turn an arbitrary GitHub source repository into an installable mod by itself.

The source project's documented local flow is:

1. Clone the source repository (including its submodules):
   `git clone --recurse-submodules https://github.com/whozghiar/jak3-mod-battle-of-spargus.git`
2. In that checkout, select Jak 3: `task set-game-jak3`.
3. Configure/build the required native tools according to that checkout's Taskfile and platform instructions.
4. Make the user's own legally obtained Jak 3 game data available locally, then run `task extract`.
5. Register the Echo Isles custom level in that source tree's `goal_src/jak3/game.gp`.
6. Build/compile the GOAL project and generated DGO using the source tree's documented build/REPL flow.
7. Boot Jak 3 and test the custom level in-game.

Do not upload an ISO, extracted game data, or proprietary game assets to this repository or to a public CI artifact.

## Jak 3 custom-level pattern verified in the source tree

The fixture in `goal_src/jak3/game.gp` registers its test level with:

```lisp
(build-custom-level "test-zone")
(goal-src "levels/test-zone/test-zone-obs.gc" "process-focusable")
(custom-level-cgo "TSZ.DGO" "test-zone/testzone.gd")
```

Echo Isles uses the analogous names and descriptor:

```lisp
(build-custom-level "echo-isles")
(goal-src "levels/echo-isles/echo-isles-obs.gc" "process-focusable")
(custom-level-cgo "EIS.DGO" "echo-isles/echo-isles.gd")
```

The descriptor and asset paths are inputs to the build pipeline, not evidence that the level has already been built. A successful GOAL source compile alone is not enough: we must also verify that the level-building step emits the DGO and that the runtime can load it.

## What I need from the user

No ISO or extracted game files should be sent here. When ready to run the local build, the user only needs to:

- have a legally obtained Jak 3 copy already usable by their OpenGOAL setup;
- install/clone the developer source tree on the Windows PC;
- tell me whether they are comfortable running a short PowerShell setup sequence, or share a screenshot of the OpenGOAL Launcher's Jak 3 version/game-data page so I can tailor the path instructions.

Do not ask the user to edit GOAL source manually. I will prepare the Echo Isles integration patch and exact commands first.

## Current blockers

- Echo Isles GLB and JSONC have only passed repository-level structural checks.
- The exact spawn/continue-point behavior still needs verification against the selected Jak 3 source tree.
- No custom-level DGO has yet been produced by the OpenGOAL toolchain.
- No in-game load, spawn, or collision test has passed.
- No Launcher Mod Source manifest or release archive should be published before a tested package exists.
