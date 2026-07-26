local wezterm = require("wezterm")

local function add_to_path(folder)
  package.path = package.path .. ";" .. wezterm.config_dir .. "/" .. folder .. "/?.lua"
end

add_to_path("core");
add_to_path("plugins");

local config = wezterm.config_builder()
require("startup").apply(wezterm, config)
require("settings").apply(wezterm, config)
require("bindings").apply(wezterm, config)
require("cmd-sender").apply(wezterm, config)

return config
