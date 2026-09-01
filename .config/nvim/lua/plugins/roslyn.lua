local gh = require("config.utils").gh

vim.pack.add({
	gh("seblyng/roslyn.nvim"),
})

local ok, roslyn = pcall(require, "roslyn")

if ok then
	roslyn.setup({})
end
