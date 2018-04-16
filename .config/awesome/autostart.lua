-- Autorun programs
local awful = require("awful")
autorun = true
autorunApps = {
    "systemctl --user start awesome.target",
    "xrandr --output eDP1 --mode 1920x1080 --pos 1920x0 --output HDMI1 --primary --mode 1920x1080 --pos 0x0",
    "compton -b",
    "pactray",
    "/usr/lib/gsd-xsettings",
    "dex -a -e awesome",
    "udiskie",

    -- Switch pen buttons; click button is secondary
    "xsetwacom --set 'Wacom Intuos PT M Pen stylus' button 3 2",
    "xsetwacom --set 'Wacom Intuos PT M Pen stylus' button 2 3",

    -- Touchpad: tap to click
    "xinput set-prop 10 275 1",
    "xinput set-prop 10 277 1",
    -- Touchpad: natural scrolling
    "xinput set-prop 10 283 1",
    -- Touchpad: disable touchpad while typing
    "xinput set-prop 10 285 1",

    -- Lock screen and suspend
    "xss-lock -- betterlockscreen -s dim",
}
if autorun then
   for app = 1, #autorunApps do
       awful.spawn.with_shell(autorunApps[app])
   end
end
