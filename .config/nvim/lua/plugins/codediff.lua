require("codediff").setup({
	diff = { compact = false, gutter_signs = true, cycle_hunks_across_files = true },
	explorer = { auto_refresh = true, view_mode = "tree", line_stats = { enabled = true, count_untracked = true } },
})
