# Base selection for Jak 4 / Echo Isles

Research date: 2026-11-08

## Decision

Use `whozghiar/jak3-mod-battle-of-spargus` as the initial Jak 3 modding base for Echo Isles, rather than `whozghiar/jak3-multiplayer`.

This is a provisional engineering choice, not a claim that Echo Isles already builds or runs.

## Why Battle of Spargus is the better starting point

The Battle of Spargus README explicitly describes its changes as a GOAL-only mod and says native binary compilation is not required; the documented workflow uses the standard binaries, with asset extraction required for its additional models. It also contains a real Jak 3 custom-level fixture and registration pattern.

Source: https://github.com/whozghiar/jak3-mod-battle-of-spargus

Important caveat: the repository README says it has no published release and that its scenario behavior has not been verified in-game. We should reuse its source layout and workflow, not assume the mod itself is a tested playable base.

## Why not Jak 3 Multiplayer

The Multiplayer project has a published Launcher Mod Source and prebuilt release packages, so it is excellent evidence for packaging and installation. However, its README says the network layer changes the native game runtime in `game/kernel/jak3/kmultiplayer.cpp` and instructs developers to run `task build-release-game` when engine/compiler C++ changes.

Source: https://github.com/whozghiar/jak3-multiplayer

That is unnecessary complexity for the first Echo Isles milestone. We do not need multiplayer networking to create a new explorable region. We can borrow its release/catalog format later without adopting its C++ runtime fork.

## What can be reused

From Battle of Spargus:
- Jak 3 GOAL source tree and project conventions.
- Existing standard-binary workflow for GOAL-only changes.
- Custom-level fixture structure and DGO registration example.
- Mod menu/configuration patterns if later useful.

From Multiplayer:
- Proven Launcher catalog structure (`index.json`).
- Published release bundle naming and checksums.
- Demonstrated player installation flow through OpenGOAL Launcher.

## Work still required

1. Inspect the Battle of Spargus source tree and its submodules/build configuration.
2. Verify the local Jak 3 PAL data layout already extracted by the user's Launcher.
3. Make a clean, separate developer checkout and stage only the user's own local extracted game data there; never upload proprietary data.
4. Consolidate/fix the Echo Isles GLB (the current prototype needs a single supported vertex-colour layer and winding/normal review).
5. Register the level against the Jak 3 fixture, then run the actual level build and GOAL compile.
6. Test loading, spawn, collision, falling/recovery, and repeatability in-game.
7. Only after those tests, create a Launcher-compatible release bundle and Mod Source catalog.

## User effort target

The user should not install Visual Studio/CMake/LLVM merely to play the mod. Prefer the existing Launcher tooling for local validation and use CI only if the source project's build steps are compatible with a hosted runner. Do not claim that the Launcher compiler alone replaces the complete decompiler/asset extraction pipeline until verified.
