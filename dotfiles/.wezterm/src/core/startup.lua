local M = {}

function M.apply(wezterm, config)
  wezterm.on("gui-startup", function(cmd)
    local screen = wezterm.gui.screens().active
    local ratio = 0.9
    local width, height = screen.width * ratio, screen.height * ratio
    local tab, pane, window = wezterm.mux.spawn_window {
      position = {
        x = (screen.width - width) / 2,
        y = (screen.height - height) / 2,
        origin = 'ActiveScreen' }
    }
    window:gui_window():set_inner_size(width, height)
  end)

  -- Domains
  config.default_prog = { "pwsh.exe", "-NoLogo" }
  config.wsl_domains = {
    {
      name = "WSL:Ubuntu",
      distribution = "Ubuntu",
      username = "andrei13"
    }
  }
end

return M
