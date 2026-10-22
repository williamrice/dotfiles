local layout = {}
local dsp = hl.dsp

local function for_layout(master, dwindle)
    return function()
        local window = hl.get_active_window()
        if not window or not window.layout then
            return
        end
        local action = ({ master = master, dwindle = dwindle })[window.workspace.tiled_layout]
        if action then
            return hl.dispatch(action)
        end
    end
end

local rotate_master = dsp.layout("orientationcycle left top right bottom")
layout.rotate = for_layout(rotate_master, dsp.layout("togglesplit"))
layout.mirror = for_layout(function()
    hl.dispatch(rotate_master)
    return hl.dispatch(rotate_master)
end, dsp.layout("swapsplit"))
layout.promote = for_layout(dsp.layout("swapwithmaster master"), dsp.layout("movetoroot"))
layout.shrink = for_layout(dsp.layout("mfact -0.05"), dsp.layout("splitratio -0.05"))
layout.grow = for_layout(dsp.layout("mfact +0.05"), dsp.layout("splitratio +0.05"))

function layout.toggle()
    local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
    if not workspace then
        return
    end
    hl.workspace_rule({
        workspace = workspace.special and workspace.name or tostring(workspace.id),
        layout = workspace.tiled_layout == "master" and "dwindle" or "master",
    })
end

return layout
