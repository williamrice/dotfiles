local dap = require("dap")
local ui = require("dapui")

ui.setup()
require("dap-go").setup({ delve = { path = vim.fn.stdpath("data") .. "/mason/bin/dlv" } })

local netcoredbg = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"
dap.adapters.coreclr = { type = "executable", command = netcoredbg, args = { "--interpreter=vscode" } }
dap.configurations.cs = {
	{
		type = "coreclr",
		request = "launch",
		name = "Launch .NET assembly",
		cwd = "${workspaceFolder}",
		program = function()
			return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
		end,
	},
}

--- @diagnostic disable-next-line: missing-fields
require("nvim-dap-virtual-text").setup({
	-- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
	display_callback = function(variable)
		local name = string.lower(variable.name)
		local value = string.lower(variable.value)
		if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
			return "*****"
		end

		if #variable.value > 15 then
			return " " .. string.sub(variable.value, 1, 15) .. "... "
		end

		return " " .. variable.value
	end,
})
dap.configurations.lua = {
	{
		type = "nlua",
		request = "attach",
		name = "Attach to running Neovim instance",
	},
}

dap.adapters.nlua = function(callback, config)
	callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

dap.listeners.before.attach.warice_dapui = function()
	ui.open()
end
dap.listeners.before.launch.warice_dapui = function()
	ui.open()
end
dap.listeners.before.event_terminated.warice_dapui = function()
	ui.close()
end
dap.listeners.before.event_exited.warice_dapui = function()
	ui.close()
end
