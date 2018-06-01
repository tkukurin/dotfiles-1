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

    -- Switch Wacom pen buttons; click button is secondary
    "xinput set-prop 'Wacom Intuos PT M Pen stylus' 293 1572865",
    "xinput set-prop 'Wacom Intuos PT M Pen stylus' 294 1572867",

    -- Touchpads: tap to click
    "xinput set-prop 'ETPS/2 Elantech Touchpad' 278 1",
    -- Touchpads: natural scrolling
    "xinput set-prop 'ETPS/2 Elantech Touchpad' 286 1",
    -- Touchpads: Tapping drag
    "xinput set-prop 'ETPS/2 Elantech Touchpad' 280 0",
    -- Touchpads: disable touchpad while typing
    "xinput set-prop 'ETPS/2 Elantech Touchpad' 288 1",

    -- Lock screen and suspend
    "xss-lock -- betterlockscreen -s dim",
}
if autorun then
   for app = 1, #autorunApps do
       awful.spawn.with_shell(autorunApps[app])
   end
end
