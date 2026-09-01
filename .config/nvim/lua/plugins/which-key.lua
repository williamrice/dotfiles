local gh = require("config.utils").gh

vim.pack.add({
	gh("folke/which-key.nvim"),
})

local ok, wk = pcall(require, "which-key")

if ok then
	wk.setup({
		preset = "modern",
		delay = 500,
		spec = {
			-- Group definitions
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git/LSP navigation" },
			{ "<leader>n", group = "NPM package info" },
			{ "<leader>s", group = "Split/Search/Save" },
			{ "<leader>t", group = "Tab/Buffer management" },
			{ "<leader>x", group = "Diagnostics (Trouble)" },
			{ "<leader>d", group = "Debug (DAP)" },
			{ "<leader>c", group = "Code/Copilot" },
			{ "<leader>w", group = "Which-key" },
			{ "<leader>m", group = "Markdown" },
		},
	})
end
