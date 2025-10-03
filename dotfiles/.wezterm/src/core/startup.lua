local utils = require("utils")

local M = {}

function M.apply(wezterm, config)
  wezterm.on('gui-startup', function(cmd)
    require("utils").startup(wezterm.mux, cmd)
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
