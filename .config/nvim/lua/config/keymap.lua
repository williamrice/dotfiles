local keymap = vim.keymap
local fzf = require("fzf-lua")

-- general keymaps
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode." })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights." })
keymap.set("n", "<leader>sf", ":noa w<CR>", { desc = "Saves the buffer without formatting." })
keymap.set("n", "x", '"_x', { desc = "Delete character under cursor without affecting clipboard." })
keymap.set("n", "<leader>=", "<C-a>", { desc = "Increment number under cursor." })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number under cursor." })
keymap.set("v", ">", ">gv", { desc = "Increase indentation." })
keymap.set("v", "<", "<gv", { desc = "Decrease indentation." })
keymap.set("n", "<C-g>", "ggVG", { desc = "Select all text in buffer." })
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor." })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor." })
keymap.set("n", "n", "nzzzv", { desc = "Next search result and center cursor." })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center cursor." })
keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
	print("Sourced the current file.")
end, { desc = "Source the current file." })

-- Split windows keys
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically." })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally." })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize window sizes." })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current window." })

keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab." })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab." })

-- Pane swaps
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate to left pane." })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate to pane below." })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate to pane above." })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate to right pane." })

-- debugging keymaps (loaded lazily when dap is available)
local dap_ok, dap = pcall(require, "dap")
if dap_ok then
	keymap.set("n", "<f5>", dap.continue, { desc = "dap continue / start debugging" })
	keymap.set("n", "<f10>", dap.step_over, { desc = "dap step over" })
	keymap.set("n", "<f11>", dap.step_into, { desc = "dap step into" })
	keymap.set("n", "<f12>", dap.step_out, { desc = "dap step out" })
	keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "toggle breakpoint" })
	keymap.set("n", "<leader>dt", dap.terminate, { desc = "dap terminate / stop debugging" })
	keymap.set("n", "<leader>dr", dap.restart, { desc = "dap restart" })
	keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "run to cursor" })
end

-- run lua server
vim.keymap.set("n", "<leader>dl", function()
	require("osv").launch({ port = 8086 })
end, { noremap = true, desc = "launch lua debug server" })

-- eval var under cursor
keymap.set("n", "<leader>?", function()
	local dapui_ok, dapui = pcall(require, "dapui")
	if dapui_ok then
		--- @diagnostic disable-next-line: missing-fields
		dapui.eval(nil, { enter = true })
	end
end, { desc = "evaluate variable under cursor" })

keymap.set("n", "<leader>du", function()
	local dapui_ok, dapui = pcall(require, "dapui")
	if dapui_ok then
		dapui.toggle()
	end
end, { desc = "toggle dap ui" })

-- Plugin Keybinds
----------------------
-- Code copy
keymap.set("n", "<leader>cr", "<CMD>Lazy reload codecopy.nvim<CR>", { desc = "reload code copy" })
keymap.set({ "n", "v" }, "<leader>cc", "<CMD>CodeCopy<CR>", { desc = "copy code" })

-- copilot
keymap.set("n", "<leader>ct", function()
	if vim.b.copilot_enabled == nil then
		vim.b.copilot_enabled = true
	end
	vim.b.copilot_enabled = not vim.b.copilot_enabled
	if vim.b.copilot_enabled then
		vim.cmd("Copilot enable")
		vim.notify("Copilot enabled", vim.log.levels.INFO)
	else
		vim.cmd("Copilot disable")
		vim.notify("Copilot disabled", vim.log.levels.INFO)
	end
end, { desc = "Toggle Copilot." })
keymap.set("n", "<leader>cp", "<cmd>Copilot panel<cr>", { desc = "Open Copilot panel." })
keymap.set("n", "<leader>cs", "<cmd>Copilot status<cr>", { desc = "Show Copilot status." })

-- lsp
keymap.set(
	"n",
	"<leader>gts",
	"<cmd>TSToolsGoToSourceDefinition<cr>",
	{ desc = "Go to source definition in TypeScript file." }
)
keymap.set("n", "ge", vim.diagnostic.open_float, { desc = "Show line diagnostics." })
keymap.set("n", "gH", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local current_state = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
	vim.lsp.inlay_hint.enable(not current_state, { bufnr = bufnr })
	local status = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) and "enabled" or "disabled"
	vim.notify("Inlay hints " .. status, vim.log.levels.INFO)
end, { desc = "Toggle inlay Hints." })

keymap.set("n", "gs", vim.lsp.buf.declaration, { desc = "Go to declaration" })
keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })

-- Code actions
keymap.set({ "n", "v" }, "ca", function()
	require("fzf-lua").lsp_code_actions({
		winopts = {
			-- relative = "cursor",
			width = 0.8,
			height = 0.5,
			row = 0.5,
			col = 0.5,
			---@diagnostic disable-next-line: missing-fields
			preview = {
				layout = "horizontal",
				horizontal = "right:70%",
			},
		},
	})
end, { desc = "Code action" })
keymap.set("n", "rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Diagnostics
keymap.set("n", "<leader>ne", function()
	vim.diagnostic.jump({ count = -1, float = { border = "single" } })
end, { desc = "Previous diagnostic" })
keymap.set("n", "<leader>pe", function()
	vim.diagnostic.jump({ count = 1, float = { border = "single" } })
end, { desc = "Next diagnostic" })

-- conform formatter
keymap.set({ "n", "v" }, "<leader>f", function()
	local conform_ok, conform = pcall(require, "conform")
	if conform_ok then
		conform.format({
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
		})
	end
end, { desc = "Format file or range (in visual mode)." })

-- trouble
keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle diagnostics (Trouble)." })
keymap.set(
	"n",
	"<leader>xX",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ desc = "Toggle buffer diagnostics (Trouble)." }
)
keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Toggle symbols (Trouble)." })
keymap.set(
	"n",
	"<leader>xl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	{ desc = "Toggle LSP definitions/references (Trouble)." }
)
keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Toggle location list (Trouble)." })
keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Toggle quickfix list (Trouble)." })

