Hyprland desktop

Target: Hyprland 0.56.2 (native Lua), verified 2026-10-20.
Select Hyprland at the login screen after logging out of the current session.
From a TTY, run start-hyprland. The plain Hyprland session owns autostart here;
do not also enable the same helpers through UWSM or systemd.

Configuration
  hyprland.lua    loads the modules with dofile so reload rereads every file
  appearance.lua master layout, green borders, 5/10px gaps, 6px rounding
  monitors.lua   DP-1 1440p/180Hz, DP-2 1440p/165Hz; workspaces 1-5 / 6-10
  input.lua      US keyboard, repeat timing, trackpad, Qt environment
  rules.lua      Steam to 10, Discord to 6, Docker Desktop to 4
  bindings.lua   shortcuts and media keys
  autostart.lua  Waybar, Hypridle, Hyprpaper, Mako, CopyQ, Polkit, Sunshine
  hyprlock.conf  dark blue lock screen, Arch logo, clock and password field
  hypridle.conf  lock after 10 minutes; power off only once locked; suspend lock
  hyprpaper.conf Arch logo wallpaper on all outputs

Master layout
The main window takes the left 55%; other windows stack vertically on the right.
New windows become master, matching the previous desktop behavior.
Set master.new_status to "slave" to keep the current main window instead.
Set general.layout to "dwindle" in appearance.lua to use binary splits instead.
Manual locking also powers off displays; input wakes the locked display.
Waybar's idle inhibitor prevents idle locking; explicit locking still works.
No automatic system suspend is configured on this desktop.

Shortcuts
  Super+Return / E / W     terminal / files / Firefox Developer Edition
  Super+Shift+W           Chrome
  Super+Space             Rofi applications
  Super+Q                 close window
  Super+F / Shift+F       fullscreen / floating
  Super+V                 maximize within the work area
  Super+H/J/K/L           focus left/down/up/right
  Super+Shift+H/J/K/L     swap windows
  Super+Alt+H/J/K/L       resize
  Super+1..9,0              focus a workspace on its assigned monitor
  Super+Shift+1..9,0        move window without following it
  Super+Shift+, / .       move window to left/right monitor and follow
  Super+Ctrl+Return       swap focused window with master
  Super+[ / ]             decrease/increase master width by 5%
  Super+grave             toggle scratchpad
  Super+Shift+grave       send window to scratchpad
  Super+R                 reload all Lua modules
  Super+Shift+R           restart Waybar
  Super+Ctrl+L            lock immediately, with no grace period
  Super+Escape            power menu
  Print                   select screenshot region, copy, optional markup
  Super+P                 CopyQ
  Super+Shift+P           Hyprpicker, copy color
  Super+left/right drag   move/resize windows
  Super+mouse wheel       previous/next existing workspace
  Super+/ and Super+\    dwindle split controls

Versions verified against upstream stable releases
  Hyprland                    0.56.2
  hyprlock                    0.9.6
  hypridle                    0.1.8
  hyprpaper                   0.8.4
  hyprpicker                  0.4.7
  hyprpolkitagent             0.2.0
  xdg-desktop-portal-hyprland  1.4.1
  hyprland-guiutils            0.2.2
These are the installed upstream versions; Arch package release suffixes differ.
No new dependencies or plugins are fetched by this configuration. Existing
Waybar and application packages remain installed. Keep Arch system updates
coherent; this version record is not a pacman IgnorePkg list.

Research
  https://github.com/hyprwm/Hyprland/releases/tag/v0.56.2
  https://hypr.land/news/26_lua/
  https://wiki.hypr.land/Configuring/Start/
  https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
  https://wiki.hypr.land/hypr-ecosystem/user/hypridle/
  https://wiki.hypr.land/hypr-ecosystem/user/hyprlock/
  https://wiki.hypr.land/hypr-ecosystem/user/hyprpaper/
  https://github.com/hyprwm/hyprlock/releases/tag/v0.9.6
  https://github.com/hyprwm/hypridle/releases/tag/v0.1.8
  https://github.com/hyprwm/hyprpaper/releases/tag/v0.8.4
  https://github.com/hyprwm/hyprpicker/releases/tag/v0.4.7
  https://github.com/hyprwm/hyprpolkitagent/releases/tag/v0.2.0
  https://github.com/hyprwm/xdg-desktop-portal-hyprland/releases/tag/v1.4.1
  https://github.com/hyprwm/hyprland-guiutils/releases/tag/v0.2.2
  https://github.com/Alexays/Waybar/wiki/Module:-Hyprland

Validation
  Hyprland --verify-config -c ~/.config/hypr/hyprland.lua
Actual monitor placement, authentication, idle/suspend/wake, screen sharing,
and Waybar need a real Hyprland login to validate end to end.
