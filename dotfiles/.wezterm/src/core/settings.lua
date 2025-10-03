local M = {}

function M.apply(wezterm, config)
  -- General
  config.front_end = "OpenGL"
  config.term = "xterm-256color"
  config.prefer_egl = true

  -- QoL
  config.check_for_updates = false
  config.automatically_reload_config = true
  config.window_close_confirmation = "NeverPrompt"
  config.switch_to_last_active_tab_when_closing_tab = true

  -- Initial size
  config.initial_cols = 135
  config.initial_rows = 35

  -- Font
  config.font = wezterm.font("JetBrainsMonoNL Nerd Font", { weight = "Regular" })
  config.font_size = 14.0
  config.tab_max_width = 32

  -- Background
  config.window_background_opacity = 0.9
  config.window_decorations = "NONE | RESIZE"
  config.window_frame = {
    font = wezterm.font("JetBrainsMonoNL Nerd Font", { weight = "Regular" }),
    active_titlebar_bg = "#0c0b0f",
  }

  -- Color Scheme
  config.color_scheme = "Tango (terminal.sexy)"
  config.colors = {
    background = "#090c10",
    tab_bar = {
      background = "#0f141a",
      active_tab = { fg_color = "#c0c0c0", bg_color = "#000000" },
      inactive_tab = { fg_color = "#c0c0c0", bg_color = "#1b2b38" },
      new_tab = { fg_color = "#c0c0c0", bg_color = "#0f141a" },
    }
  }

  -- Padding
  config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

  -- FPS
  config.max_fps = 240
  config.animation_fps = 60

  -- Tab Bar
  config.enable_tab_bar = true
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.hide_tab_bar_if_only_one_tab = true

  -- Cursor
  config.default_cursor_style = "BlinkingBar"
  config.cursor_thickness = 2
  config.cursor_blink_rate = 500
end

return M
