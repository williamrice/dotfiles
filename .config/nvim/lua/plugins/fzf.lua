require("fzf-lua").setup({
	files = {
		git_icons = true,
	},
	lsp = {
		code_actions = {
			previewer = "codeaction_native",
			preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style=omit --file-style=omit",
		},
	},
})
require("fzf-lua").register_ui_select()
