local dsp = hl.dsp
local home = os.getenv("HOME")
local root = (os.getenv("XDG_CONFIG_HOME") or home .. "/.config") .. "/hypr/"
local layout = dofile(root .. "layout.lua")
local function launch(keys, command, flags)
    hl.bind(keys, dsp.exec_cmd(command), flags)
end

launch("SUPER + Return", "ghostty")
hl.bind("SUPER + Q", dsp.window.close())
launch("SUPER + E", "thunar")
launch("SUPER + W", "firefox-developer-edition")
launch("SUPER + SHIFT + W", "google-chrome-stable")
launch("SUPER + space", "rofi -show drun")
hl.bind("SUPER + SHIFT + F", dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + V", dsp.window.fullscreen({ mode = "maximized" }))

for key, direction in pairs({ H = "left", J = "down", K = "up", L = "right" }) do
    hl.bind("SUPER + " .. key, dsp.focus({ direction = direction }))
    hl.bind("SUPER + SHIFT + " .. key, dsp.window.swap({ direction = direction }))
end
for key, delta in pairs({ H = { -45, 0 }, L = { 45, 0 }, K = { 0, -45 }, J = { 0, 45 } }) do
    hl.bind("SUPER + ALT + " .. key,
        dsp.window.resize({ x = delta[1], y = delta[2], relative = true }), { repeating = true })
end

for id = 1, 10 do
    local key = id % 10
    local keycode = id == 10 and 19 or id + 9
    hl.bind("SUPER + " .. key, dsp.focus({ workspace = id }), { description = "Focus workspace " .. id })
    hl.bind("SUPER + SHIFT + code:" .. keycode, dsp.window.move({ workspace = id, follow = false }),
        { description = "Move window to workspace " .. id })
end
hl.bind("SUPER + SHIFT + comma", dsp.window.move({ monitor = "left", follow = true }))
hl.bind("SUPER + SHIFT + period", dsp.window.move({ monitor = "right", follow = true }))
hl.bind("SUPER + mouse_down", dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", dsp.focus({ workspace = "e-1" }))
-- Native Lua drag/resize dispatchers track button release themselves.
hl.bind("SUPER + mouse:272", dsp.window.drag())
hl.bind("SUPER + mouse:273", dsp.window.resize())

hl.bind("SUPER + grave", dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + SHIFT + grave", dsp.window.move({ workspace = "special:scratchpad", follow = false }))
hl.bind("SUPER + CTRL + Return", layout.promote, { description = "Promote window to master/root" })
hl.bind("SUPER + bracketleft", layout.shrink, { description = "Shrink master/focused split" })
hl.bind("SUPER + bracketright", layout.grow, { description = "Grow master/focused split" })
hl.bind("SUPER + slash", layout.rotate, { description = "Rotate master layout or toggle dwindle split" })
hl.bind("SUPER + backslash", layout.mirror, { description = "Mirror master layout or swap dwindle split" })
hl.bind("SUPER + Tab", layout.toggle, { description = "Toggle workspace between master and dwindle" })

launch("SUPER + R", "hyprctl reload")
launch("SUPER + SHIFT + R", "pkill -x waybar; exec waybar")
launch("SUPER + CTRL + L", home .. "/.local/bin/lock-screen")
launch("SUPER + Escape", home .. "/.local/bin/power-menu")
launch("Print", home .. "/.local/bin/screenshot")
launch("SUPER + P", "copyq --start-server toggle")
launch("SUPER + SHIFT + P", "hyprpicker --autocopy")

local media = {
    XF86AudioRaiseVolume = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+",
    XF86AudioLowerVolume = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
    XF86AudioMute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
    XF86AudioMicMute = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",
    XF86Favorites = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",
    XF86MonBrightnessUp = "brightnessctl -e4 -n2 set 5%+",
    XF86MonBrightnessDown = "brightnessctl -e4 -n2 set 5%-",
    XF86AudioNext = "playerctl next",
    XF86AudioPlay = "playerctl play-pause",
    XF86AudioPrev = "playerctl previous",
}
for key, command in pairs(media) do
    launch(key, command, { locked = true, repeating = key:find("Volume") ~= nil or key:find("Brightness") ~= nil })
end
