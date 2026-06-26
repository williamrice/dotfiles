local M = {}
function M.setup(apps)
  ---------------------
  ---- KEYBINDINGS ----
  ---------------------

  local mainMod = "SUPER" -- Sets "Windows" key as main modifier

  hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(apps.terminal))
  hl.bind(mainMod .. " + Q", hl.dsp.window.close())
  hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(apps.fileManager))
  hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(apps.browser))
  hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
  hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle", window = "activewindow" }))
  hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(apps.menu))
  hl.bind(mainMod .. " + slash", hl.dsp.layout("togglesplit"))      -- dwindle only
  hl.bind(mainMod .. " + backslash", hl.dsp.layout("swapsplit"))    -- dwindle only
  hl.bind(mainMod .. " + V", hl.dsp.layout("splitratio 1.0 exact")) -- dwindle only

  -- Move focus with mainMod + arrow keys
  hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
  hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
  hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
  hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

  -- Switch workspaces with mainMod + [0-9]
  -- Move active window to a workspace with mainMod + SHIFT + [0-9]
  for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
  end

  -- Moves workspaces via direction
  hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
  hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
  hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
  hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
  hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.window.move({ monitor = "-1" }))
  hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ monitor = "+1" }))

  -- resizes workspace
  hl.bind(mainMod .. " + ALT + h", hl.dsp.window.resize({ x = -45, y = 0, relative = true }))
  hl.bind(mainMod .. " + ALT + l", hl.dsp.window.resize({ x = 45, y = 0, relative = true }))
  hl.bind(mainMod .. " + ALT + k", hl.dsp.window.resize({ x = 0, y = -45, relative = true }))
  hl.bind(mainMod .. " + ALT + j", hl.dsp.window.resize({ x = 0, y = 45, relative = true }))

  -- Example special workspace (scratchpad)
  hl.bind(mainMod .. " + grave", hl.dsp.workspace.toggle_special("magic"))
  hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:magic" }))

  -- Scroll through existing workspaces with mainMod + scroll
  hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
  hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

  -- Move/resize windows with mainMod + LMB/RMB and dragging
  hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
  hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

  -- TODO: Look at audio keys
  -- Laptop multimedia keys for volume and LCD brightness
  hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
  hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
  hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
  hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
  hl.bind("XF86Favorites", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
  hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
  hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

  -- Requires playerctl
  hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
  hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
  hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
  hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

  -- reload waybar
  hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("killall -SIGUSR2 waybar"))

  --screenshots
  hl.bind("Print",
    hl.dsp.exec_cmd("slurp | grim -g - - | tee ~/Pictures/screenshots/$(date +%s).png | wl-copy"))

  -- clipboard manager
  hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("copyq toggle"))
  hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -labrn --scale=8 --radius=150"))
end

return M
