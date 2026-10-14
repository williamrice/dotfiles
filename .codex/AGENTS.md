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

<!-- context7 -->
Use Context7 MCP to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service — even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer — your training data may not reflect recent changes. Prefer this over web search for library docs.

Do not use for: refactoring, writing scripts from scratch, debugging business logic, code review, or general programming concepts.

## Steps

1. Always start with `resolve-library-id` using the library name and what to look up in the library's documentation, unless the user provides an exact library ID in `/org/project` format
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question). Use version-specific IDs when the user mentions a version
3. `query-docs` with the selected library ID and what to look up in the library's documentation (not single words), scoped to a single concept. If the question spans multiple distinct concepts (e.g. routing and auth and caching), make a separate `query-docs` call per concept with the same library ID, unless the question is about how the concepts interact — combined queries dilute ranking and return shallow results for each topic
4. Answer using the fetched docs
<!-- context7 -->
