local gh = require("config.utils").gh

vim.pack.add({
	gh("zbirenbaum/copilot.lua"),
})

local ok, copilot = pcall(require, "copilot")

if ok then
	copilot.setup({
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
			sh = function()
				if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
					-- disable for .env files
					return false
				end
				return true
			end,
		},
		copilot_node_command = "node",
		server_opts_overrides = {},
	})
end
