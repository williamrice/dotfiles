local gh = require("config.utils").gh

vim.pack.add({
	gh("pmizio/typescript-tools.nvim"),
	gh("nvim-lua/plenary.nvim"),
})

local ok, typescript_tools = pcall(require, "typescript-tools")

if ok then
	typescript_tools.setup({
		settings = {
			-- Expose as global settings
			expose_as_code_action = "all",
			-- TSServer settings
			tsserver_file_preferences = {
				-- Inlay Hints
				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	})
end