-- spectre
keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre",
})
keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
	desc = "Search current word",
})
keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
	desc = "Search current word",
})
keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
	desc = "Search on current file",
})

--treesitter text objects

keymap.set({ "x", "o" }, "af", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
keymap.set({ "x", "o" }, "if", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
keymap.set({ "x", "o" }, "ac", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
keymap.set({ "x", "o" }, "ic", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)

-- markdown
keymap.set("n", "<leader>md", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle markdown rendering." })
keymap.set("n", "<leader>mp", "<cmd>RenderMarkdown preview<cr>", { desc = "Preview markdown in split." })

-- nvim-tree
keymap.set("n", "<leader>e", "<cmd>Neotree toggle reveal<CR>", { desc = "Toggle file explorer." })

keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files in current directory." })
keymap.set("n", "<leader>fs", fzf.live_grep, { desc = "Search string in current directory." })
keymap.set("n", "<leader>fb", fzf.grep_cword, { desc = "Search string under cursor." })
keymap.set("n", "<leader>fc", function()
	fzf.files({ cwd = "~/.config/nvim" })
end, { desc = "List Neovim config files." })
keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "List recently opened files." })
keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "List available help tags." })

-- git commands
keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Toggle Git blame view." })

-- diffview
keymap.set("n", "<leader>gv", function()
	local buffer_path = vim.api.nvim_buf_get_name(0)
	local start_path = buffer_path ~= "" and vim.fs.dirname(buffer_path) or vim.uv.cwd()
	local git_root = vim.fs.root(start_path, ".git")

	if not git_root then
		vim.notify("The current buffer is not inside a Git repository.", vim.log.levels.WARN)
		return
	end

	require("diffview").open({ "-C" .. git_root })
end, { desc = "Open Git diff view." })
keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Open Git history for all files." })
keymap.set("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "Open Git history for current file." })
keymap.set("n", "<leader>gc", function()
	vim.ui.input({ prompt = "Compare branch/commit: " }, function(input)
		if input then
			vim.cmd("DiffviewOpen " .. input)
		end
	end)
end, { desc = "Compare Git branches/commits." })
keymap.set("n", "<leader>gx", "<cmd>DiffviewClose<cr>", { desc = "Close Git diff view." })

-- bufferline
keymap.set("n", "<leader>q", "<cmd>bp|bd #<CR>", { desc = "Close current buffer." })
keymap.set("n", "<leader>tp", "<CMD>BufferLinePick<CR>", { desc = "Pick a buffer to switch to." })
keymap.set("n", "<leader>tc", "<CMD>BufferLinePickClose<CR>", { desc = "Pick a buffer to close." })
keymap.set("n", "<S-l>", "<CMD>BufferLineCycleNext<CR>", { desc = "Go to next buffer." })
keymap.set("n", "<S-h>", "<CMD>BufferLineCyclePrev<CR>", { desc = "Go to previous buffer." })
keymap.set("n", "<S-Right>", "<CMD>BufferLineMoveNext<CR>", { desc = "Move buffer to next position." })
keymap.set("n", "<S-Left>", "<CMD>BufferLineMovePrev<CR>", { desc = "Move buffer to previous position." })
keymap.set("n", "<leader>ts", "<CMD>BufferLineSortByDirectory<CR>", { desc = "Sort buffers by directory." })

--lazygit
keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-- package json info
keymap.set(
	{ "n" },
	"<leader>ns",
	require("package-info").show,
	{ silent = true, noremap = true, desc = "Show dependency versions." }
)
keymap.set(
	{ "n" },
	"<leader>nc",
	require("package-info").hide,
	{ silent = true, noremap = true, desc = "Hide dependency versions." }
)
keymap.set(
	{ "n" },
	"<leader>nt",
	require("package-info").toggle,
	{ silent = true, noremap = true, desc = "Toggle dependency versions." }
)
keymap.set(
	{ "n" },
	"<leader>nu",
	require("package-info").update,
	{ silent = true, noremap = true, desc = "Update dependency on the line." }
)
keymap.set(
	{ "n" },
	"<leader>nd",
	require("package-info").delete,
	{ silent = true, noremap = true, desc = "Delete dependency on the line." }
)
keymap.set(
	{ "n" },
	"<leader>ni",
	require("package-info").install,
	{ silent = true, noremap = true, desc = "Install a new dependency." }
)
keymap.set(
	{ "n" },
	"<leader>np",
	require("package-info").change_version,
	{ silent = true, noremap = true, desc = "Install a different dependency version." }
)
