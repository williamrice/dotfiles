local M = {}
function M.setup()
  hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
      class      = "^$",
      title      = "^$",
      xwayland   = true,
      float      = true,
      fullscreen = false,
      pin        = false,
    },

    no_focus = true,
  })

  hl.window_rule({
    name      = "move-teams-to-workspace-6",
    match     = { title = ".*(Microsoft Teams|Teams).*" },
    workspace = "6 silent",
  })

  hl.window_rule({
    name      = "move-asana-to-workspace-8",
    match     = { title = ".*(Asana).*" },
    workspace = "8 silent",
  })

  hl.window_rule({
    name      = "move-outlook-to-workspace-9",
    match     = { title = ".*(Outlook).*" },
    workspace = "9 silent",
  })

  hl.window_rule({
    name      = "move-discord-to-workspace-6",
    match     = { title = ".*(Discord).*" },
    workspace = "6",
  })

  hl.window_rule({
    name      = "move-remmina-to-workspace-4",
    match     = { class = "org.remmina.Remmina" },
    workspace = "4",
  })

  -- Hyprland-run windowrule
  hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
  })
end

return M
