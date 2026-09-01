local gh = require("config.utils").gh

vim.pack.add({
	gh("kylechui/nvim-surround"),
})

local ok, surround = pcall(require, "nvim-surround")

if ok then
	surround.setup({})
end
