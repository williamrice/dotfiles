local gh = require("config.utils").gh

vim.pack.add({
	gh("folke/lazydev.nvim"),
})

require("lazydev").setup({
	library = {
		-- See the configuration section for more details
		-- Load luvit types when the `vim.uv` word is found
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})
