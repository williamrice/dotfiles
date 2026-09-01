return {
	settings = {
		Lua = {
			runtime = { version = "Lua 5.1" },
			diagnostics = {
				globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
			},
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
