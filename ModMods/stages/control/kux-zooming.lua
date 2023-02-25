---------------------------------------------------------------------------
-- Restore zoom level after switching views (such as going to pins in Space Exploration, or jumping to combinators in Circuit HUD)
-- Requires a zoom mod such as Kux Zooming Reinvented
---------------------------------------------------------------------------
local ModMods = require("lib/ModMods")
local Event = require("__stdlib__/stdlib/event/event")

-- Restores the zoom level of the player if the Kux Zooming Reinvented mod is installed
local function restoreZoom(player)
    if remote.interfaces["Kux-Zooming"] then
        local zoom = remote.call("Kux-Zooming", "getZoomFactor", player.index)
        if zoom and type(zoom) == "number" then
            player.zoom_to_world(player.position, zoom)
            player.close_map()
        end
    end
end

-- Restores zoom level when switching surfaces if the setting is enabled
Event.register(defines.events.on_player_changed_surface, function(event)
    local settings = settings.get_player_settings(event.player_index)
    if settings[ModMods.settings.restore_zoom_on_surface_change].value then
        local player = game.get_player(event.player_index)
        if player and player.valid then
            restoreZoom(player)
        end
    end
end)

-- Restores zoom level when moving a certain distance if the setting is enabled
Event.register(defines.events.on_player_changed_position, function(event)
    local settings = settings.get_player_settings(event.player_index)
    if settings[ModMods.settings.restore_zoom_on_position_change].value then
        local player = game.get_player(event.player_index)
        if player and player.valid then
            global.last_player_positions = global.last_player_positions or {}
            if global.last_player_positions[event.player_index] then
                local last_position = global.last_player_positions[event.player_index]
                local delta_x = math.abs(player.position.x - last_position.x)
                local delta_y = math.abs(player.position.y - last_position.y)
                local threshold = settings[ModMods.settings.restore_zoom_position_threshold].value

                if settings["ZoomingReinvented_debug"].value then
                    game.print("Position moved ".. delta_x .. ", " .. delta_y .. " (threshold = " .. threshold .. ")")
                end

                if delta_x >= threshold or delta_y >= threshold then
                    restoreZoom(player)
                end
            end
            global.last_player_positions[player.index] = player.position
        end
    end
end)