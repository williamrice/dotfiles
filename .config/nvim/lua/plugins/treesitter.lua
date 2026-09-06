local treesitter = require("nvim-treesitter")
local parsers = {
		"bash",
		"blade",
		"c_sharp",
		"c",
		"go",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"javascript",
		"html",
		"css",
		"tsx",
		"json",
		"php",
		"php_only",
		"typescript",
		"markdown",
		"markdown_inline",
		"yaml",
		"toml",
		"dockerfile",
		"gitignore",
		"twig",
}

local installed = {}
for _, parser in ipairs(treesitter.get_installed()) do installed[parser] = true end
local missing = vim.tbl_filter(function(parser) return not installed[parser] end, parsers)
if #missing > 0 then treesitter.install(missing, { summary = true }) end

require("nvim-treesitter-textobjects").setup({ select = { lookahead = true } })

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("warice_treesitter", { clear = true }),
	callback = function(event)
		local language = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
		if language and vim.tbl_contains(treesitter.get_installed(), language) then
			pcall(vim.treesitter.start, event.buf, language)
		end
	end,
})
