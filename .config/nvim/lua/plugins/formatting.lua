local conform = require("conform")

conform.setup({
	default_format_opts = { lsp_format = "fallback", timeout_ms = 3000 },
	formatters_by_ft = {
		javascript = { "prettier" }, typescript = { "prettier" },
		javascriptreact = { "prettier" }, typescriptreact = { "prettier" },
		astro = { "prettier" }, html = { "prettier" }, css = { "prettier" }, scss = { "prettier" },
		json = { "prettier" }, jsonc = { "prettier" }, yaml = { "prettier" }, markdown = { "prettier" },
		lua = { "stylua" }, python = { "isort", "black" }, blade = { "blade-formatter" },
		php = { "php_cs_fixer" }, sh = { "shfmt" }, go = { "gofmt" },
	},
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
		return { lsp_format = "fallback", timeout_ms = 3000 }
	end,
})

vim.api.nvim_create_user_command("FormatToggle", function(args)
	if args.bang then
		vim.g.disable_autoformat = not vim.g.disable_autoformat
		vim.notify("Global format-on-save " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
	else
		vim.b.disable_autoformat = not vim.b.disable_autoformat
		vim.notify("Buffer format-on-save " .. (vim.b.disable_autoformat and "disabled" or "enabled"))
	end
end, { bang = true, desc = "Toggle format-on-save" })
