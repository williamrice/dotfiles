require("gitsigns").setup({
	current_line_blame = false,
	word_diff = false,
	on_attach = function(bufnr)
		local gs = require("gitsigns")
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end
		map("n", "]h", function() gs.nav_hunk("next") end, "Next Git hunk")
		map("n", "[h", function() gs.nav_hunk("prev") end, "Previous Git hunk")
		map("n", "<leader>gp", gs.preview_hunk_inline, "Preview Git hunk")
		map("n", "<leader>gs", gs.stage_hunk, "Stage Git hunk")
		map("v", "<leader>gs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "Stage selected Git lines")
		map("n", "<leader>gr", gs.reset_hunk, "Reset Git hunk")
		map("v", "<leader>gr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "Reset selected Git lines")
		map("n", "<leader>gu", gs.undo_stage_hunk, "Undo staged hunk")
		map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle Git blame")
		map({ "o", "x" }, "ih", gs.select_hunk, "Git hunk")
	end,
})
