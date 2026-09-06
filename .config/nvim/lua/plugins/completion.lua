local cmp = require("blink.cmp")

if not cmp.library_available() then
	vim.notify("Building Blink v2 fuzzy matcher...", vim.log.levels.INFO)
	cmp.build():pwait(120000)
end

cmp.setup({
	keymap = {
		preset = "default",
		["<CR>"] = { "accept", "fallback" },
		["<C-j>"] = { "scroll_documentation_down", "fallback" },
		["<C-k>"] = { "scroll_documentation_up", "fallback" },
	},
	snippets = { preset = "luasnip" },
	sources = { default = { "lsp", "path", "snippets", "buffer", "lazydev" } },
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 300 },
		list = { selection = { preselect = false, auto_insert = false } },
	},
	signature = { enabled = true },
	fuzzy = { implementation = "rust" },
})
