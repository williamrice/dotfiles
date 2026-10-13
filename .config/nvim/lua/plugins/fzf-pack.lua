-- Use the development checkout only on warbox.
if vim.uv.os_gethostname() == "warbox" then
	local checkout = vim.fn.expand("~/dev/fzf-pack.nvim")
	if vim.uv.fs_stat(checkout .. "/lua/fzf-pack/init.lua") then
		vim.opt.runtimepath:prepend(checkout)
	end
end

local ok, plugin = pcall(require, "fzf-pack")
if ok then
	plugin.setup()
else
	vim.notify("Could not load fzf-pack: " .. tostring(plugin), vim.log.levels.WARN)
end
