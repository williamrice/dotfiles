require("nvim-tree").setup({
	disable_netrw = true,
	hijack_netrw = true,
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
	update_focused_file = { enable = true, update_root = false },
	view = { width = 34, preserve_window_proportions = true },
	renderer = { group_empty = true, highlight_git = "name", indent_markers = { enable = true } },
	filters = { dotfiles = false, git_ignored = false, custom = { "^\\.git$", "^node_modules$", "^\\.cache$" } },
	git = { enable = true, ignore = false },
	diagnostics = { enable = true, show_on_dirs = true },
})
