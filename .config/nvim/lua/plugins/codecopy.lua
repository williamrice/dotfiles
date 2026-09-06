vim.opt.runtimepath:prepend("/home/warice/dev/codecopy.nvim")

local ok, codecopy = pcall(require, "codecopy")

if ok then
	codecopy.setup({
		env = {
			enabled = true,
		},
	})
end
