require("bufferline").setup({
	options = { diagnostics = "nvim_lsp", show_close_icon = false, separator_style = "thin" },
})

require("lualine").setup({ extensions = { "nvim-tree", "trouble" } })
require("trouble").setup({ auto_close = true })
require("package-info").setup({})
require("which-key").setup({
	preset = "modern",
	delay = 400,
	spec = {
		{ "<leader>c", group = "Code" }, { "<leader>d", group = "Debug" },
		{ "<leader>f", group = "Find" }, { "<leader>g", group = "Git" },
		{ "<leader>m", group = "Markdown" }, { "<leader>n", group = "Packages" },
		{ "<leader>s", group = "Split/Search" }, { "<leader>t", group = "Tabs/Buffers" },
		{ "<leader>x", group = "Diagnostics" },
	},
})

vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
	float = { focusable = false, border = "rounded", source = "if_many", header = "", prefix = "" },
})
