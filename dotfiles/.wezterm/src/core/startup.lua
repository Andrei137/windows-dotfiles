local M = {}

function M.apply(wezterm, config)
  wezterm.on('gui-startup', function(cmd)
    local position = 120
    local tab, pane, window = wezterm.mux.spawn_window(cmd or
      { position={ x=position,y=position } }
    )
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
