local gh = require("config.utils").gh

vim.pack.add({
	gh("vuki656/package-info.nvim"),
})

local ok, package_info = pcall(require, "package-info")

if ok then
	package_info.setup()
end
