local gh = require("config.utils").gh

vim.pack.add({
	gh("3rd/image.nvim"),
})

local ok, image = pcall(require, "image")

if ok then
	image.setup({
		processor = "magick_cli",
	})
end
