hl.config({
    general = {
        layout = "master",
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        resize_on_border = true,
        col = {
            active_border = "rgba(32cd32ff)",
            inactive_border = "rgba(444444ff)",
        },
    },
    master = {
        orientation = "left",
        mfact = 0.55,
        new_status = "master",
    },
    dwindle = { preserve_split = true },
    decoration = {
        rounding = 6,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        blur = { enabled = false },
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
