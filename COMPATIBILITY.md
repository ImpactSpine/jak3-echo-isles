# Compatibility investigation

## Intended target
- Game: Jak 3
- Platform: Windows
- Runtime/launcher: OpenGOAL Launcher
- Current status: early investigation; no successful custom-level build is claimed.

## Evidence required
1. A maintained mod base that explicitly targets Jak 3.
2. A documented toolchain and successful build command.
3. A working mechanism to register/load custom content in the target game.
4. A test asset visible in game, with collision and a safe spawn.
5. A distribution process that does not redistribute game files.

## Important distinction
A GLB is a source asset, not automatically a runtime-loadable Jak 3 level. The target workflow may require conversion, game-specific registration, collision data, spawn setup, and packaging. Jak 1 examples must not be assumed to work unchanged for Jak 3.

## Record confirmed results here
- Mod base / repository:
- Commit or release tag:
- Confirmed target(s):
- Required toolchain:
- Build command and result:
- In-game test result:
- Evidence/logs:
