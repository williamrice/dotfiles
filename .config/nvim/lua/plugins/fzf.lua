local gh = require("config.utils").gh

vim.pack.add({
	gh("ibhagwan/fzf-lua"),
})

require("fzf-lua").setup({
	lsp = {
		code_actions = {
			previewer = "codeaction_native",
			preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style=omit --file-style=omit",
		},
	},
})
require("fzf-lua").register_ui_select()
