local M       = {}

M.terminal    = "ghostty"
M.fileManager = "thunar"
M.menu        = "rofi -show drun"
M.browser     = "google-chrome-stable"
M.teams       = M.browser .. " --app=https://teams.cloud.microsoft"
M.asana       = M.browser .. " --app=https://app.asana.com/"
M.outlook     = M.browser .. " --app=https://outlook.office.com/mail/"

return M
