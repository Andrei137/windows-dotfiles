local wezterm = require("wezterm")

local function add_to_path(folder)
  local files = (folder == "utils" and "init" or "?") .. ".lua"
  local path = wezterm.config_dir .. "/" .. folder .. "/" .. files
  package.path = package.path .. ";" .. path
end
add_to_path("core");
add_to_path("plugins");

local config = wezterm.config_builder()
require("startup").apply(wezterm, config)
require("settings").apply(wezterm, config)
require("bindings").apply(wezterm, config)
require("cmd-sender").apply(wezterm, config)

return config
