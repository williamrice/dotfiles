local gh = require("config.utils").gh

vim.pack.add({
	gh("nvim-pack/nvim-spectre"),
})

local ok, spectre = pcall(require, "spectre")

if ok then
	spectre.setup({})
end
