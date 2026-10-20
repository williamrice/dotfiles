local dsp = hl.dsp
local home = os.getenv("HOME")
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

for id = 1, 9 do
    hl.bind("SUPER + " .. id, dsp.focus({ workspace = id }))
    hl.bind("SUPER + SHIFT + code:" .. (id + 9), dsp.window.move({ workspace = id, follow = false }))
end
hl.bind("SUPER + SHIFT + comma", dsp.window.move({ monitor = "left", follow = true }))
hl.bind("SUPER + SHIFT + period", dsp.window.move({ monitor = "right", follow = true }))
hl.bind("SUPER + mouse_down", dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse:272", dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", dsp.window.resize(), { mouse = true })

hl.bind("SUPER + grave", dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + SHIFT + grave", dsp.window.move({ workspace = "special:scratchpad", follow = false }))
hl.bind("SUPER + CTRL + Return", dsp.layout("swapwithmaster master"))
hl.bind("SUPER + bracketleft", dsp.layout("mfact -0.05"))
hl.bind("SUPER + bracketright", dsp.layout("mfact +0.05"))
-- These split controls apply after selecting dwindle in appearance.lua.
hl.bind("SUPER + slash", dsp.layout("togglesplit"))
hl.bind("SUPER + backslash", dsp.layout("swapsplit"))

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
