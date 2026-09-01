local gh = require("config.utils").gh

vim.pack.add({
	gh("rcarriga/nvim-notify"),
})

local ok, notify = pcall(require, "notify")

if ok then
	vim.notify = notify
end
