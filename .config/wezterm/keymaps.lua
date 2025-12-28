local M = {}

function M.setup(wezterm, config)
	local act = wezterm.action

	config.leader = { key = "t", mods = "CTRL", timeout_milliseconds = 1000 }

	config.keys = {
		{
			key = "w",
			mods = "LEADER",
			action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }),
		},
		{
			key = "v",
			mods = "LEADER",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },

		{ key = "x", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },

		{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
		{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
		{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
		{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
		{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
		{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
		{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
		{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
		{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
		{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
		{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },
	}
end

return M
