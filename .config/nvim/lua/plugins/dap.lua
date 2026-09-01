local gh = require("config.utils").gh
vim.pack.add({
	gh("mfussenegger/nvim-dap"),
	gh("leoluz/nvim-dap-go"),
	gh("rcarriga/nvim-dap-ui"),
	gh("theHamsta/nvim-dap-virtual-text"),
	gh("nvim-neotest/nvim-nio"),
	gh("jbyuki/one-small-step-for-vimkind"),
	gh("nicholasmata/nvim-dap-cs"),
	gh("jay-babu/mason-nvim-dap.nvim"),
	gh("Cliffback/netcoredbg-macOS-arm64.nvim"),
})

local dap = require("dap")
local ui = require("dapui")

require("dapui").setup()
require("dap-cs").setup()
---@diagnostic disable-next-line: redundant-parameter
require("netcoredbg-macOS-arm64").setup(dap)

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

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end
