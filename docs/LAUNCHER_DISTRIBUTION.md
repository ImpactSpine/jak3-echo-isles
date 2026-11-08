# OpenGOAL Launcher distribution contract

This project targets the native OpenGOAL Launcher mod workflow.

## What the Launcher consumes

A Mod Source is a publicly accessible JSON document. The current source schema is illustrated by the official Launcher's fixture:
https://github.com/open-goal/launcher/blob/HEAD/fixtures/mock-mods.json

The root object uses:
- schemaVersion
- sourceName
- lastUpdated
- mods

A mod entry includes displayName, description, authors, tags, supportedGames, coverArtUrl, thumbnailArtUrl, versions, perGameConfig and externalLink.

Each installable version includes version, publishedDate, supportedGames, settings and assets. For Windows, assets.windows must point to a downloadable release bundle. A repository URL or source-code ZIP is not a substitute for a built OpenGOAL mod bundle.

## Echo Isles status

Echo Isles is currently an experimental Jak 3 custom-level source project. It is not yet a Launcher-installable bundle:
- no verified Jak 3 PAL build exists;
- no Windows release archive exists;
- the GLB vertex-colour layout and collision orientation still require validation in the OpenGOAL custom-level pipeline;
- no runtime smoke test has been performed.

Do not list a fabricated version or point the Launcher at the source repository. That would create an install entry that cannot work.

## Required release gates

1. Validate and import the GLB with the Jak 3 custom-level builder.
2. Compile the mod against the Jak 3 PAL configuration using a legally obtained user game dump; do not commit game assets or binaries derived from copyrighted assets.
3. Boot the generated bundle and verify the level loads, collision works, and the player can traverse the area.
4. Package the Windows bundle in the format expected by the Launcher.
5. Publish a GitHub Release and add its asset URL to a public Mod Source JSON.
6. Request listing on JakMods if we want the mod to appear in its shared catalog.

Until gates 1-4 are completed, keep the source project clearly marked as experimental and do not publish a false installable release.
