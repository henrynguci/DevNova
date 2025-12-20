local wezterm = require 'wezterm'
local commands = require 'commands'
local config = wezterm.config_builder()
-- Font settings
config.font_size = 11
config.line_height = 1.2
config.font = wezterm.font_with_fallback {
  {
    family = 'JetBrainsMono Nerd Font',
    harfbuzz_features = {
      'calt',
      'ss01',
      'ss02',
      'ss03',
      'ss04',
      'ss05',
      'ss06',
      'ss07',
      'ss08',
      'ss09',
      'liga',
    },
  },
  { family = 'Symbols Nerd Font Mono' },
}
config.font_rules = {
  {
    font = wezterm.font('JetBrainsMono Nerd Font', {
      bold = true,
    }),
  },
  {
    italic = true,
    font = wezterm.font('JetBrainsMono Nerd Font', {
      italic = true,
    }),
  },
}
-- Colors
config.color_scheme = 'Catppuccin Mocha'
config.colors = {
  tab_bar = {
    background = "#181825",
    active_tab = {
      bg_color = "#89b4fa",
      fg_color = "#181825",
      intensity = "Bold",
      underline = "None",
      italic = false,
    },
    inactive_tab = {
      bg_color = "#313244",
      fg_color = "#cdd6f4",
      intensity = "Normal",
      underline = "None",
      italic = false,
    },
    inactive_tab_hover = {
      bg_color = "#45475a",
      fg_color = "#f38ba8",
      italic = true,
    },
    new_tab = {
      bg_color = "#181825",
      fg_color = "#cdd6f4",
    },
    new_tab_hover = {
      bg_color = "#313244",
      fg_color = "#a6e3a1",
    },
  },
}
-- Appearance
config.cursor_blink_rate = 0
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 2,
  right = 2,
  top = 2,
  bottom = 2,
}
-- Miscellaneous settings
config.max_fps = 240
config.prefer_egl = true
config.enable_wayland = true
config.initial_rows = 30
config.initial_cols = 150
-- Custom commands
wezterm.on('augment-command-palette', function()
  return commands
end)
-- Tab bar toggle state
_G.hide_tab_bar = true
config.hide_tab_bar_if_only_one_tab = _G.hide_tab_bar
-- Keyboard shortcuts
config.keys = {
  -- Copy/Paste
  { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },
-- Split pane
{ key = 'a', mods = 'ALT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
{ key = 'w', mods = 'ALT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
{ key = 's', mods = 'ALT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
{ key = 'd', mods = 'ALT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    -- Pane navigation
    { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'UpArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'DownArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },
    -- Tab navigation
    { key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
    -- New tab
    { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
    -- Close tab/pane
    { key = 'w', mods = 'CTRL', action = wezterm.action.CloseCurrentPane { confirm = true } },
    -- Reload config
    { key = 'r', mods = 'CTRL|SHIFT', action = wezterm.action.ReloadConfiguration },
    -- Quick command palette
    { key = 'p', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateCommandPalette },
    -- Font size zoom in/out (chỉ thay đổi cỡ chữ)
    { key = '=', mods = 'CTRL', action = 'IncreaseFontSize' },
    { key = '+', mods = 'CTRL', action = 'IncreaseFontSize' },
    { key = '-', mods = 'CTRL', action = 'DecreaseFontSize' },
    { key = '0', mods = 'CTRL', action = 'ResetFontSize' },
    -- Toggle tab bar visibility (Alt+t)
    {
        key = 't',
        mods = 'ALT',
        action = wezterm.action_callback(function(window, pane)
            _G.hide_tab_bar = not _G.hide_tab_bar
            window:set_config_overrides({
                hide_tab_bar_if_only_one_tab = _G.hide_tab_bar
            })
        end),
    },
    -- Toggle fullscreen (Alt+f)
    {
        key = 'f',
        mods = 'ALT',
        action = wezterm.action.ToggleFullScreen,
    },
}
return config
