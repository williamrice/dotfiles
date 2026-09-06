**Neovim configuration review — September 5, 2026**

The foundation is current: native `vim.pack`, `vim.lsp.enable`, `after/lsp` overrides, the rewritten Tree-sitter API, Conform, and modern diagnostic APIs. The biggest improvements are completing partially wired features, making installation reproducible, and adding a deliberate workflow for reviewing AI changes.

**Recommended order:** fix the colorizer and debugger errors; reconcile the lockfile; complete language support; replace Diffview with CodeDiff and expose Gitsigns hunk actions; then replace Spectre and assess the TypeScript stack. Completion and UI migrations are lower priority.

This is a review deliverable. No configuration, plugin installation, or lockfile changes were made. Examples below are proposed changes.

**Scope and evidence**

Reviewed all 55 Lua files, all 54 lockfile entries, installed plugin source where needed, local Neovim documentation, and current primary upstream sources. There are 51 distinct remote plugin declarations plus the local `codecopy.nvim` checkout. The machine reports Neovim **0.12.5, Linux x86_64**.

An isolated headless check parsed all 55 Lua files and reproduced the colorizer module failure. It also inspected merged LSP configuration and native completion capabilities without starting language servers. Installed Git HEADs were compared with the lockfile. A full interactive startup, debugger session, language-project test, and timing benchmark were not performed; findings distinguish confirmed wiring errors from proposed optimizations. Existing `nvim.log` socket-permission warnings alone do not establish a configuration defect. The supplied workspace did not expose usable Git metadata, so its version-control history could not be assessed.

Maintenance checks used GitHub repository metadata, default-branch commits, and project documentation. **“Last push” can include non-default branches; it is not a release date or proof of ongoing support.** Age alone does not make a mature plugin obsolete. New plugin recommendations below have recent activity; dormant components are flagged rather than promoted.

**Highest-priority findings**

