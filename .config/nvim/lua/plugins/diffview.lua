local gh = require("config.utils").gh

vim.pack.add({
	gh("sindrets/diffview.nvim"),
}, { load = true })

local ok, diffview = pcall(require, "diffview")

if ok then
	diffview.setup()
end
