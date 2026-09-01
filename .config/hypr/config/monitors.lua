local M = {}

function M.setup()
  hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440@144",
    position = "0x0",
    scale    = "auto",
  })

  hl.monitor({
    output   = "DP-2",
    mode     = "2560x1440@165",
    position = "2560x0",
    scale    = "auto",
  })
end

return M
