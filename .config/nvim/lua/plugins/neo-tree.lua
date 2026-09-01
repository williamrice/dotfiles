local gh = require("config.utils").gh

vim.pack.add({
	gh("nvim-neo-tree/neo-tree.nvim"),
	gh("nvim-lua/plenary.nvim"),
	gh("MunifTanjim/nui.nvim"),
	gh("nvim-tree/nvim-web-devicons"),
})

require("neo-tree").setup({
	filesystem = {
		bind_to_cwd = true,
		hijack_netrw_behavior = "disabled",
		auto_expand_width = true,
		filtered_items = {
			visible = true,
			show_hidden_count = true,
			hide_dotfiles = false,
			hide_gitignored = false,
			hide_by_name = {},
			never_show = { ".git", ".DS_Store", "node_modules", ".cache" },
		},
	},
	close_if_last_window = true,
	window = {
		position = "float",
		width = 30,
	},
})
