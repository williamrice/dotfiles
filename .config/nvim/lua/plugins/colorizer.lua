local gh = require("config.utils").gh

vim.pack.add({
	gh("catgoose/nvim-colorizer.lua"),
})

local ok, colorizer = pcall(require, "nvim-colorizer")

if ok then
	colorizer.setup({
		parsers = {
			names = {
				enable = false,
			},
		},
	})
end
