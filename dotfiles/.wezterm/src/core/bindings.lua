local utils = require("utils")

local M = {}

function M.apply(wezterm, config)
  local act = wezterm.action

  -- New leader
  config.leader = {
    key = "x",
    mods = "CTRL",
    timeout_milliseconds = 2000
  }
  -- Keybinds
  config.disable_default_key_bindings = true
  config.keys = {
    {
      -- Toggle opacity
      key = "0",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, _)
        local overrides = window:get_config_overrides() or {}
        if overrides.window_background_opacity == 1.0 then
          overrides.window_background_opacity = 0.9
        else
          overrides.window_background_opacity = 1.0
        end
        window:set_config_overrides(overrides)
      end),
    },
    {
      -- Split vertical and keep domain
      key = "-",
      mods = "LEADER",
      action = wezterm.action_callback(function(win, pane)
        local domain, cwd = utils.keep_domain(pane)
        win:perform_action(act.SplitVertical { domain = domain, cwd = cwd }, pane)
      end),
    },
    {
      -- Split vertical and reverse domain
      key = "-",
      mods = "LEADER|ALT",
      action = wezterm.action_callback(function(win, pane)
        local domain, cwd = utils.reverse_domain(pane)
        win:perform_action(act.SplitVertical { domain = domain, cwd = cwd }, pane)
      end),
    },
    {
      -- Split horizontal and same domain
      key = "\\",
      mods = "LEADER",
      action = wezterm.action_callback(function(win, pane)
        local domain, cwd = utils.keep_domain(pane)
        win:perform_action(act.SplitHorizontal { domain = domain, cwd = cwd }, pane)
      end),
    },
    {
      -- Split horizontal and reverse domain
      key = "\\",
      mods = "LEADER|ALT",
      action = wezterm.action_callback(function(win, pane)
        local domain, cwd = utils.reverse_domain(pane)
        win:perform_action(act.SplitHorizontal { domain = domain, cwd = cwd }, pane)
      end),
    },
    {
      -- New tab and same domain
      key = "c",
      mods = "LEADER",
      action = wezterm.action_callback(function(win, pane)
        local domain, cwd = utils.keep_domain(pane)
        win:perform_action(act.SpawnCommandInNewTab { domain = domain, cwd = cwd }, pane)
      end),
    },
    {
      -- New tab and reverse domain
      key = "c",
      mods = "LEADER|ALT",
      action = wezterm.action_callback(function(win, pane)
        local domain, cwd = utils.reverse_domain(pane)
        win:perform_action(act.SpawnCommandInNewTab { domain = domain, cwd = cwd }, pane)
      end),
    },
    {
      -- Fullscreen active tab
      key = "f",
      mods = "LEADER",
      action = act.TogglePaneZoomState,
    },
    {
      -- Swap focus
      key = "s",
      mods = "LEADER",
      action = act.PaneSelect
    },
    {
      -- Swap panes
      key = 's',
      mods = 'LEADER|ALT',
      action = act.PaneSelect { mode = 'SwapWithActiveKeepFocus' }
    },
    {
      -- Move to left tab
      key = ",",
      mods = "LEADER",
      action = act.ActivateTabRelative(-1),
    },
    {
      -- Move to right tab
      key = ".",
      mods = "LEADER",
      action = act.ActivateTabRelative(1),
    },
    {
      -- Select tab
      key = 'Tab',
      mods = 'LEADER',
      action = act.ShowTabNavigator,
    },
    {
      -- Debug
      key = "d",
      mods = "LEADER",
      action = act.ShowDebugOverlay
    },
    {
      -- Adjust left
      key = "LeftArrow",
      mods = "ALT",
      action = act.AdjustPaneSize { "Left", 5 },
    },
    {
      -- Adjust down
      key = "DownArrow",
      mods = "ALT",
      action = act.AdjustPaneSize { "Down", 5 },
    },
    {
      -- Adjust up
      key = "UpArrow",
      mods = "ALT",
      action = act.AdjustPaneSize { "Up", 5 },
    },
    {
      -- Adjust right
      key = "RightArrow",
      mods = "ALT",
      action = act.AdjustPaneSize { "Right", 5 },
    },
    {
      -- Rename tab
      key = 'r',
      mods = 'LEADER',
      action = act.PromptInputLine {
        description = 'Enter new name for tab',
        action = wezterm.action_callback(
          function(window, pane, line)
            if line then
              window:active_tab():set_title(line)
            end
          end
        ),
      },
    },
    {
      -- Close current tab
      key = "x",
      mods = "LEADER",
      action = act.CloseCurrentPane { confirm = true },
    },
    {
      -- Close app
      key = "x",
      mods = "LEADER|ALT",
      action = act.QuitApplication,
    },
    {
      -- Copy
      key = "c",
      mods = "CTRL|SHIFT",
      action = act.CopyTo("Clipboard"),
    },
    {
      -- Copy if text selected, else send ctrl-c
      key = "c",
      mods = "CTRL",
      action = wezterm.action_callback(function(window, pane)
        local has_selection = window:get_selection_text_for_pane(pane) ~= ""
        if has_selection then
          window:perform_action(act.CopyTo("Clipboard"), pane)
        else
          window:perform_action(act.SendKey({ key = "c", mods = "CTRL" }), pane)
        end
      end),
    },
    {
      -- Paste
      key = "v",
      mods = "CTRL",
      action = act.PasteFrom("Clipboard"),
    },
    {
      -- Paste
      key = "v",
      mods = "CTRL|SHIFT",
      action = act.PasteFrom("Clipboard"),
    },
    {
      key = 'LeftArrow',
      mods = 'CTRL|SHIFT',
      action = 'DisableDefaultAssignment'
    },
    {
      key = 'RightArrow',
      mods = 'CTRL|SHIFT',
      action = 'DisableDefaultAssignment'
    },
  }

  for i = 1, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = "LEADER",
      action = act.ActivateTab(i - 1),
    })
  end

  -- Mouse bindings
  config.mouse_bindings = {
    {
      -- Right click paste
      event = { Down = { streak = 1, button = "Right" } },
      mods = "NONE",
      action = act.PasteFrom("Clipboard"),
    },
  }
end

return M
