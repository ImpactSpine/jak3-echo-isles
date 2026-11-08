# Windows one-time setup

The OpenGOAL Launcher game-data folder is not the same thing as the full source checkout. Do not put development files inside the Launcher's managed data folder.

The helper script creates a separate checkout at:

`%USERPROFILE%\OpenGOAL-Jak3-EchoIsles`

It leaves the existing Launcher installation and saves untouched.

## Prerequisites

Install:
- Git for Windows
- go-task (the executable command is `task`)

Then download [`tools/setup-echo-isles.ps1`](../tools/setup-echo-isles.ps1) from this branch, right-click it and choose **Run with PowerShell**, or run it from PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\Downloads\setup-echo-isles.ps1"
```

The script clones the candidate Jak 3 development base, downloads this repository's Echo Isles assets, registers the custom level once in `goal_src/jak3/game.gp`, and selects the PAL decompiler configuration.

It does not run extraction, compile, or launch the game. It does not copy any ISO or extracted game data.

## After it finishes

Open PowerShell and run:

```powershell
cd "$HOME\OpenGOAL-Jak3-EchoIsles"
task settings
```

Check that the active game is `jak3` and the decompiler config is `pal`. Stop there and share the output before running `task extract`.

## Important

This is a development checkout separate from the Launcher. The candidate base and Echo Isles integration are still experimental. The Echo Isles GLB must be consolidated to the single vertex-colour layer expected by the reference custom-level importer before we attempt the build. A successful setup script is not proof that the mod compiles or runs.
