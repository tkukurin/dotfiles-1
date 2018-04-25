-------------------------------------------------
-- Volume Widget for Awesome Window Manager
-- Shows the current volume
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")

local updateInterval = 1

local colors = {
    "#008f00",
}

local volumeWidget = wibox.widget {
    max_value = 100,
    thickness = 2,
    start_angle = math.pi + math.pi / 2,
    widget = wibox.container.arcchart
}

local function hideIcon()
    volumeWidget.widget = nul
end

local function showIcon()
    volumeWidget.widget = wibox.widget {
        markup = "<span color='#c0c0c0'></span>",
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox,
        buttons = awful.util.table.join(
                awful.button({}, 1, function()
                    awful.spawn('pactl set-sink-mute 0 toggle')
                end),
                awful.button({}, 3, function()
                    awful.spawn('pavucontrol')
                end),
                awful.button({ }, 5, function()
                    awful.spawn("pactl set-sink-volume 0 +3%")
                end),
                awful.button({ }, 4, function()
                    awful.spawn("pactl set-sink-volume 0 -3%")
                end)
        )
    }
end

local lastVolume = 0

awful.widget.watch(
        "pamixer --get-volume",
        updateInterval,
        function(widget, stdout, stderr, exitreason, exitcode)
            local stepSize = 100 / #colors
            local rangeIndex = math.floor(stdout / stepSize) + 1
            lastVolume = stdout
            widget.value = stdout
            widget.colors = { colors[rangeIndex] }
            if rangeIndex > #colors then
                widget.colors = { colors[rangeIndex - 1] }
            end
        end,
        volumeWidget
)

local volumeWidgetTooltip = awful.tooltip({
    objects = { volumeWidget },
    timer_function = function()
        return "Volume: " .. lastVolume
    end,
})

volumeWidget:connect_signal("mouse::enter", function()
    showIcon()
end)
volumeWidget:connect_signal("mouse::leave", function()
    hideIcon()
end)

return wibox.container.margin(
        wibox.container.mirror(
                volumeWidget,
                { horizontal = true }
        ),
        2,
        2,
        2,
        2
)
