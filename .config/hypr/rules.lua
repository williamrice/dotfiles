hl.window_rule({
    name = "steam-workspace",
    match = { class = "^([Ss]team)$" },
    workspace = "10 silent",
})

hl.window_rule({
    name = "discord-workspace",
    match = { class = "^([Dd]iscord)$" },
    workspace = "6 silent",
})

hl.window_rule({
    name = "docker-desktop-workspace",
    match = { class = "^(Docker Desktop|docker-desktop|com\\.docker\\.docker)$" },
    workspace = "4 silent",
})
