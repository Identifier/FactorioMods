---------------------------------------------------------------------------
-- Control-stage mods to https://mods.factorio.com/mod/CircuitHUD-V2
---------------------------------------------------------------------------
if not settings.player["CircuitHUD_hud_title"] then -- The global 'mods' table is not available in control stage, so check for a setting instead
	return
end

local ModMods = require("lib/ModMods")
local Event = require("__stdlib__/stdlib/event/event")

---------------------------------------------------------------------------
-- Switch to the correct surface when clicking the go to combinator button
---------------------------------------------------------------------------
local const = {}
const.TAG_NAME = "CircuitHUD-V2"
const.SHORT_PREFIX = "chv2_"
const.HUD_COMBINATOR_NAME = "hud-combinator"
const.GUI_ACTIONS = {
	open_combinator = "OPEN_COMBINATOR",
	go_to_combinator = "GO_TO_COMBINATOR",
	hide_combinator = "HIDE_COMBINATOR",
	show_combinator = "SHOW_COMBINATOR"
}
const.BUTTON_STYLES = {
	edit_button = const.SHORT_PREFIX .. "edit_button",
	hide_button = const.SHORT_PREFIX .. "hide_button",
	show_button = const.SHORT_PREFIX .. "show_button",
	go_to_button = const.SHORT_PREFIX .. "go_to_button"
}

-- Searches for a combinator when the go-to button is clicked and tries to use Space Exploration's remote view to switch to its surface
Event.register(defines.events.on_gui_click, function(event)
	local element = event.element
	if element.style.name == const.BUTTON_STYLES.go_to_button then

		local unit_number = element.tags[const.TAG_NAME].flib.on_click.unit_number
		local player = game.get_player(element.player_index)

		if player == nil then
			return
		end

		for surface in values(game.surfaces) do
			local hud_combinators = surface.find_entities_filtered({ name = const.HUD_COMBINATOR_NAME })
			for hud_combinator in values(hud_combinators) do
				if hud_combinator.unit_number == unit_number then
					local surface_name = hud_combinator.surface.name
					local position = hud_combinator.position

					-- Attempt to use Space Exploration's remote view instead of map mode
					if remote.interfaces["space-exploration"] then
						remote.call("space-exploration", "remote_view_start", { player = player, zone_name = surface_name == "nauvis" and "Nauvis" or surface_name, position = position })
						if remote.call("space-exploration", "remote_view_is_active", { player = player }) then
							player.close_map()
						end
					end

					-- If remote view isn't available or didn't work, yet the combinator is on another surface, it's better to close the map anyway rather than zoom to a wrong location
					if surface_name ~= player.surface.name then
						player.close_map()
						player.play_sound({ path = "utility/cannot_build" })
						player.create_local_flying_text({ text = { "search-gui.wrong-surface" }, create_at_cursor = true })
					end

					-- No need to keep searching more surfaces
					return
				end
			end
		end
	end
end)