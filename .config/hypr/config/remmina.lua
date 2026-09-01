local M = {}

function M.setup()
  local office_window = "initialtitle:^Remmina$"

  local function restore_office_window()
    hl.dispatch(hl.dsp.window.float({
      action = "set",
      window = office_window,
    }))
    hl.dispatch(hl.dsp.window.fullscreen({
      action = "unset",
      window = office_window,
    }))
    hl.dispatch(hl.dsp.window.move({
      x = 0,
      y = 0,
      relative = false,
      window = office_window,
    }))
    hl.dispatch(hl.dsp.window.resize({
      x = 5120,
      y = 1440,
      relative = false,
      window = office_window,
    }))
  end

  local function schedule_office_restore()
    -- Workspace mapping and XWayland configure events finish asynchronously.
    -- Reapply once after each stage so Remmina cannot leave the window at 2560x1440.
    hl.timer(restore_office_window, { timeout = 50, type = "oneshot" })
    hl.timer(restore_office_window, { timeout = 250, type = "oneshot" })
  end

  hl.on("workspace.active", function(workspace)
    if workspace.id == 4 then
      schedule_office_restore()
    end
  end)

  hl.on("window.open", function(window)
    if window.initial_class == "org.remmina.Remmina" and window.initial_title == "Remmina" then
      schedule_office_restore()
    end
  end)

  hl.window_rule({
    name = "office-remmina",
    match = {
      class         = "org.remmina.Remmina",
      initial_title = "^Remmina$",
    },

    workspace      = "4",
    monitor        = "DP-1",
    float          = true,
    move           = "0 0",
    size           = "5120 1440",
    suppress_event = "fullscreen maximize x11configurerequest",
  })
end

return M
