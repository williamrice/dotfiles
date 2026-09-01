local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"

for _, file in ipairs(vim.fn.readdir(plugin_dir)) do
	local name = file:match("^(.+)%.lua$")
	if name then
		require("plugins." .. name)
	end
end
