vim.lsp.enable("intelephense")
vim.lsp.enable("html")

vim.treesitter.start()
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
