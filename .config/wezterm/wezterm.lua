local wezterm = require('wezterm')

local keys = {
    {
        key = "%",
        mods = "LEADER|SHIFT",
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = "\"",
        mods = "LEADER|SHIFT",
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = "c",
        mods = "LEADER",
        action = wezterm.action.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = "h",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection 'Left', },
    {
        key = "l",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection 'Right',
    },
    {
        key = "j",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection 'Up',
    },
    {
        key = "k",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection 'Down',
    },
    {
        key = "H",
        mods = "LEADER",
        action = wezterm.action.AdjustPaneSize { 'Left', 5 },
    },
    {
        key = "L",
        mods = "LEADER",
        action = wezterm.action.AdjustPaneSize { 'Right', 5 },
    },
    {
        key = "J",
        mods = "LEADER",
        action = wezterm.action.AdjustPaneSize { 'Up',5 },
    },
    {
        key = "K",
        mods = "LEADER",
        action = wezterm.action.AdjustPaneSize { 'Down', 5 },
    },
}

for i = 1, 8 do
    table.insert(keys, {
        key = tostring(i),
        mods = "LEADER",
        action = wezterm.action.ActivateTab(i - 1),
    })
end

local config = {
    hide_tab_bar_if_only_one_tab = true,
    use_fancy_tab_bar = false,
    -- font = wezterm.font("Berkeley Mono Variable", { weight = "Light" }),
    -- font = wezterm.font("TX-02"),
    font = wezterm.font("Iosevka Ishuz", { weight = "Regular" }),
    font_size = 15,
    -- color_scheme = "Alabaster",
    color_scheme = "flexoki-light",
    window_padding = {
        bottom = 0,
        right = 0,
        top = 0,
        left = 0,
    },
    leader = {
        key = "a",
        mods = "CTRL",
        timeout_milliseconds = 1000
    },
    tab_bar_at_bottom = true,
    keys = keys,
    enable_wayland = false,
    enable_kitty_graphics=true,
}

return config
