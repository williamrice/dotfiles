**Neovim rebuild plan — September 6, 2026**

Decision: use native **vim.pack**, with a modular configuration and explicitly chosen dependencies. Retain familiar workflows while adopting CodeDiff, removing runtime Plenary dependencies, and moving formatting to `<leader>cf`.

**Branch and baseline.** The bare dotfiles repository is `~/.dotfiles`, with work tree `~`. Planning branch `nvim-pack-rebuild` was created from `main` at `f2be9d4`; `main` and the pre-existing `nvim-rewrite` branch were preserved. No plugin/configuration implementation or package update has run.

Git reports these existing untracked files: `README.md`, `after/ftplugin/go.lua`, `after/lsp/gopls.lua`, `lua/plugins/codecopy.lua`, `lua/plugins/diffview.lua`, and `nvim.log`. A branch does not preserve untracked files or installed plugin state. Before implementation, snapshot the complete working configuration and record installed revisions/local plugin modifications. Include intended configuration files in a baseline commit on the rebuild branch; keep logs out of that commit. Scope staging to Neovim paths through the bare repository.

The rebuild must run with a separate config checkout and separate data/state/cache directories. Switching Git branches alone cannot roll back updated plugin installations. Establish an isolated launcher before changing the working editor.

**Selected stack and remaining choices**

| Choice | Selection | Implementation notes |
| --- | --- | --- |
| Navigation | **fzf-lua + nvim-tree**, selected by the user. | Preserve search mappings, reveal-current-file and directory launch behavior; replace Neo-tree. |
| Completion | **Blink v2 + blink.lib + LuaSnip**, selected by the user. | Target v2 directly during the rewrite. Keep Copilot suggestions separate and remove nvim-cmp after verifying parity. |
| UI | Begin with the existing Carbonfox theme and a simple statusline. | Decide buffer tabs, expanded notifications, images, and key hints after the editing workflow works. No wholesale UI package selection yet. |

