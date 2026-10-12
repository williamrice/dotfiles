# Global Codex instructions

## Temporary directories and permission blocks

- Never create a new temporary directory, including temporary repositories, clones, worktrees, caches, or test directories. Do not run scripts or tools that create new temporary directories.
- When filesystem or network permissions block a task, ask for the required permission before proceeding. Do not relocate or duplicate the work into another directory as a workaround.
- Keep work in the user's existing repository. Explain the exact blocked action and access needed rather than substituting a temporary copy.

## Third-party dependency versions

- Always research and verify the current latest stable and best-supported versions of every third-party library, package, tool, and GitHub Action before recommending, adding, selecting, or updating it. No exceptions. Consult official upstream releases and documentation; never rely only on memory or copied version numbers. If verification is blocked, request the required access rather than guessing.
- Prefer the newest stable release, including a newer stable major version, when one exists. Do not use prereleases or nightly versions as substitutes for stable releases. Stable LTS versions are acceptable, but do not silently select an older LTS when a newer stable release is available.
- If an older version is retained or proposed for compatibility, LTS support, reproducibility, or another reason, explicitly warn the user before using it. Identify the newest stable alternative and explain the concrete tradeoffs, support/security implications, and upgrade constraints.
- Pin dependencies and GitHub Actions reproducibly to the researched version or its exact commit SHA where appropriate. Recheck upstream releases for each relevant task; never assume an existing pin is still current.
