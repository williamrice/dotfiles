local modules = {
	"colorscheme",
	"treesitter",
	"lsp",
	"completion",
	"snippets",
	"formatting",
	"fzf",
	"nvim-tree",
	"git",
	"codediff",
	"grug-far",
	"copilot",
	"dap",
	"editing",
	"ui",
	"markdown",
	"codecopy",
}

for _, module in ipairs(modules) do
	local ok, err = pcall(require, "plugins." .. module)
	if not ok then
		error(("Failed to configure plugins.%s: %s"):format(module, err))
	end
end
