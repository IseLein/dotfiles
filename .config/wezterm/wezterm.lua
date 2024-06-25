local wezterm = require('wezterm')

local config = {
    hide_tab_bar_if_only_one_tab = true,
    use_fancy_tab_bar = false,
    window_background_opacity = 0.9,
    -- font = wezterm.font(
        -- 'Iosevka Term Extended',
        -- { weight = 'Medium' }
    -- ),
    -- font = wezterm.font('Liga SFMono Nerd Font'),
    font_size = 13,
    -- color_scheme = "Alabaster",
    color_scheme = "Moonfly (Gogh)",
    window_padding = {
        bottom = 0,
        right = 0,
        top = 0,
        left = 0,
    },
}

return config
