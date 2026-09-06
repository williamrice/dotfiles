require("copilot").setup({
		panel = {
			enabled = true,
			auto_refresh = false,
			keymap = {
				jump_prev = "[[",
				jump_next = "]]",
				accept = "<CR>",
				refresh = "gr",
				open = "<M-CR>",
			},
			layout = {
				position = "bottom",
				ratio = 0.4,
			},
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = true,
			debounce = 75,
			keymap = {
				accept = "<S-Tab>",
				accept_word = "<C-Right>",
				accept_line = "<C-l>",
				next = "<C-]>",
				prev = "<C-[>",
				dismiss = "<Esc>",
			},
		},
		filetypes = {
			yaml = false,
			markdown = false,
			help = false,
			gitcommit = false,
			gitrebase = false,
			hgcommit = false,
			svn = false,
			cvs = false,
			["."] = false,
		},
		should_attach = function(bufnr, bufname)
			return vim.bo[bufnr].buflisted
				and vim.bo[bufnr].buftype == ""
				and not vim.fs.basename(bufname):match("^%.env")
		end,
		copilot_node_command = "node",
		server_opts_overrides = {},
	})
