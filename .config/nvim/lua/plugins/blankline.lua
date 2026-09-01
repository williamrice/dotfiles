local gh = require("config.utils").gh

vim.pack.add({
	gh("lukas-reineke/indent-blankline.nvim"),
})

local ok, ibl = pcall(require, "ibl")

if ok then
	ibl.setup({})
end
