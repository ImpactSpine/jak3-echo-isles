# Jak 3 — Echo Isles

**Unofficial fan-made research and prototype project for OpenGOAL.**

Echo Isles is an original exploratory island/ruins concept inspired by the Jak and Daxter universe. The goal is to establish a reproducible development structure, verify which asset and custom-level workflows are actually supported for **Jak 3**, and only then create a package that can be tested in game.

## Current status

- [x] Public project repository created: https://github.com/ImpactSpine/jak3-echo-isles
- [x] Initial original greybox scene and integration notes drafted.
- [x] Identify a Jak 3 source project with a custom-level fixture (`whozghiar/jak3-mod-battle-of-spargus`; reference only, not yet pinned as the user's build base).
- [x] Confirm the Jak 3 custom-level registration pattern in a real Jak 3 `game.gp` fixture.
- [ ] Verify Echo Isles asset import, level registration, spawn, and collision in a Jak 3 build.
- [ ] Build and test a playable in-game prototype.
- [ ] Package a tested Windows release for OpenGOAL Launcher.
- [ ] Publish a Mod Source manifest only after a real public archive exists.

**This repository is not currently an installable OpenGOAL mod.** A standalone GLB is a source asset, not by itself a level the game can load. Toolchain integration, registration, collision, spawn setup, and in-game testing remain necessary.

## Repository layout

- `custom_assets/jak3/levels/echo-isles/` — Jak 3-layout JSONC, DGO descriptor, and copied greybox GLB.
- `echo-isles.glb`, `echo-isles.jsonc`, `echo-isles.gd` — original source/prototype files at repository root.
- `blender/` — optional asset preparation helper.
- `docs/` — asset report, Jak 3 base audit/discovery, integration steps, compatibility, roadmap and test checklist.
- `.github/workflows/` — basic repository checks.

## Jak 3 integration reference

A concrete Jak 3 custom-level example is present in [`whozghiar/jak3-mod-battle-of-spargus`](https://github.com/whozghiar/jak3-mod-battle-of-spargus): its `goal_src/jak3/game.gp` registers `test-zone` with `build-custom-level`, `goal-src`, and `custom-level-cgo`. Echo Isles now follows the corresponding Jak 3 `custom_assets/jak3/levels/echo-isles/` folder layout. See [`docs/JAK3_PIPELINE_AUDIT.md`](docs/JAK3_PIPELINE_AUDIT.md) and [`docs/JAK3_INTEGRATION_STEPS.md`](docs/JAK3_INTEGRATION_STEPS.md) for the verified pattern and remaining checks.

This is a structural reference only. The candidate repository's own mod behavior is not confirmed as playable, and Echo Isles has not yet been compiled or loaded in-game.

## Development principles

- Use original code and original assets wherever possible.
- Do not commit game ISOs, extracted game data, or copyrighted assets.
- Do not claim compatibility until there is a successful build and in-game test.
- Keep each milestone small, testable, and documented.

## Planned first playable milestone

Load an original compact island/ruins environment, place the player at a safe spawn, ensure collision and traversal work, and check that restart/respawn does not softlock the game. Visual polish comes after that path is reliable.

## Reporting test results

When a build becomes available, record the OpenGOAL Launcher version, Jak 3 region/version if known, installation steps, whether the game starts and the level loads, the exact error text if it fails, and screenshots where possible.

## Disclaimer

This is a non-commercial fan project, not affiliated with or endorsed by Naughty Dog, Sony Interactive Entertainment, or OpenGOAL contributors. Jak and Daxter and related names belong to their respective owners. Do not upload game ISOs or extracted game files.
