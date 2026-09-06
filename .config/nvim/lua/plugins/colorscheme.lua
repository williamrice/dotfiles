vim.cmd.colorscheme("carbonfox")
local function highlights()
	vim.api.nvim_set_hl(0, "Visual", { bg = "#235c63", fg = "NONE" })
	vim.api.nvim_set_hl(0, "@punctuation.bracket.php", { fg = "#cb9405", bold = true })
end
highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = highlights })
