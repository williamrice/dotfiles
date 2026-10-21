# Global Codex instructions

## Temporary directories and permission blocks

- Use temporary directories, caches, and test directories when they serve a legitimate tool or task requirement, such as package update checks, builds, downloads, or isolated tests. Routine authorized uses do not require extra confirmation solely because they create temporary or cache data.
- Never create or relocate repositories, clones, worktrees, caches, or other working copies to bypass filesystem or network permissions, sandbox restrictions, or an approval requirement.
- When filesystem or network permissions block a task, request the access required for the original action before proceeding. Explain the exact blocked action and access needed; do not substitute a temporary copy or another location as a workaround.
- Keep project changes in the user's existing repository. Temporary artifacts may support the work, but must not replace the repository or evade its access controls. Clean up task-specific temporary artifacts when they are no longer needed; retain normal tool-managed caches when useful.

## Third-party dependency versions

- Follow the latest upstream versions by default. Do not add explicit version, tag, or commit pins unless the user requests them.
- For Neovim plugins, use unversioned plugin definitions. The user evaluates and manages updates with fzf-pack.nvim; do not restrict plugins to stable release tags or introduce version constraints.
- Preserve package-manager lockfiles as part of the normal update workflow; do not treat their recorded installed revisions as a reason to add explicit pins to dependency declarations.
- Consult official upstream documentation when compatibility or API details need verification. Do not select an older version or impose a stable-release policy without the user's instruction.

<!-- context7 -->
Use Context7 MCP to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service — even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer — your training data may not reflect recent changes. Prefer this over web search for library docs.

Do not use for: refactoring, writing scripts from scratch, debugging business logic, code review, or general programming concepts.

## Steps

1. Always start with `resolve-library-id` using the library name and what to look up in the library's documentation, unless the user provides an exact library ID in `/org/project` format
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question). Use version-specific IDs when the user mentions a version
3. `query-docs` with the selected library ID and what to look up in the library's documentation (not single words), scoped to a single concept. If the question spans multiple distinct concepts (e.g. routing and auth and caching), make a separate `query-docs` call per concept with the same library ID, unless the question is about how the concepts interact — combined queries dilute ranking and return shallow results for each topic
4. Answer using the fetched docs
<!-- context7 -->

## Comment standards

- Use comments selectively and professionally.
- Comment only to explain non-obvious constraints, rationale, or workarounds; label useful sections; or provide documentation appropriate to the project.
- Do not narrate edits, migrations, verification, or assistant activity in source/config comments.
- Do not restate obvious code, settings, filenames, or syntax.
- Keep optional improvement notes separate from active configuration.
