local M = {}

function M.setup(apps)
  hl.on("hyprland.start", function()
    hl.exec_cmd(apps.terminal)
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("copyq")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
  end)
end

return M