The selected navigation setup has no Plenary requirement in its documented installation. Verify the selected revisions and optional integrations before accepting the dependency graph. Use [nvim-tree documentation](https://github.com/nvim-tree/nvim-tree.lua) and the [Blink v2 documentation](https://main.cmp.saghen.dev/installation), which tracks development separately from the v1 site.

**Blink v2 implementation contract**

V1.10.2 is the stable release from April 4, 2026; the `v1` branch still points to that release. The user explicitly selected v2 development to adopt the new API during this rewrite. V1 remains upstream's stable recommendation, but is not the implementation target.

| Area | V1 | Selected v2 behavior |
| --- | --- | --- |
| Neovim | 0.10+ | 0.12+; this machine's 0.12.5 qualifies. |
| Dependency | No blink.lib requirement | Add `saghen/blink.lib` before Blink setup. |
| Native build | Direct Cargo build; release binaries supported | Use `require('blink.cmp').build():pwait()`; native output moves to `lib/`. |
| Binary configuration | `prebuilt_binaries` options | Removed; use the download API when matching artifacts exist. |
| Mappings/API | Older scheduling and mapping behavior | All-mode buffer-local mappings; API calls return execution results directly. |
| LuaSnip | V1 docs recommend its v2 release line | Supports LuaSnip main; remove the obsolete `prefer_doc_trig` option. |

These are primarily integration changes, not evidence of a new everyday completion feature set. Sources: [upgrade guide](https://github.com/saghen/blink.cmp/blob/main/UPGRADE.md), [v1 installation](https://cmp.saghen.dev/installation), and [v1 snippet guidance](https://cmp.saghen.dev/configuration/snippets).

Native package specs will select `version = 'main'` for Blink v2 and blink.lib. Record tested revisions in `nvim-pack-lock.json`; branch selection does not mean automatic updates at startup. Initial candidates observed September 6: Blink `49d39fda6350d7f789d1da1053e86c9e256f8108`, blink.lib `f55df8a6e0a7acccf45ef0ffbb4ce46110fcf7d0`. They are research candidates, not yet a tested compatible pair.

Build after the full dependency set is available and before completion setup. Register lifecycle hooks before package operations, but do not run a dependency-sensitive install callback before blink.lib has been added; queue build work until dependencies are available. Surface build failures, await completion, and avoid recompiling an unchanged native library on routine startup. Check the Rust toolchain required by the selected source. Test clean install, warm startup and updates together. The [blink.lib README](https://github.com/saghen/blink.lib) describes its native-library APIs and notes their current instability.

Verify LSP/path/buffer completion, LuaSnip placeholders, documentation scrolling, command-line completion, lazydev integration, and Copilot mapping ownership. Defer removal of old completion packages until those workflows pass in the isolated rebuild.

**Implementation sequence — six reviewable stages**

| Stage | Work | Completion check |
| --- | --- | --- |
| 1. Protect the baseline | Preserve tracked/untracked configuration and plugin state; establish isolated launch and rollback. | Daily Neovim still works; the rebuild uses different plugin storage. |
| 2. Build the native foundation | Separate package declarations, lifecycle hooks, setup, and core options; use explicit setup order. | Fresh install and subsequent startup work without filename-order dependencies or repeated builds. |
| 3. Restore editing and navigation | Implement the chosen explorer/picker/completion stack, snippets, formatting, theme, and essential mappings. | File search, directory operations, completion, snippet jumps, and file/range formatting work. |
| 4. Add Git and AI review | CodeDiff, Gitsigns hunk actions, grug-far, and native terminal launch for LazyGit. | Modified/new/deleted/renamed files, staged changes, external edits, and partial hunk staging work in a disposable repository. |
| 5. Restore language workflows | Central native LSP activation, vtsls, PHP/Twig/Tailwind, Roslyn, Go, Lua, shell, parsers, and OS-correct DAP adapters. | Representative projects pass completion, navigation, diagnostics, formatting and supported debugger checks. |
| 6. Remove leftovers and promote | Audit every dependency, including local codecopy; remove Plenary and obsolete consumers; reconcile the lockfile; document tools and keys. | Clean install with Plenary absent; relevant health checks and daily workflows pass; merge only after review. |

Python, Astro, Prisma and Docker support should be enabled according to actual use. Installed Mason packages alone do not define the supported language set.

**Native architecture**

Proposed responsibilities:

```text
init.lua                    entry point
lua/config/options.lua      leader and core settings first
lua/config/packages.lua     complete vim.pack package declarations
lua/config/package-hooks.lua installation/update hooks
lua/config/setup.lua        explicit subsystem setup order
lua/config/keymap.lua        editor-wide mappings
lua/config/autocmds.lua      editor-wide events
lua/plugins/*.lua           focused configuration modules
after/lsp/*.lua             server-specific overrides
after/ftplugin/*.lua        buffer-local editing settings
nvim-pack-lock.json         manager-generated, tracked revisions
```

Register needed install hooks before the first package operation; add dependencies before running consumer setup. Initialize Mason before dependent server/debugger configuration. Keep plugin scripts' loading behavior explicit and required-plugin errors visible. Begin with straightforward startup loading; defer optional features only when profiling justifies the complexity.

Use `PackChanged` for appropriate installation/update work, not unconditional compilation at every startup. Keep `vim.pack.update()` an intentional review operation. Do not hand-edit the lockfile or copy lazy.nvim-specific dependency/build fields into native specs. These decisions follow the installed Neovim 0.12.5 `:help vim.pack` and [native package documentation](https://neovim.io/doc/user/pack/). Online documentation may describe newer APIs; installed help is the compatibility reference.

**Proposed retained/replacement stack**

| Workflow | Plan |
| --- | --- |
| Repository review | CodeDiff replaces Diffview; Gitsigns handles in-buffer hunk actions and blame. |
| Search/replace | grug-far replaces Spectre. |
| TypeScript | Maintained vtsls server through nvim-lspconfig; remove TypeScript Tools and avoid its older optional helper. |
| Language infrastructure | Native LSP + nvim-lspconfig + Mason; Conform handles formatting. |
| Parsing/textobjects | Current nvim-treesitter and textobjects APIs, with deliberate parser updates and guarded activation. |
| C# | Roslyn for LSP; nvim-dap with a platform-correct adapter, optionally dap-ui. |
| Git terminal | Keep the LazyGit CLI; remove lazygit.nvim wrapper. |
| Copilot/snippets | Keep separate suggestions and LuaSnip; explicitly assign accept/dismiss/placeholder keys and fix toggle scope. |
| Markdown | Retain render-markdown if useful. Reassess image support separately. |

Plenary removal includes **Neo-tree, Diffview, Spectre, TypeScript Tools, and the LazyGit wrapper**, plus any additional consumer found in the final audit. Existing plugin names do not earn automatic inclusion.

**Maintenance evidence**

Checked September 6, 2026 using GitHub API and upstream documentation. All entries below were unarchived. Dates are repository last-push dates unless stated; pushes can include other branches and are not proof of future support.

| Candidate | Activity observed |
| --- | --- |
| [fzf-lua](https://api.github.com/repos/ibhagwan/fzf-lua) | September 1, 2026 |
| [nvim-tree](https://api.github.com/repos/nvim-tree/nvim-tree.lua) | August 12, 2026; default-branch bug-fix commit August 4 |
| [Oil](https://api.github.com/repos/stevearc/oil.nvim) | June 2, 2026; checked head is a documentation change |
| [Snacks](https://api.github.com/repos/folke/snacks.nvim) | May 25, 2026; checked head is generated documentation |
| [Blink](https://api.github.com/repos/saghen/blink.cmp) / [nvim-cmp](https://api.github.com/repos/hrsh7th/nvim-cmp) | September 6 / July 9, 2026 |
| [CodeDiff](https://api.github.com/repos/esmuellert/codediff.nvim) / [Gitsigns](https://api.github.com/repos/lewis6991/gitsigns.nvim) | September 6 / August 11, 2026 |
| [grug-far](https://api.github.com/repos/MagicDuck/grug-far.nvim) | August 13, 2026 |
| [nvim-lspconfig](https://api.github.com/repos/neovim/nvim-lspconfig) / [Mason](https://api.github.com/repos/mason-org/mason.nvim) | September 4 / June 19, 2026 |
| [Conform](https://api.github.com/repos/stevearc/conform.nvim) / [vtsls](https://api.github.com/repos/yioneko/vtsls) | August 11 / September 6, 2026 |
| [Tree-sitter](https://api.github.com/repos/nvim-treesitter/nvim-treesitter) / [textobjects](https://api.github.com/repos/nvim-treesitter/nvim-treesitter-textobjects) | September 5 / September 3, 2026 |
| [Roslyn](https://api.github.com/repos/seblyng/roslyn.nvim) / [nvim-dap](https://api.github.com/repos/mfussenegger/nvim-dap) / [dap-ui](https://api.github.com/repos/rcarriga/nvim-dap-ui) | August 13 / September 2 / July 14, 2026 |
| [LuaSnip](https://api.github.com/repos/L3MON4D3/LuaSnip) / [Copilot](https://api.github.com/repos/zbirenbaum/copilot.lua) | May 19 / September 6, 2026 |
| [Nightfox](https://api.github.com/repos/EdenEast/nightfox.nvim) / [lualine](https://api.github.com/repos/nvim-lualine/lualine.nvim) / [render-markdown](https://api.github.com/repos/MeanderingProgrammer/render-markdown.nvim) | July 4 / May 31 / August 11, 2026 |

Prefer supported releases where available and reviewed commits otherwise. “Current” does not require tracking a breaking development branch. Check release compatibility, maintenance notices, and transitive dependencies again when installing. Quiet mature plugins and explicitly discontinued projects should not be treated as equivalent.

**Existing project**

The [private modernization project](https://github.com/users/williamrice/projects/2) remains relevant. Start with baseline task #1 and [native loading task #13](https://github.com/williamrice/dotfiles/issues/13), then CodeDiff #2 and formatting #3. The earlier task bodies name a proposed branch; `nvim-pack-rebuild` is the actual planning branch. Explorer task #6 targets nvim-tree with fzf-lua retained; completion task #11 targets Blink v2, blink.lib and LuaSnip with Copilot integration.
