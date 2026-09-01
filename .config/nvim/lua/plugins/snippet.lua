local gh = require("config.utils").gh

vim.pack.add({
	gh("L3MON4D3/LuaSnip"),
	gh("mlaursen/vim-react-snippets"),
})

local ok, luasnip = pcall(require, "luasnip")

if ok then
	luasnip.config.setup({
		update_events = "TextChanged,TextChangedI",
		enable_autosnippets = true,
	})
	-- local loaders = require("luasnip.loaders")
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_lua").load({ paths = { vim.fn.stdpath("config") .. "/lua/config/snippets" } })
	luasnip.filetype_extend("javascript", { "react" })
	luasnip.filetype_extend("typescript", { "react" })
	luasnip.filetype_set("javascriptreact", { "react" })
	luasnip.filetype_set("typescriptreact", { "react" })
	luasnip.filetype_extend("php", { "html" })
	luasnip.filetype_extend("html", { "php" })

	local rs_ok, react_snippets = pcall(require, "react-snippets")
	if rs_ok then
		react_snippets.setup({
			readonly_props = false,
		})
	end
end
