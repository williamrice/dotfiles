hl.monitor({ output = "DP-1", mode = "2560x1440@179.959", position = "0x0", scale = 1 })
hl.monitor({ output = "DP-2", mode = "2560x1440@165.080", position = "2560x0", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

for id = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(id),
        monitor = id <= 5 and "DP-1" or "DP-2",
        default = id == 1 or id == 6,
        persistent = true,
    })
end
hl.workspace_rule({ workspace = "special:scratchpad", gaps_out = 80 })
