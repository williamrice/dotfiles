local M = {}
function M.setup()
  for i = 1, 10 do
    local monitor = ""
    if i <= 5 then
      monitor = "DP-1"
    else
      monitor = "DP-2"
    end
    hl.workspace_rule({ workspace = "" .. i, monitor = monitor, persistent = true })
  end
end

return M
