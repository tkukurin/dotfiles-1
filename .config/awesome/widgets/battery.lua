local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")

-- acpi sample outputs
-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

-- Popup with battery info
-- One way of creating a pop-up notification - naughty.notify
local notification
local function showBatteryStatus()
    awful.spawn.easy_async([[bash -c 'acpi']],
            function(stdout, _, _, _)
                notification = naughty.notify {
                    text = stdout,
                    title = "Battery status",
                    timeout = 5, hover_timeout = 0.5,
                    width = 200,
                }
            end
    )
end

local function showBatteryWarning()
    naughty.notify {
        text = "Houston, we have a problem",
        title = "Battery is dying . . . give it some juice!",
        timeout = 5, hover_timeout = 0.5,
        position = "bottom_right",
        bg = "#F06060",
        fg = "#EEE9EF",
        width = 300,
    }
end

local colors = {
    "#8f0000",
    "#bd7500",
    "#d4c600",
    "#568e00",
    "#008f00",
    "#008f00"
}

local batteryWidget = wibox.widget {
    max_value = 100,
    thickness = 2,
    start_angle = math.pi + math.pi / 2,
    widget = wibox.container.arcchart
}

awful.widget.watch(
        "acpi",
        10,
        function(widget, stdout, stderr, exitreason, exitcode)
            local _, status, charge_str, time = string.match(stdout, '(.+): (%a+), (%d?%d?%d)%%,? ?.*')
            local charge = tonumber(charge_str)
            local stepSize = 100 / #colors
            local rangeIndex = math.floor(charge / stepSize) + 1
            widget.value = charge
            widget.colors = { colors[rangeIndex] }
            if rangeIndex > #colors then
                widget.colors = { colors[rangeIndex - 1] }
            end
            if status == 'Charging' then
                widget.thickness = 4
            else
                widget.thickness = 2
                if (charge >= 0 and charge < 15) then
                    showBatteryWarning()
                end
            end

        end,
        batteryWidget
)

batteryWidget:connect_signal("mouse::enter", function()
    showBatteryStatus()
end)
batteryWidget:connect_signal("mouse::leave", function()
    naughty.destroy(notification)
end)

return wibox.container.margin(
        wibox.container.mirror(
                batteryWidget,
                { horizontal = true }
        ),
        2,
        2,
        2,
        2
)
