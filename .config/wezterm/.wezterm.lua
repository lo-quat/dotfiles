local wezterm = require("wezterm")
local config = {}
local act = wezterm.action

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 24
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

local BG_COLOR = "#171b20"
local ACTIVE_BG = "#73daca"
local ACTIVE_FG = "#000000"
local INACTIVE_FG = "#b4b0d4"

wezterm.on("format-tab-title", function(tab)
	local title = tab.active_pane.title
	local index = tab.tab_index + 1

	local items = {}

	if tab.is_active then
		if index == 1 then
			table.insert(items, { Background = { Color = tab.is_active and ACTIVE_BG or BG_COLOR } })
			table.insert(items, { Text = " " })
		else
			table.insert(items, { Background = { Color = ACTIVE_BG } })
			table.insert(items, { Foreground = { Color = BG_COLOR } })
			table.insert(items, { Text = "\u{e0b0}" })
		end

		-- メイン部分（数字とタイトル）
		table.insert(items, { Background = { Color = ACTIVE_BG } })
		table.insert(items, { Foreground = { Color = ACTIVE_FG } })
		table.insert(items, { Text = " " .. index .. " \u{e0b1} " .. title .. " " })

		-- 右側の境界矢印
		table.insert(items, { Background = { Color = BG_COLOR } })
		table.insert(items, { Foreground = { Color = ACTIVE_BG } })
		table.insert(items, { Text = "\u{e0b0}" })
	else
		-- 非アクティブ時の表示
		table.insert(items, { Background = { Color = BG_COLOR } })
		table.insert(items, { Foreground = { Color = INACTIVE_FG } })
		table.insert(items, { Text = "  " .. index .. " \u{e0b1} " .. title .. "  " })
	end

	return items
end)

config.colors = {
	tab_bar = {
		background = BG_COLOR,
		inactive_tab = { bg_color = BG_COLOR, fg_color = INACTIVE_FG },
	},
	foreground = "#a1a6b2",
	background = "#171b20",
	cursor_bg = "#a1a6b2",
	cursor_fg = "#171b20",
	cursor_border = "#a1a6b2",
	selection_fg = "#a1a6b2",
	selection_bg = "#21262e",

	ansi = {
		"#171b20",
		"#e79da4",
		"#98c379",
		"#f3e1ad",
		"#86aaec",
		"#c397d8",
		"#70b0ba",
		"#a1a6b2",
	},
	brights = {
		"#21262e",
		"#e79da4",
		"#98c379",
		"#f3e1ad",
		"#86aaec",
		"#c397d8",
		"#70b0ba",
		"#a1a6b2",
	},
}

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13.0

return config
