local gh = require("config.utils").gh

vim.pack.add({
	gh("windwp/nvim-ts-autotag"),
})

local ok, autotag = pcall(require, "nvim-ts-autotag")

if ok then
	autotag.setup({})
end
