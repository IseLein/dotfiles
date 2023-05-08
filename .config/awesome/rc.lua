-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
require("collision")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local vicious = require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.font = "JetBrainsMono Nerd Font Mono 12"
beautiful.bg_normal = "#1e1e2e"
-- beautiful.bg_focus = "#a6e3a1"
beautiful.bg_focus = "#eba0ac"
-- beautiful.fg_normal = "#f5e0dc"
beautiful.fg_focus = "#a6e3a1"
beautiful.border_focus = "#eba0ac"
-- beautiful.border_focus = "#a6e3a1"
beautiful.border_normal = "#11111b"
beautiful.border_width = 1
beautiful.layoutbox_fg_normal = "#f38ba8"
beautiful.bg_systray = "#45475a"
beautiful.systray_icon_spacing = 4
beautiful.notification_shape = gears.shape.rounded_rect
beautiful.notification_opacity = 0.9
beautiful.notification_border_color = "#1e1e2e00"
beautiful.notification_fg = "#ffffff"
beautiful.notification_bg = "#45475a"
beautiful.notification_max_width = 500
beautiful.notification_icon_size = 84
beautiful.notification_margin = 20

-- This is used later as the default terminal and editor to run.
terminal = "wezterm"
editor = os.getenv("nvim") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
mytextclock.bg = "#1e1e2e"

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
	layout = {
	    spacing = 1,
	    spacing_widget = {
		{
		    forced_height = 16,
		    forced_width = 1,
		    color = "#cdd6f4",
		    widget = wibox.widget.separator,
		},
		valign = "center",
		halign = "center",
		widget = wibox.container.place,
	    },
	    layout = wibox.layout.fixed.horizontal,
	},
	widget_template = {
	    {
	        id = "text_role",
	        widget = wibox.widget.textbox,
    	    },
	    left = 8,
	    right = 8,
	    widget = wibox.container.margin,
	    create_callback =function(self, c3, index, objects)
		self:get_children_by_id("text_role")[1].markup = "<b> " ..index.." </b>"
	    end,
	    update_callback =function(self, c3, index, objects)
		self:get_children_by_id("text_role")[1].markup = "<b> " ..index.." </b>"
	    end,
	},
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
	layout = {
	    spacing_widget = {
		{
                    forced_height = 16,
		    forced_width = 5,
		    thickness = 1,
		    color = "#cdd6f4",
		    widget = wibox.widget.separator,
	        },
		valign = "center",
		halign = "center",
		widget = wibox.container.place,
	    },
	    spacing = 1,
	    layout = wibox.layout.fixed.horizontal,
	},
	widget_template = {
	    {
		{
	            {
	                wibox.widget.base.make_widget(),
	                forced_height = 2,
	                id = "background_role",
	                widget = wibox.container.background,
	            },
		    top = 5,
	            left = 9,
	            right = 12,
	            layout = wibox.container.margin,
		},
		bg = "#1e1e2e00",
		widget = wibox.container.background,
	    },
	    {
		{
	            {
	                id = "clienticon",
	                widget = awful.widget.clienticon,
	            },
	            top = 3,
	            left = 8,
		    right = 4,
		    bottom = 6,
	            widget = wibox.container.margin,
		},
		bg = "#1e1e2e00",
		widget = wibox.container.background,
	    },
	    nil,
	    create_callback = function(self, c, index, objects)
		self:get_children_by_id("clienticon")[1].client = c
	    end,
	    layout = wibox.layout.align.vertical,
	},
    }

    -- logo
    mytextlogo = wibox.widget.textbox()
    -- mytextlogo.text = ""
    -- mytextlogo.font = "18"
    mytextlogo:set_markup("<span foreground='#f38ba8' font='26'></span>")
    padded_logo = wibox.container.margin(mytextlogo, 14, 20, 0, 0)
    bg_logo = wibox.container.background(padded_logo, "#1e1e2ebf")

    -- textclock
    month_calendar = awful.widget.calendar_popup.month({
	margin = 8,
	opacity = 0.95,
	start_sundays = true,
	style_normal = {
	    border_width = 0,
	},
	style_focus = {
	    border_width = 0,
	    bg_color = "#89b4fa",
	    fg_color = "#1e1e2e",
	},
	style_weekday = {
	    border_width = 0,
	},
	style_header = {
	    border_width = 0,
	},
    })
    month_calendar:attach(mytextclock, "tr")
    textclock_widget = {
	{
	    {
	        mytextclock,
		left = 4,
		right = 4,
		widget = wibox.container.margin,
	    },
	    bg = "#45475a",
	    fg = "#89b4fa",
	    shape = gears.shape.rounded_bar,
	    widget = wibox.container.background,
	},
	top = 7,
	right = 6,
	bottom = 7,
	widget = wibox.container.margin,
    }


    middle = wibox.widget {
	{
	    layout = wibox.layout.align.horizontal,
	    expand = "outside",
	    wibox.widget.textbox(),
	    {
		    {
		        {
		            {
	        	        s.mytasklist,
		                left = 12,
		                right = 12,
		                widget = wibox.container.margin,
		            },
		            bg = "#1e1e2ebf",
		            widget = wibox.container.background,
		        },
		        shape = gears.shape.rounded_bar,
		        shape_border_width = 2,
		        shape_border_color = "#cba6f7",
		        shape_clip = true,
		        widget = wibox.container.background,
		    },
		    left = 1,
		    right = 1,
		    border_width = 1,
		    border_color = "#cba6f7",
		    widget = wibox.container.margin,
	    },
	    wibox.widget.textbox(),
	},
	left = 0,
	right = 0,
	top = 3,
	bottom = 0,
	widget = wibox.container.margin,
    }
    middle.visible = false

    local update_middlebar = function()
        local client_count = 0
        for _, c in ipairs(client.get()) do
            if awful.widget.tasklist.filter.currenttags(c, s) then
                client_count = client_count + 1
            end
        end

        if client_count == 0 then
            middle.visible = false
        else
            middle.visible = true
        end
    end

    tag.connect_signal("property::selected", update_middlebar)
    tag.connect_signal("property::activated", update_middlebar)
    client.connect_signal("list", update_middlebar)
    client.connect_signal("property::sticky", update_middlebar)
    client.connect_signal("property::skip_taskbar", update_middlebar)
    client.connect_signal("property::hidden", update_middlebar)
    client.connect_signal("tagged", update_middlebar)
    client.connect_signal("untagged", update_middlebar)
    client.connect_signal("list", update_middlebar)

    s.mytasklist:connect_signal("property::count", function(new_val)
        -- naughty.notify({ preset = naughty.config.presets.critical,
        --                  title = "Oops, there were errors during startup!"..tostring(new_val),
        --                  text = awesome.startup_errors })
	s.mytasklist.visible = false
    end)

    battery_text = wibox.widget {
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
    }
    battery_icon = wibox.widget {
	align = "center",
	valign = "center",
	font = "12",
	widget = wibox.widget.textbox,
    }
    battery_charge_status = wibox.widget {
	text = " ⚡",
	widget = wibox.widget.textbox,
    }
    battery_widget = wibox.widget {
	{
	    {
	        layout = wibox.layout.fixed.horizontal,
	        battery_icon,
		{
		    battery_charge_status,
		    fg = "#fab387",
		    widget = wibox.container.background,
		},
	        battery_text,
	    },
	    left = 8,
	    right = 8,
	    widget = wibox.container.margin,
	},
	-- fg = "#f38ba8",
	bg = "#45475a",
	shape = gears.shape.rounded_bar,
	widget = wibox.container.background,
    }
    battery_container_widget = {
	battery_widget,
	top = 7,
	left = 6,
	bottom = 7,
	widget = wibox.container.margin,
    }

    update_battery_capacity = function(capacity)
	battery_icon.text = " "
	if battery_widget.fg ~= "#f38ba8" then
	    battery_widget.fg = "#f38ba8"
	end
	if capacity >= 80 then
	    battery_icon.text = " "
	    if battery_widget.fg ~= "#a6e3a1" then
		battery_widget.fg = "#a6e3a1"
	    end
    	elseif capacity >= 60 then
	    battery_icon.text = " "
	    if battery_widget.fg ~= "#a6e3a1" then
		battery_widget.fg = "#a6e3a1"
	    end
    	elseif capacity >= 40 then
	    battery_icon.text = " "
	    if battery_widget.fg ~= "#a6e3a1" then
		battery_widget.fg = "#a6e3a1"
	    end
	end
	battery_text.text = " "..capacity.."%"
    end

    update_battery_status = function(isDischarging)
	battery_charge_status.visible = not isDischarging
    end

    awful.widget.watch('bash -c "cat /sys/class/power_supply/BAT0/capacity"', 60, function(self, stdout)
	capacity = tonumber(stdout)
	update_battery_capacity(capacity)
    end)

    awful.widget.watch('bash -c "cat /sys/class/power_supply/BAT0/status"', 60, function(self, stdout)
	update_battery_status(string.sub(stdout, 1, 1) == "D")
    end)

    systray_widget = {
	{
	    {
	        wibox.widget.systray(),
		left = 6,
		right = 6,
		top = 3,
		bottom = 3,
		widget = wibox.container.margin,
	    },
	    bg = "#45475a",
	    shape = gears.shape.rounded_bar,
	    widget = wibox.container.background,
	},
	top = 7,
	bottom = 7,
	left = 12,
	widget = wibox.container.margin
    }

    mem_icon = wibox.widget.textbox("󰋊 ")
    mem_icon.font = "14"
    memwidget = wibox.widget.textbox()

    fs_icon = wibox.widget.textbox("  ")
    fs_icon.font = "14"
    fs_text = wibox.widget.textbox()

    ram_widget = {
        {
	    {
		{
		    layout = wibox.layout.fixed.horizontal,
		    mem_icon,
		    memwidget,
		    fs_icon,
		    fs_text,
		},
		left = 12,
		right = 8,
		top = 3,
		bottom = 3,
		widget = wibox.container.margin
	    },
	    bg = "#45475a",
	    fg = "#b4befe",
	    shape = gears.shape.rounded_bar,
	    widget = wibox.container.background,
	},
	top = 7,
	bottom = 7,
	left = 12,
	widget = wibox.container.margin
    }
    vicious.cache(vicious.widgets.mem)
    vicious.register(memwidget, vicious.widgets.mem, 
        function(widget, args)
	    local usage = tonumber(args[2]) / 1024
	    if usage then
		return args[1].."%("..string.format("%.1f", usage).."GB)"
	    end
	end,
     13)

    vicious.cache(vicious.widgets.fs)
    vicious.register(fs_text, vicious.widgets.fs, "${/home used_gb}GB", 13)

    volume_icon = wibox.widget.textbox()
    volume_icon.font = "13"
    volume_text = wibox.widget.textbox()
    vol_widget = wibox.widget {
	{
	    {
	        layout = wibox.layout.fixed.horizontal,
	        volume_icon,
	        volume_text
	    },
	    left = 1,
	    right = 5,
	    widget = wibox.container.margin
	},
        widget = wibox.container.background
    }
    brightness_icon = wibox.widget.textbox("󰃟 ")
    brightness_icon.font = "13"
    brightness_text = wibox.widget.textbox()
    bright_widget = wibox.widget {
	{
	    {
	        layout = wibox.layout.fixed.horizontal,
	        brightness_icon,
	        brightness_text
	    },
	    left = 5,
	    right = 1,
	    widget = wibox.container.margin
	},
	fg = "#f9e2af",
        widget = wibox.container.background
    }

    volume_brightness_widget = {
        {
	    {
		{
		    layout = wibox.layout.fixed.horizontal,
		    vol_widget,
		    bright_widget
		},
		left = 12,
		right = 12,
		top = 3,
		bottom = 3,
		widget = wibox.container.margin
	    },
	    bg = "#45475a",
	    shape = gears.shape.rounded_bar,
	    widget = wibox.container.background,
	},
	top = 7,
	bottom = 7,
	left = 12,
	widget = wibox.container.margin
    }

    is_muted = false
    update_volume = function(volume)
	volume_text.text = volume
	if tonumber(string.sub(volume, 1, string.len(volume)-1)) == 0 then
	    volume_icon.text = " "
	    vol_widget.fg = "#cdd6f4"
	    is_muted = true
	else
	    volume_icon.text = " "
	    vol_widget.fg = "#74c7ec"
	    is_muted = false
	end
    end

    update_brightness = function(stdout)
	brightness = tostring(math.floor(tonumber(stdout) / 2.55)).."%"
	brightness_text.text = brightness
    end

    awful.widget.watch('bash -c "pactl get-sink-volume @DEFAULT_SINK@ | grep Volume | awk \'{print $5}\'"', 120, function(self, stdout)
	volume = string.sub(stdout, 1, string.len(stdout)-1)
	update_volume(volume)
    end)

    awful.widget.watch('bash -c "cat /sys/class/backlight/amdgpu_bl0/brightness"', 120, function(self, stdout)
	update_brightness(stdout)
    end)

    -- Create the wibox
    s.mywibox = awful.wibar({
	position = "top",
	screen = s,
	height = 40,
	input_passthrough = true,
	bg = "#00000000",
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {-- Left widgets
	    {
	        {
                    layout = wibox.layout.fixed.horizontal,
	    	    bg_logo,
	    	    {
			{
	                    s.mytaglist,
			    right = 12,
			    widget = wibox.container.margin,
			},
			bg = "#1e1e2ebf",
	    	        widget = wibox.container.background,
	    	    },
                    s.mypromptbox,
    	        },
	        shape = gears.shape.rounded_bar,
	        shape_border_width = 2,
	        shape_border_color = "#cba6f7",
	        shape_clip = true,
	        widget = wibox.container.background,
            },
	    left = 6,
	    right = 0,
	    top = 3,
	    bottom = 0,
	    border_width = 1,
	    border_color = "#cba6f7",
	    widget = wibox.container.margin,
	},
        -- s.mytasklist, -- Middle widget
	middle,
	{ -- Right widgets
	    {
		{
		    {
                        {
                            layout = wibox.layout.fixed.horizontal,
		            ram_widget,
		            systray_widget,
		            volume_brightness_widget,
                            mykeyboardlayout,
		            textclock_widget,
		            battery_container_widget,
	                },
		        bg = "#1e1e2ebf",
		        widget = wibox.container.background,
	    	    },
		    right = 12,
		    widget = wibox.container.margin,
		},
		shape = gears.shape.rounded_bar,
		shape_border_width = 2,
		shape_clip = true,
		shape_border_color = "#cba6f7",
		widget = wibox.container.background,
    	    },
	    left = 0,
	    right = 6,
	    top = 3,
	    bottom = 0,
	    border_width = 1,
	    border_color = "#cba6f7",
	    widget = wibox.container.margin,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --           {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Dmenu
    awful.key({ modkey },            "space",     function ()
	awful.util.spawn("rofi -show drun")
    end,
              {description = "rofi - app launcher", group = "rofi"}),

    awful.key({ modkey,           }, "w", function ()
	awful.util.spawn("rofi -show window")
    end,
              {description = "rofi - window launcher", group = "rofi"}),

    awful.key({ modkey,           }, "p", function ()
	awful.util.spawn("rofi -show run")
    end,
              {description = "rofi - run", group = "rofi"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Volume/Brightness
    awful.key({ }, "#232", function ()
	lower_brightness = "light -U 2"
	get_brightness = "cat /sys/class/backlight/amdgpu_bl0/brightness"
	awful.spawn.with_shell(lower_brightness)
	awful.spawn.easy_async(get_brightness, function(stdout, _, _, _)
	    brightness = string.sub(stdout, 1, string.len(stdout)-1)
	    update_brightness(brightness)
	end)
    end,
              {description = "lower brightness", group = "volume / brightness"}),

    awful.key({ }, "#233", function ()
	raise_brightness = "light -A 2"
	get_brightness = "cat /sys/class/backlight/amdgpu_bl0/brightness"
	awful.spawn.with_shell(raise_brightness)
	awful.spawn.easy_async(get_brightness, function(stdout, _, _, _)
	    brightness = string.sub(stdout, 1, string.len(stdout)-1)
	    update_brightness(brightness)
	end)
    end,
              {description = "raise brightness", group = "volume / brightness"}),

    awful.key({ }, "#121",
              function()
                  get_volume = 'bash -c "pactl get-sink-volume @DEFAULT_SINK@ | grep Volume | awk \'{print $5}\'"'
		  new_vol = is_muted and "20" or "0"
		  mute = "pactl set-sink-volume @DEFAULT_SINK@ "..new_vol.."%"
		  play_sound = "paplay ~/dotfiles/audio/mixkit-retro-game-notification-212.wav"
	          awful.spawn.with_shell(mute)
	          -- awful.spawn.with_shell(play_sound)
		  awful.spawn.easy_async(get_volume, function(stdout, _, _, _)
			volume = string.sub(stdout, 1, string.len(stdout)-1)
			update_volume(volume)
	          end)
	      end,
              {description = "(um)mute the volume", group = "volume / brightness"}),
    awful.key({ }, "#122",
              function()
                  get_volume = 'bash -c "pactl get-sink-volume @DEFAULT_SINK@ | grep Volume | awk \'{print $5}\'"'
		  lower_volume = "pactl set-sink-volume @DEFAULT_SINK@ -2%"
		  play_sound = "paplay ~/dotfiles/audio/mixkit-retro-game-notification-212.wav"
	          awful.spawn.with_shell(lower_volume)
	          -- awful.spawn.with_shell(play_sound)
		  awful.spawn.easy_async(get_volume, function(stdout, _, _, _)
			volume = string.sub(stdout, 1, string.len(stdout)-1)
			update_volume(volume)
	          end)
	      end,
              {description = "lower the volume", group = "volume / brightness"}),

    awful.key({ }, "#123",
              function()
                  get_volume = 'bash -c "pactl get-sink-volume @DEFAULT_SINK@ | grep Volume | awk \'{print $5}\'"'
		  raise_volume = "pactl set-sink-volume @DEFAULT_SINK@ +2%"
		  play_sound = "paplay ~/dotfiles/audio/mixkit-retro-game-notification-212.wav"
	          awful.spawn.with_shell(raise_volume)
	          -- awful.spawn.with_shell(play_sound)
		  awful.spawn.easy_async(get_volume, function(stdout, _, _, _)
			volume = string.sub(stdout, 1, string.len(stdout)-1)
			update_volume(volume)
	          end)
	      end,
              {description = "raise the volume", group = "volume / brightness"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    -- { rule_any = {type = { "normal", "dialog" }
    --  }, properties = { titlebars_enabled = true }
    -- },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
-- client.connect_signal("request::titlebars", function(c)
--     -- buttons for the titlebar
--     local buttons = gears.table.join(
--        awful.button({ }, 1, function()
--            c:emit_signal("request::activate", "titlebar", {raise = true})
--            awful.mouse.client.move(c)
--        end),
--        awful.button({ }, 3, function()
--            c:emit_signal("request::activate", "titlebar", {raise = true})
--            awful.mouse.client.resize(c)
--        end)
--    )

--    awful.titlebar(c) : setup {
--        { -- Left
--            awful.titlebar.widget.iconwidget(c),
--            buttons = buttons,
--            layout  = wibox.layout.fixed.horizontal
--        },
--        { -- Middle
--            { -- Title
--                align  = "center",
--                 widget = awful.titlebar.widget.titlewidget(c)
--             },
--             buttons = buttons,
--             layout  = wibox.layout.flex.horizontal
--         },
--         { -- Right
--             awful.titlebar.widget.floatingbutton (c),
--             awful.titlebar.widget.maximizedbutton(c),
--             awful.titlebar.widget.stickybutton   (c),
--             awful.titlebar.widget.ontopbutton    (c),
--             awful.titlebar.widget.closebutton    (c),
--             layout = wibox.layout.fixed.horizontal()
--         },
--         layout = wibox.layout.align.horizontal
--     }
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Rounded windows
client.connect_signal("manage", function(c)
    c.shape = function(cr,w,h)
	gears.shape.rounded_rect(cr,w,h,8)
    end
end)
-- }}}

-- Gaps
beautiful.useless_gap = 5

-- Autostart
awful.spawn.with_shell("picom")
awful.spawn.with_shell("feh --bg-fill --randomize ~/dotfiles/wallpapers/*")
awful.spawn.with_shell("nm-applet")
