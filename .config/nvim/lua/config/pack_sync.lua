local M = {}

local function mismatches(plugins)
	local checks = {}
	for _, plugin in ipairs(plugins) do
		if plugin.active and plugin.rev then
			checks[#checks + 1] = {
				plugin = plugin,
				job = vim.system({ "git", "-C", plugin.path, "rev-parse", "HEAD" }, { text = true }),
			}
		end
	end

	local names = {}
	for _, check in ipairs(checks) do
		local result = check.job:wait()
		if result.code ~= 0 then
			error("Cannot check plugin revision for " .. check.plugin.spec.name .. ": " .. (result.stderr or ""))
		end
		if vim.trim(result.stdout) ~= check.plugin.rev then
			names[#names + 1] = check.plugin.spec.name
		end
	end
	return names
end

function M.sync()
	-- Called after pack.add(), before any plugin configuration is loaded.
	-- Keep the original targets: pack.update() can report errors without throwing.
	local plugins = vim.pack.get(nil, { info = false })
	local names = mismatches(plugins)
	if #names == 0 then
		return
	end

	vim.pack.update(names, { target = "lockfile", force = true })
	local remaining = mismatches(plugins)
	if #remaining > 0 then
		error("Plugin lockfile sync failed for: " .. table.concat(remaining, ", ")
			.. ". Check :messages and the nvim-pack.log file in :echo stdpath('log'), then restart to retry.")
	end
end

return M
