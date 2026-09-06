require("mason").setup({ registries = { "github:mason-org/mason-registry", "github:Crashdummyy/mason-registry" } })
require("mason-tool-installer").setup({
	ensure_installed = {
		"astro-language-server", "bash-language-server", "black", "blade-formatter", "css-lsp",
		"delve", "docker-compose-language-service", "dockerfile-language-server", "gopls", "html-lsp", "intelephense",
		"isort", "lua-language-server", "netcoredbg", "php-cs-fixer", "prettier", "prisma-language-server",
		"pyright", "roslyn", "ruff", "shfmt", "stylua", "tailwindcss-language-server",
		"twiggy-language-server", "vtsls",
	},
	auto_update = false,
	run_on_start = true,
})

require("lazydev").setup({ library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } })
require("fidget").setup({})
require("roslyn").setup({})

vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
vim.lsp.enable({
	"astro", "bashls", "cssls", "dockerls", "docker_compose_language_service", "gopls", "html",
	"intelephense", "lua_ls", "prismals", "pyright", "tailwindcss", "twiggy_language_server", "vtsls",
})
