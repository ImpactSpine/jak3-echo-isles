# Echo Isles — Roadmap and acceptance criteria

## Milestone 0 — Repository and compatibility
- [x] Create the project repository and initial documentation.
- [ ] Choose a mod base that supports the exact Jak 3 target.
- [ ] Record toolchain versions and reproducible setup steps.
- [ ] Verify the actual custom-level/asset registration path for Jak 3.

**Exit criteria:** documented, repeatable process from source assets to a Jak 3 build.

## Milestone 1 — Asset validation
- [ ] Open the GLB in Blender or an independent GLB viewer.
- [ ] Verify scale, coordinates, transforms, triangle winding and normals.
- [ ] Define and test the collision representation and conversion pipeline.
- [ ] Confirm the runtime can locate and load the converted asset.

**Exit criteria:** assets package without errors; no assumption that the runtime loads a raw GLB directly.

## Milestone 2 — First playable test
- [ ] Load the environment in Jak 3.
- [ ] Place the player at a safe spawn.
- [ ] Verify floor/platform collision and traversability.
- [ ] Verify restart/respawn and avoid immediate softlocks.
- [ ] Save the build result, logs, and screenshots.

**Exit criteria:** the player can enter and traverse the test area and recover from a restart.

## Milestone 3 — Visual pass
- [ ] Replace placeholder shapes with original stylized assets.
- [ ] Add strong landmark silhouettes, shoreline/water, ruins and navigation cues.
- [ ] Optimize geometry and texture sizes for target hardware.
- [ ] Keep original assets separate from any extracted game material.

## Milestone 4 — Distribution
- [ ] Build and test a Windows package.
- [ ] Validate the package layout against a known working OpenGOAL mod.
- [ ] Publish a versioned release archive.
- [ ] Create and validate a Mod Source manifest that points to the real archive URL.
- [ ] Install and test it from a clean OpenGOAL Launcher profile.

## Not yet claimed
A complete Jak 4-length campaign, AAA visual fidelity, or working Jak 3 custom-level support before evidence exists.
