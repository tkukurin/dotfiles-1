-------------------------------------------------
-- CPU Widget for Awesome Window Manager
-- Shows the current CPU utilization
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/cpu-widget

-- @author Pavel Makhov
-- @copyright 2017 Pavel Makhov
-------------------------------------------------

local watch = require("awful.widget.watch")
local wibox = require("wibox")

local cpugraph_widget = wibox.widget {
    max_value = 100,
    color = '#398f00',
    background_color = "#00000000",
    forced_width = 50,
    step_width = 1,
    step_spacing = 0,
    widget = wibox.widget.graph
}

-- mirros and pushs up a bit
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

watch("cat /proc/stat | grep '^cpu '", 1,
        function(widget, stdout, stderr, exitreason, exitcode)
            local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice = stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')
            local total = user + nice + system + idle + iowait + irq + softirq + steal
            local diff_idle = idle - idle_prev
            local diff_total = total - total_prev
            local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

            if diff_usage > 80 then
                widget:set_color('#8f0000')
            elseif diff_usage > 50 then
                widget:set_color('#e1a400')
            else
                widget:set_color('#398f00')
            end

            widget:add_value(diff_usage)

            total_prev = total
            idle_prev = idle
        end,
        cpugraph_widget
)

return cpu_widget