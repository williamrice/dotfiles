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
	vim.cmd("botright 15new")
	vim.fn.jobstart({ "lazygit", "--work-tree", paths[1], "--git-dir", paths[2] }, { term = true, cwd = paths[1] })
	vim.cmd.startinsert()
end

return M
