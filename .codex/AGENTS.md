# Global Codex instructions

## Scope and working approach

- Apply these as personal defaults across projects. Follow more specific repository and directory instructions for local conventions, and explicit user instructions for the current task.
- Keep this file focused on durable preferences. Put project-specific commands, architecture constraints, and workflows in the relevant repository's AGENTS.md; keep formatting and other mechanical rules in tooling.
- Read the relevant code, tests, and documentation before changing behavior. Scale investigation and planning to the task; avoid requiring a full repository survey for a small edit.
- Complete authorized work through implementation and appropriate verification. Make routine, reversible decisions independently; ask when missing information materially changes scope, public behavior, or an irreversible action.
- Keep changes cohesive and relevant to the request. Preserve unrelated user changes and avoid incidental rewrites, dependency upgrades, or broad architectural migrations.

## Git permissions

- Run Git operations that change repository state only when the user explicitly requests the specific action. A request to implement or fix code does not authorize staging, committing, or other Git mutations.
- This includes changes to the index, history, branches, tags, stashes, remotes, Git configuration, and worktrees, as well as checkout, restore, reset, clean, merge, rebase, fetch, pull, and push. Do not let tools, hooks, scripts, or delegated agents perform these actions indirectly without the same explicit authorization.
- Read-only inspection such as status, diff, log, and show is allowed. Ordinary source-file edits needed for the requested task are allowed; this restriction concerns Git operations and repository metadata.
- Leave completed changes uncommitted unless explicitly asked to commit. Do not routinely ask to commit or perform other Git mutations at the end of a task.

## Planning and Herdr delegation

- Use a short, actionable plan when work spans multiple dependent steps, architectural decisions, or substantial uncertainty. Keep it current as evidence changes; handle straightforward tasks directly without a formal plan.
- Herdr is the preferred harness for delegated agent work when applicable. Evaluate whether delegation will improve total cost or completion time without compromising quality; it is a preference, not a required step for every task.
- Prefer a cheaper model for bounded tasks it can reliably complete after the primary model has researched the problem and established the approach. Consider task complexity, ambiguity, risk, available model capabilities, and coordination and review overhead; keep small, tightly coupled, or judgment-heavy work with the primary model when that is more effective.
- Give each delegated task the relevant research, decisions, constraints, file ownership, expected deliverable, and acceptance checks. Split independent work where useful and avoid overlapping edits in a shared working directory.
- Keep the primary model responsible for architecture, integration, and final quality. Review delegated changes and verify their results before accepting them; refine the task or use a more capable model when needed.
- Use the Herdr skill and verify HERDR_ENV=1 before controlling agents or panes. Prefer background sibling panes in the current working directory and preserve user focus. If Herdr is unavailable, continue directly when practical and mention the limitation when it affects the workflow.

## Architecture and design

- Prefer clean architecture: keep domain rules and use cases independent of UI, transport, persistence, and framework details. Dependencies should point toward the domain; adapt external systems at the edges.
- Apply this proportionately to the project. Preserve useful existing boundaries and language idioms; introduce layers or interfaces when they isolate a real dependency, clarify responsibility, or enable meaningful testing.
- Keep modules cohesive, responsibilities clear, and dependencies explicit. Prefer composition and small, focused interfaces over deep inheritance or global mutable state.
- Keep business logic separate from I/O and orchestration where practical. Pass simple, explicit data across boundaries rather than leaking database or framework objects into the domain.
- Choose the simplest design that meets current requirements. Avoid speculative features, generic frameworks, one-use wrappers, and abstractions justified only by hypothetical reuse.
- Extract shared code when it represents a stable concept or repeated rule. Keep domain-specific behavior near its owning feature; avoid catch-all utility modules and premature deduplication.
- Preserve public contracts unless the task calls for a change. Make compatibility implications explicit and update affected callers and documentation together.

## Implementation quality

- Use descriptive names, straightforward control flow, and idiomatic types. Represent valid states clearly and validate untrusted data at system boundaries.
- Handle expected failures explicitly and preserve useful error context. Avoid silently swallowing failures, fabricated defaults, and fallback behavior that hides defects.
- Consider resource cleanup, cancellation, concurrency, and transaction boundaries when relevant to the change.
- Keep secrets and sensitive data out of source, logs, fixtures, and error messages. Use the platform's established validation, parameterization, and authorization mechanisms.
- Optimize when requirements or measurements justify it. Consider algorithmic cost and external calls before adding caches or complex performance machinery.

