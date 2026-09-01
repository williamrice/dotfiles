--- Settings
local g = vim.g
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.mapleader = " "
g.maplocalleader = " "

local opt = vim.opt
opt.encoding = "UTF-8"
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.backspace = "indent,eol,start"
opt.mouse = "a"
opt.scrolloff = 15
opt.hidden = true
opt.errorbells = false
opt.splitright = true
opt.splitbelow = true
opt.iskeyword:append("-")

--- Tabs
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = false
opt.smartindent = true
opt.breakindent = true
opt.autoindent = true
opt.wrap = false

--- UI settings
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
--opt.colorcolumn = "100"
opt.showmode = false
opt.signcolumn = "yes"
opt.list = false
opt.cmdheight = 1
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

--- Searching
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 5000
opt.inccommand = "split"
