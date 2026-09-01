local gh = require("config.utils").gh

vim.pack.add({
	gh("neovim/nvim-lspconfig"),
	gh("williamboman/mason.nvim"),
	gh("j-hui/fidget.nvim"),
})

local ok, mason = pcall(require, "mason")

if ok then
	mason.setup({
		registries = {
			"github:mason-org/mason-registry",
			"github:Crashdummyy/mason-registry",
		},
		dependencies = {},
	})
	require("fidget").setup({})
end
