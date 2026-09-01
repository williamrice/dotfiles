local gh = require("config.utils").gh

vim.pack.add({
	gh("EdenEast/nightfox.nvim"),
})

vim.cmd.colorscheme("carbonfox")
vim.api.nvim_set_hl(0, "Visual", { bg = "#235c63", fg = "NONE" })
vim.api.nvim_set_hl(0, "@punctuation.bracket.php", { fg = "#cb9405", bold = true })
