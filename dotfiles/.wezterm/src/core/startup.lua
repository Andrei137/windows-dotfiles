local M = {}

function M.apply(wezterm, config)
	wezterm.on("gui-startup", function()
		local screen = wezterm.gui.screens().active
		local tab, pane, window = wezterm.mux.spawn_window({})
		local gui_window = window:gui_window()

		gui_window:set_inner_size(screen.width * 0.975, screen.height * 0.925)

		wezterm.sleep_ms(10)

		local dims = gui_window:get_dimensions()
		local outer_width = dims.pixel_width
		local outer_height = dims.pixel_height

		local x = (screen.width - outer_width) / 2
		local y = (screen.height - outer_height) / 2

		gui_window:set_position(x, y)
	end)

	-- Domains
	config.default_prog = { "pwsh.exe", "-NoLogo" }
	config.wsl_domains = {
		{
			name = "WSL:Ubuntu",
			distribution = "Ubuntu",
			username = "andrei13",
		},
	}
end

return M
