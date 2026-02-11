local M = {}

function M.action(wezterm)
	local act = wezterm.action

	return wezterm.action_callback(function(window, pane)
		local current_workspace = window:active_workspace()

		-- Collect all mux windows grouped by workspace
		local workspace_windows = {}
		for _, mux_win in ipairs(wezterm.mux.all_windows()) do
			local ws = mux_win:get_workspace()
			if not workspace_windows[ws] then
				workspace_windows[ws] = {}
			end
			table.insert(workspace_windows[ws], mux_win)
		end

		local choices = {}
		local choice_actions = {}

		for _, ws_name in ipairs(wezterm.mux.get_workspace_names()) do
			local is_current = ws_name == current_workspace
			local idx = tostring(#choices + 1)

			table.insert(choices, {
				id = idx,
				label = (is_current and " " or "  ") .. ws_name,
			})
			choice_actions[idx] = { type = "workspace", name = ws_name }

			-- Add tabs under this workspace
			local windows = workspace_windows[ws_name] or {}
			for _, mux_win in ipairs(windows) do
				for tab_i, tab in ipairs(mux_win:tabs()) do
					local title = tab:active_pane():get_title()
					idx = tostring(#choices + 1)
					table.insert(choices, {
						id = idx,
						label = "    " .. tostring(tab_i) .. ": " .. title,
					})
					choice_actions[idx] = {
						type = "tab",
						workspace = ws_name,
						window_id = mux_win:window_id(),
						tab_id = tab:tab_id(),
					}
				end
			end
		end

		window:perform_action(
			act.InputSelector({
				title = "Switch Workspace",
				choices = choices,
				action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
					if not id then
						return
					end
					local info = choice_actions[id]
					if not info then
						return
					end

					inner_window:perform_action(
						act.SwitchToWorkspace({ name = info.workspace or info.name }),
						inner_pane
					)

					if info.type == "tab" then
						local target_window = wezterm.mux.get_window(info.window_id)
						if target_window then
							for _, tab in ipairs(target_window:tabs()) do
								if tab:tab_id() == info.tab_id then
									tab:activate()
									break
								end
							end
						end
					end
				end),
			}),
			pane
		)
	end)
end

return M
