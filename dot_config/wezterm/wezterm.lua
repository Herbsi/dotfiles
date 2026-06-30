local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Modus-Vivendi"
config.default_prog = { "zellij" }
config.enable_kitty_keyboard = true
config.enable_scroll_bar = true
config.font = wezterm.font("Triplicate A Code")
config.font_size = 11
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 120
config.initial_rows = 28
config.mux_enable_ssh_agent = false
config.scrollback_lines = 8192

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { "C:/Users/hohe/scoop/shims/pwsh.exe", "-NoExit", "-Command", "zellij -l welcome" }
    config.font = wezterm.font("Aporetic Serif Mono")
    config.allow_win32_input_mode = false
end

return config
