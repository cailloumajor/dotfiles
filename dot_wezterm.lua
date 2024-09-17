local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = wezterm.config_builder()

wezterm.on('gui-startup', function (cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

config.color_scheme = 'Monokai Dark (Gogh)'

config.font = wezterm.font 'Hack Nerd Font'

return config
