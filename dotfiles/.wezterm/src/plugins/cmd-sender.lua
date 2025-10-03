local M = {}

function M.apply(wezterm, config)
  -- Send the same command to all panes of the active tab
  local cmd_sender = wezterm.plugin.require("https://github.com/aureolebigben/wezterm-cmd-sender")

  cmd_sender.apply_to_config(config, {
    key = "e",
    mods = "LEADER",
    description = "Enter command to send to all panes of active tab"
  })
end

return M
