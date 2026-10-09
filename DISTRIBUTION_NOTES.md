# OpenGOAL Launcher distribution notes

A Mod Source URL is not the same thing as a repository URL. A Launcher source manifest must match the schema supported by the target Launcher version, and every mod version must link to a real, publicly reachable release archive for the target operating system.

Do not publish a source entry until these exist:
1. A package built with a verified Jak 3-compatible mod base.
2. A successful build and in-game test.
3. An archive using the install layout expected by that mod base/Launcher.
4. A versioned public download URL.
5. A manifest validated against a known working source schema.

Project repository: https://github.com/ImpactSpine/jak3-echo-isles

**Do not enter the repository URL itself as a Mod Source URL.** The repository is useful for development but is not an installable mod source, and no release archive is available yet.
