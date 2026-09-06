vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("warice_pack_changed", { clear = true }),
	callback = function(event)
		local data = event.data
		if not data or not data.spec or data.spec.name ~= "nvim-treesitter" or data.kind ~= "update" then
			return
		end

		if not data.active then
			vim.cmd.packadd("nvim-treesitter")
		end

		local ok, err = pcall(function()
			require("nvim-treesitter").update(nil, { summary = true }):wait(300000)
		end)
		if not ok then
			error("Failed to update Tree-sitter parsers after updating nvim-treesitter:\n" .. tostring(err))
		end
	end,
})

local function gh(repo, extra)
	return vim.tbl_extend("force", { src = "https://github.com/" .. repo }, extra or {})
end

vim.pack.add({
	gh("3rd/image.nvim"),
	gh("EdenEast/nightfox.nvim"),
	gh("L3MON4D3/LuaSnip", { version = "v2.5.0" }),
	gh("MagicDuck/grug-far.nvim"),
	gh("MeanderingProgrammer/render-markdown.nvim"),
	gh("MunifTanjim/nui.nvim"),
	gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
	gh("akinsho/bufferline.nvim"),
	gh("catgoose/nvim-colorizer.lua"),
	gh("esmuellert/codediff.nvim"),
	gh("folke/lazydev.nvim"),
	gh("folke/trouble.nvim"),
	gh("folke/which-key.nvim"),
	gh("ibhagwan/fzf-lua"),
	gh("j-hui/fidget.nvim"),
	gh("jbyuki/one-small-step-for-vimkind"),
	gh("kylechui/nvim-surround"),
	gh("leoluz/nvim-dap-go"),
	gh("lewis6991/gitsigns.nvim"),
	gh("lukas-reineke/indent-blankline.nvim"),
	gh("mason-org/mason.nvim"),
	gh("mfussenegger/nvim-dap"),
	gh("mlaursen/vim-react-snippets"),
	gh("neovim/nvim-lspconfig"),
	gh("nvim-lualine/lualine.nvim"),
	gh("nvim-neotest/nvim-nio"),
	gh("nvim-tree/nvim-tree.lua"),
	gh("nvim-tree/nvim-web-devicons"),
	gh("nvim-treesitter/nvim-treesitter", { version = "main" }),
	gh("nvim-treesitter/nvim-treesitter-textobjects", { version = "main" }),
	gh("rcarriga/nvim-dap-ui"),
	gh("saghen/blink.cmp", { version = "main" }),
	gh("saghen/blink.lib", { version = "main" }),
	gh("seblyng/roslyn.nvim"),
	gh("stevearc/conform.nvim"),
	gh("theHamsta/nvim-dap-virtual-text"),
	gh("vuki656/package-info.nvim"),
	gh("windwp/nvim-autopairs"),
	gh("windwp/nvim-ts-autotag"),
	gh("zbirenbaum/copilot.lua"),
})
