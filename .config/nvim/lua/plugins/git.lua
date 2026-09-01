local gh = require("config.utils").gh

vim.pack.add({
	gh("lewis6991/gitsigns.nvim"),
	gh("f-person/git-blame.nvim"),
})

local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
local gitblame_ok, gitblame = pcall(require, "gitblame")

if gitsigns_ok and gitblame_ok then
	gitsigns.setup({})
	gitblame.setup({
		enabled = false,
	})
end
