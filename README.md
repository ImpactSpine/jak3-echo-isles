# Jak 3 — Echo Isles

**Unofficial fan-made research and prototype project for OpenGOAL.**

Echo Isles is an original exploratory island/ruins concept inspired by the Jak and Daxter universe. The goal is to establish a reproducible development structure, verify which asset and custom-level workflows are actually supported for **Jak 3**, and only then create a package that can be tested in game.

## Current status

- [x] Public project repository created: https://github.com/ImpactSpine/jak3-echo-isles
- [x] Initial original greybox scene and integration notes drafted.
- [ ] Confirm a mod base and toolchain that explicitly work with Jak 3.
- [ ] Verify the asset/level registration and collision pipeline in Jak 3.
- [ ] Build and test a playable in-game prototype.
- [ ] Package a tested Windows release for OpenGOAL Launcher.
- [ ] Publish a Mod Source manifest only after a real public archive exists.

**This repository is not currently an installable OpenGOAL mod.** A standalone GLB is a source asset, not by itself a level the game can load. Toolchain integration, registration, collision, spawn setup, and in-game testing remain necessary.

## Repository layout

- `custom_levels/echo-isles/` — original greybox scene and early integration drafts.
- `blender/` — optional asset preparation helper.
- `docs/` — asset report, integration notes, compatibility, roadmap and test checklist.
- `.github/workflows/` — basic repository checks.

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