## Comments and documentation

- Prefer clear code; add comments for intent, non-obvious constraints, invariants, tradeoffs, or workarounds. Do not restate syntax or narrate edits, migrations, verification, or assistant activity.
- Document public APIs, libraries, and shared utilities using the project's documentation conventions. Explain their contract: purpose, non-obvious inputs and outputs, errors, side effects, and usage examples when useful. Avoid boilerplate documentation on every private helper.
- For workarounds, explain the underlying limitation and, when known, link the upstream issue and state the condition for removal.
- Keep comments and documentation accurate when behavior changes. Put substantial architectural decisions in the project's established decision records or design documentation.
- Use section comments only when they improve navigation. Keep optional improvement notes separate from active configuration; remove obsolete commented-out code in touched areas.

## Verification and completion

- Use the repository's existing formatter, linter, type checker, build, and focused unit or integration tests as appropriate to the change. Start with affected checks and broaden when risk or failures warrant it.
- The user handles end-to-end testing on clients to save agent tokens. Do not run client end-to-end suites, browser automation, or manual client walkthroughs unless the user explicitly asks. This does not prevent builds, static checks, or focused unit and integration testing.
- Add or update tests when they provide meaningful coverage for changed behavior. For bug fixes, add a regression test when practical that fails for the original defect. Authoring client end-to-end tests when useful does not authorize running them.
- If a verification command bundles client end-to-end tests with other checks, use a narrower supported command or report the limitation. Briefly identify any relevant client behavior left for the user to verify without making it a routine approval gate.
- Test observable contracts, meaningful edge cases, and failure paths. Use integration tests for important boundaries; avoid tests coupled to private implementation details or mocks that merely restate the code.
- Scale verification to impact. Documentation-only edits and trivial configuration changes usually need focused inspection or validation rather than a new test suite.
- Review the final diff for correctness, scope, unintended files, and stale documentation. Report what changed, what was verified, and any remaining limitations; never claim an unrun check passed.

## Research and current documentation

- Research unfamiliar behavior, compatibility questions, and consequential technical choices before relying on assumptions. Prefer official upstream documentation and primary sources; distinguish documented facts from inference and cite sources that informed the recommendation.
- Use Context7 MCP for library, framework, SDK, API, CLI, and cloud-service questions, including syntax, configuration, migrations, setup, and library-specific debugging, even when the answer seems familiar.
- Start with resolve-library-id unless an exact /org/project ID was supplied. Choose the closest authoritative match using relevance, reputation, snippet coverage, and benchmark score; use version-specific documentation when a version is specified.
- Call query-docs with a concrete question scoped to one concept. Query distinct concepts separately unless their interaction is the question. Base the answer on the fetched documentation.
- Context7 is unnecessary for general programming concepts, business-logic debugging, code review, refactoring, or scripts that do not need external API documentation. If it is unavailable or insufficient, use official upstream documentation directly and disclose the limitation.

## Third-party dependency versions

- Follow the latest upstream versions by default. Do not add explicit version, tag, or commit pins unless the user requests them.
- For Neovim plugins, use unversioned plugin definitions. The user evaluates and manages updates with fzf-pack.nvim; do not restrict plugins to stable release tags or introduce version constraints.
- Preserve package-manager lockfiles as part of the normal update workflow; their recorded revisions are not a reason to add explicit pins to dependency declarations.
- Verify compatibility with official upstream documentation. Do not silently select an older version or impose a stable-release policy; explain a genuine compatibility conflict before changing the requested approach.

## Temporary directories and permission blocks

- Use temporary directories, caches, and test directories for legitimate task requirements such as builds, downloads, package checks, or isolated tests. Routine authorized uses do not need extra confirmation solely because they create temporary data.
- Never create or relocate repositories, clones, worktrees, caches, or working copies to bypass filesystem or network permissions, sandbox restrictions, or approval requirements.
- When permissions block an action, request the access needed for that original action and explain the exact block. Do not substitute a temporary copy or another location as a workaround.
- Keep project changes in the user's existing repository. Clean up task-specific temporary artifacts when no longer needed; retain useful tool-managed caches.
