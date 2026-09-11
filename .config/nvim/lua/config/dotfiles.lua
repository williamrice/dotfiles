local M = {}

function M.setup()
	if vim.fn.has("unix") ~= 1 then
		return
	end

	local home = vim.uv.fs_realpath(vim.uv.os_homedir())
	if not home or not vim.uv.fs_stat(home .. "/.dotfiles/HEAD") then
		return
	end

	local bin = vim.fn.stdpath("config") .. "/bin"
	if not vim.env.NVIM_DOTFILES_GIT then
		vim.env.NVIM_DOTFILES_GIT = vim.fn.exepath("git")
	end
	vim.env.NVIM_DOTFILES_HOME = home
	if not (vim.env.PATH or ""):find(bin, 1, true) then
		vim.env.PATH = bin .. ":" .. vim.env.PATH
	end
end

function M.worktrees()
	local home = vim.env.NVIM_DOTFILES_HOME
	return home and { { gitdir = home .. "/.dotfiles", toplevel = home } } or {}
end

function M.lazygit()
	local path = vim.api.nvim_buf_get_name(0)
	local dir = vim.fn.getcwd()
	if path ~= "" and vim.bo.buftype == "" then
		dir = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
	end
	local result = vim.system({ "git", "-C", dir, "rev-parse", "--show-toplevel", "--absolute-git-dir" }, { text = true }):wait()
	if result.code ~= 0 then
		vim.notify("No Git repository for this file or directory", vim.log.levels.WARN)
		return
	end
	local paths = vim.split(vim.trim(result.stdout), "\n", { plain = true })
	local function dimensions()
		local width = math.max(1, math.floor(vim.o.columns * 0.9) - 2)
		local height = math.max(1, math.floor(vim.o.lines * 0.85) - 2)
		return {
			relative = "editor",
			width = width,
			height = height,
			col = math.max(0, math.floor((vim.o.columns - width - 2) / 2)),
			row = math.max(0, math.floor((vim.o.lines - height - 2) / 2)),
		}
	end

	local buf = vim.api.nvim_create_buf(false, true)
	local opts = vim.tbl_extend("force", dimensions(), {
		style = "minimal",
		border = "rounded",
		title = " LazyGit ",
		title_pos = "center",
	})
	local win = vim.api.nvim_open_win(buf, true, opts)
	vim.bo[buf].bufhidden = "wipe"
	local group = vim.api.nvim_create_augroup("lazygit_float_" .. buf, { clear = true })
	vim.api.nvim_create_autocmd("VimResized", {
		group = group,
		callback = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_set_config(win, dimensions())
			end
		end,
	})
	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,
		buffer = buf,
		once = true,
		callback = function()
			vim.api.nvim_del_augroup_by_id(group)
		end,
	})
	local function close()
		-- Deleting a displayed buffer can leave its window showing a replacement
		-- buffer. Close our float first; bufhidden=wipe also cleans up the terminal.
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		if vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
	local job = vim.fn.jobstart({ "lazygit", "--work-tree", paths[1], "--git-dir", paths[2] }, {
		term = true,
		cwd = paths[1],
		on_exit = function()
			vim.schedule(close)
		end,
	})
	if job <= 0 then
		close()
		vim.notify("Failed to start LazyGit", vim.log.levels.ERROR)
		return
	end
	vim.cmd.startinsert()
end

return M
