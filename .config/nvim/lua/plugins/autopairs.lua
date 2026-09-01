local gh = require("config.utils").gh

vim.pack.add({
	gh("windwp/nvim-autopairs"),
})

local ok, autopairs = pcall(require, "nvim-autopairs")

if ok then
	autopairs.setup({
		disable_filetype = { "TelescopePrompt", "vim" },
	})
end
