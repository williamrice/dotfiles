hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    input = {
        kb_layout = "us",
        repeat_rate = 25,
        repeat_delay = 600,
        numlock_by_default = false,
        natural_scroll = false,
        touchpad = {
            tap_to_click = true,
            tap_and_drag = true,
            drag_lock = true,
            natural_scroll = false,
            disable_while_typing = true,
        },
    },
})
