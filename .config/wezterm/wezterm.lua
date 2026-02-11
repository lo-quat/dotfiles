local wezterm = require("wezterm")
local keymaps = require("keymaps")
local config = {}

config.use_ime = true
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 24

keymaps.setup(wezterm, config)

local BG_COLOR = "rgba(0,0,0,0.0)"
local ACTIVE_BG = "#73daca"
local ACTIVE_FG = "#000000"
local INACTIVE_FG = "#b4b0d4"

wezterm.on("format-tab-title", function(tab)
	local title = tab.active_pane.title
	local index = tab.tab_index + 1

	local max_title_length = 14
	if #title > max_title_length then
		title = wezterm.truncate_right(title, max_title_length)
	end

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

		table.insert(items, { Background = { Color = ACTIVE_BG } })
		table.insert(items, { Foreground = { Color = ACTIVE_FG } })
		table.insert(items, { Text = " " .. index .. " \u{e0b1} " .. title .. " " })

		table.insert(items, { Background = { Color = BG_COLOR } })
		table.insert(items, { Foreground = { Color = ACTIVE_BG } })
		table.insert(items, { Text = "\u{e0b0}" })
	else
		table.insert(items, { Background = { Color = BG_COLOR } })
		table.insert(items, { Foreground = { Color = INACTIVE_FG } })
		table.insert(items, { Text = "  " .. index .. " \u{e0b1} " .. title .. "  " })
	end

	return items
end)

config.colors = {
	tab_bar = {
		background = "rgba(0,0,0,0.0)",
		inactive_tab = { bg_color = "rgba(0,0,0,0.0)", fg_color = INACTIVE_FG },
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
