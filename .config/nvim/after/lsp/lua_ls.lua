return {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = {
				globals = { "vim" },
			},
			workspace = { checkThirdParty = false },
			hint = {
				enable = true,
				setType = true,
				paramType = true,
				paramName = "All", -- "All" | "Literal" | "Disable"
				semicolon = "Disable",
				arrayIndex = "Disable",
			},
		},
	},
}
