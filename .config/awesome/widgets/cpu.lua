-------------------------------------------------
-- CPU Widget for Awesome Window Manager
-- Shows the current CPU utilization
-- Based on:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/cpu-widget
-- @author Pavel Makhov
-- @copyright 2017 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")

local colors = {
    "#008f00",
    "#568e00",
    "#d4c600",
    "#bd7500",
    "#8f0000"
}

local cpugraph_widget = wibox.widget {
    max_value = 100,
    background_color = "#00000000",
    forced_width = 50,
    step_width = 1,
    step_spacing = 0,
    widget = wibox.widget.graph
}

-- mirror and push up a bit
local cpu_widget = wibox.container.margin(
        wibox.container.mirror(
                cpugraph_widget,
                { horizontal = true }
        ),
        3,
        3,
        0,
        2
)

local total_prev = 0
local idle_prev = 0

awful.widget.watch("cat /proc/stat | grep '^cpu '", 1,
        function(widget, stdout, stderr, exitreason, exitcode)
            local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice = stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')
            local total = user + nice + system + idle + iowait + irq + softirq + steal
            local diff_idle = idle - idle_prev
            local diff_total = total - total_prev
            local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10
            local stepSize = 100 / #colors
            local rangeIndex = math.floor(diff_usage / stepSize) + 1
            widget:set_color(colors[rangeIndex])
            widget:add_value(diff_usage)

            total_prev = total
            idle_prev = idle
        end,
        cpugraph_widget
)

return cpu_widget