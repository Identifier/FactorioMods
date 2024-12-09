-- control.lua
local function get_break_time()
    local break_interval = settings.global["break_interval"].value * 60 * 60 -- Convert from minutes to ticks
    local break_duration = settings.global["break_duration"].value * 60 -- Convert from minutes to ticks (adjusted for slowed speed)
    local game_time_in_ticks = game.tick
    local in_break_period = (game_time_in_ticks % (break_interval + break_duration)) < break_duration
    local ticks_in_current_cycle = game.tick % (break_interval + break_duration)
    return break_interval, break_duration, in_break_period, ticks_in_current_cycle
end

local function get_next_break_time_string()
    local break_interval, break_duration, in_break_period, ticks_in_current_cycle = get_break_time()

    if in_break_period then
        -- Currently in a break
        local ticks_until_break_ends = break_duration - ticks_in_current_cycle
        local minutes_until_break_ends = math.floor(ticks_until_break_ends / 60) -- adjusted for slowed speed during breaktime
        local seconds_until_break_ends = math.floor(ticks_until_break_ends % 60)
        local result = "Break ends in " .. minutes_until_break_ends .. " minutes"
        if seconds_until_break_ends > 0 then
            result = result .. " and " .. seconds_until_break_ends .. " seconds"
        end
        return result .. "."
    else
        -- Not in a break, calculate time until next break
        local ticks_until_next_break = break_interval - (ticks_in_current_cycle - break_duration)
        local minutes_until_next_break = math.floor(ticks_until_next_break / 3600)
        local seconds_until_next_break = math.floor(ticks_until_next_break % 60)
        local result = "Next break starts in " .. minutes_until_next_break .. " minutes"
        if seconds_until_next_break > 0 then
            result = result .. " and " .. seconds_until_next_break .. " seconds"
        end
        return result .. "."
    end
end

script.on_event(defines.events.on_tick, function(event)
    local _, _, in_break_period = get_break_time()

    if in_break_period then
        if game.speed ~= 1 / 60 then
            -- Slow down the game
            game.speed = 1 / 60
            game.print("Time for a break! " .. get_next_break_time_string())
            game.play_sound{path = "utility/scenario_message"}
        end
    else
        if game.speed ~= 1 then
            -- Resume normal speed
            game.speed = 1
            game.print("Break time over. " .. get_next_break_time_string())
            game.play_sound{path = "utility/new_objective"}
        end
    end
end)

script.on_event(defines.events.on_player_joined_game, function(event)
    game.print(get_next_break_time_string())
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    if event.setting == "break_interval" or event.setting == "break_duration" then
        game.print("Settings updated. " .. get_next_break_time_string())
    end
end)