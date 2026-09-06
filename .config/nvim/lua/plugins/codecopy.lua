local path = vim.env.CODECOPY_NVIM_PATH or vim.fn.expand("~/dev/codecopy.nvim")
if vim.fn.isdirectory(path) == 0 then
	vim.notify("codecopy.nvim not found at " .. path, vim.log.levels.WARN)
	return
end
vim.opt.runtimepath:prepend(path)

local ok, codecopy = pcall(require, "codecopy")

if ok then
	codecopy.setup({
		env = {
			enabled = true,
		},
	})
else
	vim.notify("codecopy.nvim failed to load: " .. tostring(codecopy), vim.log.levels.ERROR)
end
