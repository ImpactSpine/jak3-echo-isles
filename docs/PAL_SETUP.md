# PAL setup — SCES-524.60

The user's installed Jak 3 data folder contains `SCES_524.60`. This is the European PAL disc identifier. Use the PAL decompiler mapping when extracting assets from this disc.

## Required project configuration

From the root of a compatible OpenGOAL source/mod checkout, select Jak 3 and the PAL decompiler config:

```powershell
task set-game-jak3
task set-decomp-pal
task settings
```

Confirm the settings output reports:
- Game: `jak3`
- Decompiler config: `pal`

Only then extract assets:

```powershell
task extract
```

Do not run `task extract` with the NTSC config against this PAL disc. The config affects asset and text mappings.

## Important distinction

The Launcher version (v2.11.2) is not the same thing as the game disc revision. The disc identifier is the relevant input for the decompiler config.

## Current Echo Isles caveat

This configuration identifies the correct extraction path; it does not mean Echo Isles has compiled or loaded. Before attempting a level build, the GLB must be checked against the custom-level importer requirements. The reference Jak 3 fixture says only the first vertex-color attribute/group is consumed, so Echo Isles' reported 28 vertex-colour material groups must be inspected and consolidated to one compatible vertex-colour layer. Collision orientation also still needs runtime testing.

## Safety

Keep the user's legally obtained game data and extracted assets local. Do not commit ISO images, `iso_data`, decompiler output, or copyrighted game assets to the public mod repository.
