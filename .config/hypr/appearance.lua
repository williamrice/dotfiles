hl.config({
    general = {
        layout = "master",
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        resize_on_border = true,
        col = {
            active_border = "rgba(83d3f7ff)",
            inactive_border = "rgba(a7d5f52e)",
        },
    },
    master = {
        orientation = "left",
        mfact = 0.55,
        new_status = "master",
    },
    dwindle = { preserve_split = true },
    decoration = {
        rounding = 15,
        rounding_power = 2.0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        blur = { enabled = true, size = 8, passes = 3, vibrancy = 0.12 },
        shadow = { enabled = false },
    },
    animations = { enabled = false },
    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
    },
})

hl.window_rule({
    name = "ignore-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Skip fully transparent gaps so blur follows the three panel shapes.
hl.layer_rule({
    name = "waybar-glass",
    match = { namespace = "waybar" },
    blur = true,
    ignore_alpha = 0.2,
})
