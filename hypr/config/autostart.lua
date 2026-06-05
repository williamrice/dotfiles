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
    hl.dispatch(hl.dsp.exec_cmd(apps.teams, { workspace = "6 silent" }))
    hl.dispatch(hl.dsp.exec_cmd(apps.asana, { workspace = "8 silent" }))
    hl.dispatch(hl.dsp.exec_cmd(apps.outlook, { workspace = "9 silent" }))
  end)
end

return M
