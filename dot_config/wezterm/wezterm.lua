local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 28

config.font_size = 11
config.color_scheme = "Modus-Vivendi"

config.scrollback_lines = 8192
config.enable_scroll_bar = true

config.mux_enable_ssh_agent = false

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_prog = { 'C:/Users/hohe/scoop/shims/pwsh.exe', '-NoLogo' }
    config.font = wezterm.font("Aporetic Serif Mono")
end

return config
