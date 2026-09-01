local gh = require("config.utils").gh

vim.pack.add({
	gh("folke/trouble.nvim"),
})
local ok, trouble = pcall(require, "trouble")

if ok then
	trouble.setup({
		auto_close = true,
	})
end

vim.diagnostic.config({
	virtual_text = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "if_many",
		header = "",
		prefix = "",
	},
})
