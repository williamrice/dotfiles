vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("warice_help_resize", { clear = true }),
	pattern = "help",
	callback = function()
		if vim.fn.winwidth(0) > vim.fn.winheight(0) then
			vim.cmd("wincmd L")
			vim.cmd("vertical resize 80")
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("warice_highlight_yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
