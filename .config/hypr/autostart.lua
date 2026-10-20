hl.on("hyprland.start", function()
    local home = os.getenv("HOME")
    -- Import the new session before starting D-Bus and systemd desktop helpers.
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP QT_QPA_PLATFORMTHEME QT_QPA_PLATFORM XCURSOR_THEME XCURSOR_SIZE HYPRCURSOR_SIZE && systemctl --user start hyprpolkitagent.service app-dev.lizardbyte.app.Sunshine.service")
    hl.exec_cmd(home .. "/.local/bin/set-dark-mode")
    for _, command in ipairs({ "waybar", "hypridle", "hyprpaper", "mako", "copyq" }) do
        hl.exec_cmd(command)
    end
end)
