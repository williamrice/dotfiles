local gh = require("config.utils").gh

vim.pack.add({
	gh("MeanderingProgrammer/render-markdown.nvim"),
	gh("nvim-tree/nvim-web-devicons"),
})

local ok, render_markdown = pcall(require, "render-markdown")

if ok then
	render_markdown.setup({
		-- Render markdown when opening file
		enabled = true,
		-- Max file size to render (100KB default)
		max_file_size = 10.0,
		-- Debounce for re-rendering
		debounce = 100,
		-- Render markdown in all modes (not just normal mode)
		render_modes = { "n", "c", "i" },
		-- Anti-conceal: hide rendering on cursor line
		anti_conceal = {
			enabled = true,
		},
		heading = {
			enabled = true,
			sign = true,
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			-- Background colors for headings
			backgrounds = {
				"RenderMarkdownH1Bg",
				"RenderMarkdownH2Bg",
				"RenderMarkdownH3Bg",
				"RenderMarkdownH4Bg",
				"RenderMarkdownH5Bg",
				"RenderMarkdownH6Bg",
			},
		},
		code = {
			enabled = true,
			sign = true,
			style = "full",
			width = "block",
			left_pad = 2,
			right_pad = 2,
		},
		bullet = {
			enabled = true,
			icons = { "●", "○", "◆", "◇" },
		},
	})
end
