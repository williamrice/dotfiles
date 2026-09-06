local luasnip = require("luasnip")

luasnip.config.setup({
	update_events = "TextChanged,TextChangedI",
	enable_autosnippets = true,
})
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = { vim.fn.stdpath("config") .. "/lua/config/snippets" } })
luasnip.filetype_extend("javascript", { "react" })
luasnip.filetype_extend("typescript", { "react" })
luasnip.filetype_extend("javascriptreact", { "javascript", "react" })
luasnip.filetype_extend("typescriptreact", { "typescript", "react" })
luasnip.filetype_extend("php", { "html" })

local ok, react_snippets = pcall(require, "react-snippets")
if ok then
	react_snippets.setup({ readonly_props = false })
end

vim.keymap.set({ "i", "s" }, "<C-f>", function()
	if luasnip.jumpable(1) then luasnip.jump(1) end
end, { desc = "Next snippet field" })
vim.keymap.set({ "i", "s" }, "<C-b>", function()
	if luasnip.jumpable(-1) then luasnip.jump(-1) end
end, { desc = "Previous snippet field" })
