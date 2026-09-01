local gh = require("config.utils").gh

vim.pack.add({
	gh("nvim-treesitter/nvim-treesitter"),
	gh("nvim-treesitter/nvim-treesitter-textobjects"),
})

local ok, treesitter = pcall(require, "nvim-treesitter")

if ok then
	treesitter.install({
		"bash",
		"blade",
		"c_sharp",
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"javascript",
		"html",
		"css",
		"tsx",
		"json",
		"php",
		"php_only",
		"typescript",
		"markdown",
		"markdown_inline",
		"yaml",
		"toml",
		"dockerfile",
		"gitignore",
	})

	require("nvim-treesitter-textobjects").setup({
		select = {
			lookahead = true,
		},
	})
end
