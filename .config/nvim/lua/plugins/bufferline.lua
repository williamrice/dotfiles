local gh = require("config.utils").gh

vim.pack.add({
	gh("akinsho/bufferline.nvim"),
})

local ok, bufferline = pcall(require, "bufferline")
if ok then
	bufferline.setup({
		highlights = {
			fill = { bg = "#000000" },
			buffer_selected = { bold = true },
			diagnostic_selected = { bold = true },
			info_selected = { bold = true },
			info_diagnostic_selected = { bold = true },
			warning_selected = { bold = true },
			warning_diagnostic_selected = { bold = true },
			error_selected = { bold = true },
			error_diagnostic_selected = { bold = true },
		},
		options = {
			offsets = {
				{
					filetype = "neo-tree",
					text = "File Explorer",
					text_align = "center",
					seperator = true,
				},
			},
			show_close_icon = false,
			diagnostics = "nvim_lsp",
			max_prefix_length = 8,
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				if context.buffer:current() then
					return ""
				end
				if level:match("error") then
					return ""
				elseif level:match("warning") then
					return ""
				end
				return ""
			end,
		},
	})
end
