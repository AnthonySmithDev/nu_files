local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local colors = wezterm.color.get_builtin_schemes()['ayu']

colors.tab_bar = {
  background = "#1F2430",
  active_tab = {
    bg_color = "#0A0E14",
    fg_color = "#E6B450",
    intensity = "Bold",
    underline = "None",
    italic = false,
    strikethrough = false,
  },
  inactive_tab = {
    bg_color = "#1F2430",
    fg_color = "#707A8C",
  },
  inactive_tab_hover = {
    bg_color = "#1F2430",
    fg_color = "#707A8C",
    italic = true,
  },
  new_tab = {
    bg_color = "#1F2430",
    fg_color = "#707A8C",
  },
  new_tab_hover = {
    bg_color = "#1F2430",
    fg_color = "#E6B450",
    italic = true,
  }
}

config.colors = colors
config.color_scheme = 'ayu'

config.window_decorations = "NONE"
config.window_background_opacity = 0.9
config.window_close_confirmation = "NeverPrompt"

-- config.enable_tab_bar = false
config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

config.font_size = 11
config.font = wezterm.font_with_fallback({
  'FiraCode Nerd Font',
  'JetBrains Mono',
  'Cascadia Code',
})

config.default_prog = { 'nu', '-l' }

-- local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
local modal = wezterm.plugin.require("https://github.com/AnthonySmithDev/modal.wezterm")
modal.apply_to_config(config)

if config.keys == nil then
    config.keys = {}
end

table.insert(config.keys, {
	key = "s",
	mods = "CTRL|SHIFT",
	action = modal.activate_mode("Scroll"),
})

table.insert(config.keys, {
	key = "u",
	mods = "CTRL|SHIFT",
	action = modal.activate_mode("UI"),
})

table.insert(config.keys, {
	key = "c",
	mods = "ALT",
	action = modal.activate_mode("copy_mode"),
})

wezterm.on("modal.enter", function(name, window, pane)
  modal.set_right_status(window, name)
  modal.set_window_title(pane, name)
end)

wezterm.on("modal.exit", function(name, window, pane)
  window:set_right_status("NOT IN A MODE")
  modal.reset_window_title(pane)
end)

return config