| Priority | Finding and local evidence | Recommended action |
| --- | --- | --- |
| High | [Colorizer](lua/plugins/colorizer.lua) calls `require("nvim-colorizer")`. The installed module is `colorizer`; the first fails and the second succeeds. `pcall` hides the failure. | Change to `require("colorizer")`; retain the existing options after checking them against that module. The upstream [installation example](https://github.com/catgoose/nvim-colorizer.lua#installation) uses this name. |
| High | [DAP](lua/plugins/dap.lua) runs both `dap-cs.setup()` and `netcoredbg-macOS-arm64.setup()`. The latter overwrites C# configurations/adapters. Its installed executable is **Mach-O ARM64**, incompatible with this Linux x86_64 host. | Use one platform-appropriate `netcoredbg` adapter definition. Gate any macOS-specific setup on OS and architecture, or remove that wrapper on Linux. Verify the actual executable and launch a small C# program. |
| High | Six installed plugin revisions differ from [the lockfile](nvim-pack-lock.json). | Reconcile intentionally before upgrading further; a fresh install may behave differently from this machine. Details below. |
| High | [LSP activation](after/ftplugin/php.lua) enables HTML only after opening PHP, but [HTML's filetypes](after/lsp/html.lua) are `html` and `twig`, excluding PHP. [Tailwind](after/lsp/tailwindcss.lua) is configured but never enabled. | Enable ordinary servers centrally after setup. Decide separately how PHP/Twig embedded HTML should work; merely calling `enable("html")` from PHP does not attach it to PHP. |
| Medium | [Go debugging](lua/plugins/dap.lua) installs `nvim-dap-go` without calling its setup. `mason-nvim-dap` is also installed without setup. Neither `dlv` nor `netcoredbg` was found on the inspected shell PATH or in Mason's bin directory. | Complete the adapter setup if used, or remove unused helpers. Installing a Lua plugin does not install or configure every debugger executable. |
| Medium | [Mappings](lua/config/keymap.lua) still invoke `Lazy reload codecopy.nvim`, although this configuration uses `vim.pack`. | Remove the dead shortcut or implement a reload command in the local plugin. Normal Neovim restart is the dependable reload path. |
| Medium | [Snippets](lua/plugins/snippet.lua) are loaded and completed, but no explicit LuaSnip placeholder forward/backward mappings are configured. Copilot already owns Shift-Tab. | Add deliberate snippet navigation, for example Ctrl-L/Ctrl-H in insert/select mode after resolving Copilot's Ctrl-L binding. Verify a snippet with multiple placeholders. |
| Medium | [Copilot toggle](lua/config/keymap.lua) tracks a buffer-local boolean while invoking global `Copilot enable/disable`. | Use the plugin's buffer attach/detach toggle for buffer scope, or one global state for global scope. The current state can disagree across buffers. See [Copilot commands](https://github.com/zbirenbaum/copilot.lua). |

**AI code review: recommended workflow**

The missing piece is a clear baseline plus repository-wide review and hunk acceptance. Copilot suggestions cover inserting text; your [Gitsigns configuration](lua/plugins/git.lua) currently exposes almost none of its review actions, while [Diffview](lua/plugins/diffview.lua) supplies the multi-file view.

My preferred replacement is **[esmuellert/codediff.nvim](https://github.com/esmuellert/codediff.nvim)**. Current features include live repository refresh, character-level highlighting, side-by-side/inline layouts, staged review, hunk staging, history, and merge resolution. It downloads a native diff library; confirm platform availability when installing. Its current upstream head is dated September 5, 2026. This is a stronger fit for your stated gap than extending dormant Diffview.

Suggested commands after installing CodeDiff:

| Review task | Command |
| --- | --- |
| All local changes | `:CodeDiff` |
| Proposed commit | `:CodeDiff --staged` |
| Current file against HEAD | `:CodeDiff file HEAD` |
| Branch changes since divergence, including working tree | `:CodeDiff main...` |
| Committed branch changes since divergence | `:CodeDiff main...HEAD` |
| File history | `:CodeDiff history %` |

These follow the current [CodeDiff usage documentation](https://github.com/esmuellert/codediff.nvim#usage); substitute your actual base branch. Start with default options and reuse `<leader>gv` for review. Retain the existing buffer-to-repository root detection, adapting it to CodeDiff's `--repo` option. Inspect its buffer-local mappings before reusing your global Git/Copilot keys.

My proposed review process:

1. Establish a known baseline **before** the agent edits: a deliberate checkpoint commit on a task branch, or a separate worktree from the intended starting commit. Preserve existing human edits explicitly. A viewer cannot retrospectively identify which changes were AI-authored.
2. Review while the agent works if useful, but pause edits before final approval. A hunk can change after you have read it.
3. Save or reconcile modified editor buffers before the final repository review. Inspect new/untracked files as well as modified and deleted files; ignored files need separate attention. Git's ordinary patch output alone omits untracked file contents.
4. Stage only approved hunks. **Staging is selection for a commit, not a durable “reviewed” label or an undo operation.** Later edits can create additional unstaged changes in that file.
5. Run the project's tests/type checks, inspect the final staged diff, and commit only after review. If rejected changes remain unstaged, remember that tests usually run against the working tree, not only the index; test the intended final tree.

Keep rejected edits recoverable until review is complete. Discard/reset actions modify files and can remove human edits when changes overlap. For pasted proposals that have no Git baseline, compare a saved before-file with the proposed file using native `nvim -d` or a scratch-buffer diff.

For small changes, use **Gitsigns already installed**: `preview_hunk_inline`, `nav_hunk`, `stage_hunk`, and `diffthis` cover quick inspection and selection. Add buffer-local mappings through its `on_attach`; preserve native diff navigation in diff windows. Its `blame` and `blame_line` may also replace the separate git-blame plugin if they cover your needs. Your locked Gitsigns revision equals the checked upstream head from August 11, 2026. See [Gitsigns features and usage](https://github.com/lewis6991/gitsigns.nvim).

No additional AI chat/provider integration is necessary to close this gap. The proposed baseline and review process works with any agent that edits the same repository.

**Upstream maintenance and migration decisions**

Dates below were checked on September 5, 2026. Commit links preserve the exact evidence where available.

| Component | Evidence | Decision |
| --- | --- | --- |
| Diffview | Default-branch head [4516612](https://github.com/sindrets/diffview.nvim/commit/4516612fe98ff56ae0415a259ff6361a89419b0a), June 13, 2024; matches your lock. Repository is not archived. | Dormant by observed activity. Updating cannot fix the lack of new upstream work. Replace with CodeDiff. |
| CodeDiff | Head [a9b716f](https://github.com/esmuellert/codediff.nvim/commit/a9b716fb9aa70002cf7a7583148ad31cc7c5fa90), September 5, 2026; latest commit is documentation, with recent [release history](https://github.com/esmuellert/codediff.nvim/releases) showing feature/fix work. | Recommended new diff viewer. |
| Spectre | [Repository metadata](https://api.github.com/repos/nvim-pack/nvim-spectre): last push May 19, 2025; not archived. Local commit is May 13, 2025. | Prefer migrating under your maintenance requirement; do not equate “not archived” with actively developed. |
| grug-far | Head [11595bf](https://github.com/MagicDuck/grug-far.nvim/commit/11595bf747edc270bce2069d1020502ad4ae56cf), August 13, 2026. | Recommended Spectre replacement: search/replace preview, editable results, and optional structural search. It uses ripgrep without Spectre's separate sed replacement engine. See [requirements and usage](https://github.com/MagicDuck/grug-far.nvim). |
| Plenary | [Maintainer notice](https://github.com/nvim-lua/plenary.nvim): no longer actively maintained; stated critical-fix window ended June 30, 2026. API still reports `archived=false`. | Plan to reduce dependency exposure. Do not remove it while consumers require it. |
| typescript-tools | Head [c2f5910](https://github.com/pmizio/typescript-tools.nvim/commit/c2f5910074103705661e9651aa841e0d7eea9932), November 18, 2025; matches your lock. | Evaluate replacing because activity is old and it depends on Plenary. This is a maintenance concern, not a demonstrated TS failure. |
| vtsls server | [Repository metadata](https://api.github.com/repos/yioneko/vtsls): last push September 5, 2026, not archived. | Maintained TS alternative through native LSP and existing nvim-lspconfig. The separate `nvim-vtsls` helper had last push July 16, 2025; it is not part of this recommendation. |
| nvim-treesitter | Head [41416e8](https://github.com/nvim-treesitter/nvim-treesitter/commit/41416e81a6c7f4af4984395bfe0cd8d174e70976), September 5, 2026; not archived. Your lock is September 1. | Continue on the current rewritten API. Search results discussing earlier archival are not the current repository state. |
| Tree-sitter textobjects | [Repository metadata](https://api.github.com/repos/nvim-treesitter/nvim-treesitter-textobjects): last push September 3, 2026. | Your direct `select_textobject` calls fit the new API; do not revert to old `configs.setup` recipes. |
| nvim-cmp | [Repository metadata](https://api.github.com/repos/hrsh7th/nvim-cmp): last push July 9, 2026. | Existing completion is not automatically obsolete. Fix integration gaps before replacing it. |
| blink.cmp | Head [8e5e03f](https://github.com/saghen/blink.cmp/commit/8e5e03f1ef7991d74950c245910e6118f6d95e3b), September 4, 2026, marked as a breaking refactor. | Optional consolidation, using a reviewed current release and its matching docs rather than tracking a changing main branch blindly. |
| Conform / Copilot / Roslyn / nvim-dap | API last pushes: [Conform](https://api.github.com/repos/stevearc/conform.nvim) August 11; [Copilot](https://api.github.com/repos/zbirenbaum/copilot.lua) August 26; [Roslyn](https://api.github.com/repos/seblyng/roslyn.nvim) August 13; [DAP](https://api.github.com/repos/mfussenegger/nvim-dap) September 2, 2026. None archived. | Repair configuration and retain these core components. |

Plenary consumers confirmed in installed source include Neo-tree, TypeScript Tools, Spectre, and the LazyGit wrapper. Diffview documents it as a dependency too. Replacing Diffview/Spectre/TypeScript Tools will reduce exposure but **will not eliminate it**. For the LazyGit wrapper, a native terminal mapping can launch the already installed CLI without another integration plugin. Follow Neo-tree's dependency changes before attempting to remove Plenary.

The remaining UI and editing plugins were reviewed for configuration gaps, but this report does not certify fresh upstream activity for every leaf dependency. No wholesale UI replacement is justified by this audit.

**Installation, loading, and reproducibility**

Your [loader](lua/config/plugins.lua) immediately requires each module returned by `readdir`. Each module installs/adds its own packages and usually calls setup. This is eager configuration; comments saying DAP is lazy and `pcall(require, ...)` do not make it lazy.

Prefer a two-phase structure: declare/add the full dependency set first, then run setup in an explicit order. Configure leader/basic options before setup, Mason before server/debugger setup, and shared dependencies before their consumers. In the current filename order DAP runs before Mason, while Diffview is explicitly loaded with `load=true` before Plenary is declared later. These are avoidable ordering hazards, especially on a clean install. Default `vim.pack.add` during init makes modules available while deferring plugin scripts; forcing `load=true` changes that behavior. See local `:help vim.pack.add()` and [native package documentation](https://neovim.io/doc/user/pack/).

Keep `vim.pack`; switching package managers is not needed. Document the supported Neovim version, explicit update/restart procedure, external tools, and build hooks. Grouping installation also lets native parallel installation work across the whole list. Only introduce deferred DAP/image setup after a startup profile demonstrates a worthwhile cost. Do not lazy-load Tree-sitter contrary to its [current setup guidance](https://github.com/nvim-treesitter/nvim-treesitter).

The following mismatch is confirmed, not an inference from commit age:

| Plugin | Lockfile revision | Installed HEAD |
| --- | --- | --- |
| LuaSnip | `a62e108` | `0abc8f3` |
| lualine | `8811f3f` | `221ce6b` |
| Mason | `44d1e90` | `2a6940a` |
| nvim-surround | `9291040` | `8b47db6` |
| nvim-ts-autotag | `8e1c0a3` | `88c1453` |
| Plenary | `b9fd522` | `74b06c6` |

Choose which state is intended, inspect the relevant changes, and use the native manager to synchronize. `vim.pack.add()` does not automatically enforce the lock revision on an existing checkout. For restoring the recorded state, local help documents `vim.pack.update(nil, { target = "lockfile" })` with review/confirmation. Check for local plugin modifications first; restarting verifies the selected state. Track the resulting lockfile alongside the configuration.

`blink.cmp`, `friendly-snippets`, and `mason-tool-installer.nvim` are locked and installed but absent from active declarations. Their presence is not evidence they are configured. Either declare/setup them deliberately or remove them through the manager once unused. In particular, the VS Code snippet loader does not make an inactive optional package appear on runtimepath.

Change Mason's old `williamboman/mason.nvim` source to the canonical [mason-org/mason.nvim](https://github.com/mason-org/mason.nvim) during a controlled update. Native pack treats a source change as a replacement/reinstall, even when GitHub redirects both URLs to the same project. The `dependencies = {}` inside `mason.setup` is not a plugin-manager dependency declaration and can be removed.

Avoid silent failure for required plugins. A short error containing the module name is more useful than `if ok then ... end`; colorizer demonstrates the current failure mode. In [git.lua](lua/plugins/git.lua), initialize Gitsigns independently of git-blame so failure of one does not suppress both.

**Language tooling and parser coverage**

| Area | Gap | Proposed improvement |
| --- | --- | --- |
| Server activation | `vim.lsp.enable` is scattered through ftplugins; only some configured/installed servers are enabled. | Centralize ordinary server activation once. Native LSP still attaches by filetype/root; enabling centrally does not start every server in every buffer. Keep Roslyn and TypeScript provider setup coordinated to avoid duplicate clients. |
| HTML/Twig | HTML activation depends on opening PHP first. Twig's dedicated server is installed but not enabled. | Enable HTML independently, then choose HTML plus Twig-specific support appropriate to actual templates. |
| Tailwind | Effective filetypes are only `html`, `css`, `javascript`, `typescript`; TSX/JSX and Twig are excluded despite `includeLanguages.twig`. | Restore/extend the upstream filetype coverage and enable the server. Remove unnecessary root overrides. The installed upstream `root_dir` function remains effective, so the two local `root_markers` do **not** by themselves prove v4 root detection is broken. Verify a v4 CSS-entrypoint project and a v3 config-based project against [Tailwind's project detection requirements](https://github.com/tailwindlabs/tailwindcss-intellisense). |
| Go | The override restricts gopls to `go`/`gomod`; activation comes only from `go.lua`. | Preserve upstream filetype coverage if using `go.work` or templates. Enable once. Consider import-aware formatting when import management is a recurring issue. |
| Shell | `bashls` lists zsh, but activation is only in `sh.lua`; Bash language semantics also do not fully model zsh. | Separate shell-language expectations and verify attachment using the actual detected filetype. |
| Python/Astro/Prisma/Docker | Several servers are installed in Mason without any activation in the config. Python formatters exist despite no Python LSP activation. | Enable only languages actually used; document the others as intentionally unsupported or remove unused tooling. Avoid treating Mason installation as server activation. |
| JS/TS linting | TypeScript tooling supplies TS diagnostics; no ESLint server/lint workflow is configured. | If projects use ESLint, enable the existing nvim-lspconfig ESLint definition with project-local ESLint and appropriate code-action behavior. A formatter is not a linter. |
| Tree-sitter | Parsers are installed for JS/TS/TSX/HTML/JSON/YAML/etc., but explicit starts exist only for selected filetypes. Native Lua ftplugin already starts its bundled parser. | Add a guarded FileType policy for supported parsers. Installing parsers does not itself enable highlighting everywhere. Include Twig if needed; its parser is missing from the requested list. |
| Parser lifecycle | `treesitter.install(...)` runs asynchronously at startup; no explicit post-update parser synchronization is configured. | Use intentional installation/update commands or a `PackChanged` hook, update parsers alongside queries, and handle missing parsers gracefully on first run. Repeated install calls do not mean every parser recompiles every startup. |

The modern [nvim-lspconfig guidance](https://github.com/neovim/nvim-lspconfig) endorses `vim.lsp.config`/`vim.lsp.enable`; nvim-lspconfig itself remains useful as the server-definition collection. Your use of `after/lsp` is appropriate.

For TypeScript migration, use the maintained **vtsls server** with the [existing native definition](https://github.com/neovim/nvim-lspconfig/blob/master/lsp/vtsls.lua), then test source definition, rename/import edits, inlay hints, JSX/TSX, and monorepo roots. Replace `TSToolsGoToSourceDefinition` explicitly; commands/settings are not interchangeable. Remove TypeScript Tools activation when switching. The [server documentation](https://github.com/yioneko/vtsls) describes the supported capabilities; do not assume the older optional Neovim helper is required.

In [PHP settings](lua/config/php-settings.lua), the huge global stub list includes obsolete extensions and WordPress/ACF for every project. Narrow it to actual runtimes/frameworks and set the project's PHP version deliberately. This improves diagnostic relevance; the performance benefit has not been measured. Global Composer include paths can be useful, but project dependencies should remain the primary source of types. `/usr/include/php` is inserted without checking existence, unlike the Composer paths. The 10 MB indexing allowance should be an intentional exception for generated files.

**Completion, snippets, and formatting**

Keep nvim-cmp initially. [Its configuration](lua/plugins/cmp.lua) lacks a filesystem path source, explicit snippet navigation, and cmp/autopairs confirmation integration. Add these only where useful. No code calls `cmp_nvim_lsp.default_capabilities`; merge the completion engine's capabilities into native LSP configuration before enabling servers if you want its full advertised completion behavior. **Do not diagnose missing snippet support solely from this omission:** Neovim 0.12.5 already advertises `snippetSupport=true`, confirmed locally.

[Blink](https://github.com/saghen/blink.cmp) is an optional maintained way to consolidate completion sources and UI. Its unused lock entry is not an active migration. If adopting it, test LuaSnip, lazydev, Copilot coexistence, path completion, documentation scrolling, and Enter acceptance before removing cmp sources. Use the current release documentation and account for the fuzzy matcher binary/build requirements; recent main-branch breaking changes make blind updates inappropriate.

[LuaSnip setup](lua/plugins/snippet.lua) replaces React filetype sets with only `react`; extend rather than replace if base JS/TS snippets should remain available. Review the bidirectional PHP/HTML extension, which broadens both snippet sets. `jsregexp` is optional but needed for certain snippet transformations; add a native package build hook if those snippets require it. Your hand-written snippets do not establish that requirement by themselves.

Both [Conform setup](lua/plugins/conform.lua) and [manual format mapping](lua/config/keymap.lua) use the legacy `lsp_fallback = true`. The installed Conform still translates it, so this is modernization rather than a present failure. Use `lsp_format = "fallback"` and consolidate shared formatting options with `default_format_opts`. `async=false` is redundant in the synchronous save hook. See [Conform configuration](https://github.com/stevearc/conform.nvim).

The one-second formatting timeout can interrupt slower PHP/Python tools. Measure typical saves and use per-filetype limits; blanket asynchronous formatting can introduce its own review surprises. Prefer project-local formatter versions/configs for reproducible AI diffs. Astro formatting requires the appropriate Prettier plugin in the project. C# currently relies on LSP fallback rather than a named formatter; verify that intentionally.

`<leader>sf` runs `:noautocmd write`, bypassing **all** write autocmds. Implement a Conform buffer-level format-on-save toggle when the intent is only to skip formatting. Add `.editorconfig` or equivalent project settings to prevent global tabs/two-space assumptions from causing unrelated whitespace changes.

**Mappings, UI, and performance cleanup**

| Location | Recommendation |
| --- | --- |
| [keymap.lua](lua/config/keymap.lua), [options.lua](lua/config/options.lua) | `<leader>f` formats but is also the prefix of `ff`, `fs`, etc. With `timeoutlen=5000`, it can wait up to five seconds. Give format a non-prefix key such as `<leader>cf`, then tune timeout to preference. |
| LSP mappings | Move `ca` and `rn` under a leader or use native `gra`/`grn` conventions; they intercept normal editing prefixes. Mapping `gr` also prefixes native `gr*` LSP mappings. Keep custom LSP maps buffer-local where appropriate. |
| Copilot mappings | `<C-[>` normally acts as Escape in terminals and may be indistinguishable from the configured Escape dismissal. Verify this before relying on it for previous suggestion. Resolve Ctrl-L and Shift-Tab ownership with snippets. |
| Copilot exclusion | The `.env*` exclusion only runs when the filetype is `sh`. If excluding these files is intended, make the filename predicate apply regardless of detected filetype. |
| [codecopy.lua](lua/plugins/codecopy.lua) | Replace the hard-coded `/home/warice/dev/codecopy.nvim` with a configurable path and check existence. Its source is outside this config and its maintenance/behavior was not audited. Document it as a local dependency. |
| Git comparison prompt | Pass structured arguments to the plugin API rather than concatenating user input into `vim.cmd("DiffviewOpen " .. input)`. Handle cancel/empty input and filenames with spaces. |
| [bufferline.lua](lua/plugins/bufferline.lua) | `seperator` is misspelled; the option is `separator`. Verify whether an offset is useful with the explorer configured as a float. |
| [neo-tree.lua](lua/plugins/neo-tree.lua) | netrw is disabled while directory hijacking is also disabled. Decide what `nvim .` should do and configure/test that entry point. Showing gitignored files except a short denylist can expose large build/vendor trees. |
| [lualine.lua](lua/plugins/lualine.lua) | Client/formatter/diagnostic lists are each calculated in both `cond` and display callbacks. Remove duplicate work or cache on relevant events if profiling shows cost. The “linters” component shows diagnostic sources with current findings, not all enabled linters. |
| [markdown.lua](lua/plugins/markdown.lua) | `max_file_size=10.0` matches the installed plugin default; the “100KB default” comment is stale. Rendering in insert mode is a preference; test large generated Markdown before lowering thresholds. `RenderMarkdown preview` is valid in the installed version. |
| [colorscheme.lua](lua/plugins/colorscheme.lua) | Reapply custom highlights on `ColorScheme` if themes can change during a session. |
| Basic options | `backspace`, `hidden`, and several indent options repeat modern defaults. Remove redundant settings for readability when desired. `hlsearch=false` makes the clear-highlights mapping mostly redundant. |
| Diagnostics | Native `virtual_lines` limited to the current line is worth trying if inline diagnostic text is crowded; no additional diagnostics plugin is necessary. |

There is no configured project test/task workflow. Start with native terminal or `:make`/quickfix integration for the languages you actually use, then consider a test UI only if that workflow proves inadequate. Debugger UI and formatting do not replace type checks and tests for AI edits.

**External dependencies and validation plan**

The inspected shell has `fzf`, `rg`, `delta`, `lazygit`, Node, Go, .NET, ImageMagick, tree-sitter CLI, and a C compiler. This establishes executable presence, not compatibility or successful use inside every Neovim launch environment. Mason contains many servers/formatters, but there is no active install manifest. Document required packages and project-local dependencies. Image rendering additionally depends on terminal graphics support; test it in the terminal/tmux combination actually used. Copilot's installed documentation requires Node 22 or newer; the inspected Node path is v25.8.2.

After implementing recommendations, validate in this order:

1. Start normally and inspect `:messages`; run relevant `:checkhealth` providers and `:ConformInfo`. Confirm failures are visible.
2. Open HTML/Twig, TSX, PHP, Go, Python (if supported), and C# directly in fresh sessions. Check `:checkhealth vim.lsp`, actual attached clients, completion, parser highlighting, formatting, and roots. HTML should not depend on opening PHP first.
3. Exercise C# and Go debugger launch/stop against tiny real projects. Check executable architecture and adapter paths.
4. In a disposable Git repository, review a modified file, new file, deletion, rename, staged/unstaged split, external edit, and merge conflict. Test both hunk selection and the final staged diff. Confirm unsaved buffers and untracked files are handled as expected.
5. Profile startup only after correctness fixes, comparing the same workload. Optimize measured hot paths rather than plugin count alone.
6. Test a fresh install with isolated XDG config/data/state/cache directories, using the reconciled lockfile. Verify parser/native-library installation, local-plugin fallback, and executable provisioning.

The first implementation pass should be small: correct confirmed errors and tool activation, then establish CodeDiff plus Gitsigns review. Search/replace and TypeScript migrations can follow independently, making regressions easier to identify.
