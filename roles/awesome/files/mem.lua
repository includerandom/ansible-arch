    memwidget  = wibox.widget.graph()
        memwidget:set_width(20)
        cpuwidget:set_color(gears.color.create_solid_pattern("#00ff00"))
        vicious.cache(vicious.widgets.mem)
        memwidget.opacity = "1"
        vicious.register(memwidget, vicious.widgets.mem, "$1", 11)
    beautiful.graph_bg = "#00000000"