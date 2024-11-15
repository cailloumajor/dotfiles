local wezterm = require "wezterm"

local config = wezterm.config_builder()

-- Thanks to https://github.com/wez/wezterm/issues/3173#issuecomment-1722531883
wezterm.on("window-config-reloaded", function(window, pane)
    -- approximately identify this gui window, by using the associated mux id
    local id = tostring(window:window_id())

    -- maintain a mapping of windows that we have previously seen before in this event handler
    local seen = wezterm.GLOBAL.seen_windows or {}
    -- set a flag if we haven't seen this window before
    local is_new_window = not seen[id]
    -- and update the mapping
    seen[id] = true
    wezterm.GLOBAL.seen_windows = seen

    -- now act upon the flag
    if is_new_window then
        window:maximize()
    end
end)

config.color_scheme = "Monokai (dark) (terminal.sexy)"

config.font = wezterm.font "Hack Nerd Font"

config.hide_tab_bar_if_only_one_tab = true

config.keys = {
    {
        key = "E",
        mods = "CTRL",
        action = wezterm.action_callback(function(window, pane)
            local ansi = window:get_selection_escapes_for_pane(pane)
            window:copy_to_clipboard(ansi)
        end),
    },
}

return config
