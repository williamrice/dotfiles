-- Load the development checkout directly so edits are available after restart.
local checkout = vim.fn.expand("~/dev/fzf-pack.nvim")
if not vim.uv.fs_stat(checkout .. "/lua/fzf-pack/init.lua") then
	return
end

vim.opt.runtimepath:prepend(checkout)
require("fzf-pack").setup()
