local root = (os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config") .. "/hypr/"
for _, module in ipairs({ "appearance", "input", "monitors", "rules", "bindings", "autostart" }) do
    dofile(root .. module .. ".lua")
end
