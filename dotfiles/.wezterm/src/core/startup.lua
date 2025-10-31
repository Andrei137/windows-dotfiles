local M = {}

function M.apply(wezterm, config)
	wezterm.on("gui-startup", function()
		local screen = wezterm.gui.screens().active
		local tab, pane, window = wezterm.mux.spawn_window({
			position = {
				x = screen.x,
				y = screen.y,
				origin = "ActiveScreen",
			},
		})
		local gui_window = window:gui_window()
		gui_window:toggle_fullscreen()
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
