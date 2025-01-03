-- control.lua
local function get_break_time()
    -- All timing related math in here.
    local break_interval = settings.global["break_interval"].value * 60 * 60 -- Convert from minutes to ticks
    local break_duration = settings.global["break_duration"].value * 60 -- Convert from minutes to ticks (adjusted for slowed speed)
    local game_time_in_ticks = game.tick
    local cycle_duration = break_interval + break_duration
    local ticks_in_current_cycle = game_time_in_ticks % cycle_duration
    local in_break_period = ticks_in_current_cycle >= break_interval
    local ticks_until_break_ends = cycle_duration - ticks_in_current_cycle
    local ticks_until_next_break = break_interval - ticks_in_current_cycle
    return break_interval, break_duration, in_break_period, ticks_in_current_cycle, ticks_until_break_ends, ticks_until_next_break
end

local function get_time_string(minutes, seconds)
    local result = ""
    if minutes > 0 then
        result = result .. minutes .. " minute" .. (minutes > 1 and "s" or "")
    end
    if seconds > 0 then
        if result ~= "" then
            result = result .. " and "
        end
        result = result .. seconds .. " second" .. (seconds > 1 and "s" or "")
    end
    return result .. (minutes > 1 and "." or "!")
end

local function get_next_break_time_string()
    local break_interval, break_duration, in_break_period, ticks_in_current_cycle, ticks_until_break_ends, ticks_until_next_break = get_break_time()

    if in_break_period then
        -- Currently in a break
        local minutes_until_break_ends = math.floor(ticks_until_break_ends / 60) -- adjusted for slowed speed during breaktime
        local seconds_until_break_ends = math.floor(ticks_until_break_ends % 60)
        return "Break ends in " .. get_time_string(minutes_until_break_ends, seconds_until_break_ends)
    else
        -- Not in a break, calculate time until next break
        local minutes_until_next_break = math.floor(ticks_until_next_break / 3600)
        local seconds_until_next_break = math.floor(ticks_until_next_break % 3600 / 60)
        return "Next break starts in " .. get_time_string(minutes_until_next_break, seconds_until_next_break)
    end
end

script.on_event(defines.events.on_tick, function(event)
    local break_interval, break_duration, in_break_period, ticks_in_current_cycle, ticks_until_break_ends, ticks_until_next_break = get_break_time()
    local printed_message = false;

    if in_break_period then
        -- "Pause" the game by slowing it down to a crawl. We can't actually pause it or set the speed to 0, since then we'll never get an on_tick event to unpause.
        if game.speed ~= 1 / 60 then
            game.speed = 1 / 60
            game.print("Time for a break! " .. get_next_break_time_string(), { sound_path = "utility/game_won"})
            printed_message = true
        end
    else
        -- If we're already "paused" (speed less than 1) then set the speed back to normal.
        if game.speed < 1 then
            game.speed = 1
            game.print("Game on! " .. get_next_break_time_string(), { sound_path = "utility/new_objective"})
            printed_message = true
        end
    end

    if not printed_message then
        -- Handle the special case where they disabled actually pausing the game (by setting break_duration to 0).
        if break_duration == 0 and ticks_until_next_break == break_interval then
            game.print("Time for a break! " .. get_next_break_time_string(), { sound_path = "utility/game_won"})
        else
            -- If we didn't already print a message due to pausing/unpausing, then check if any users want reminders.
            local ticks_until_next_event = in_break_period and ticks_until_break_ends or ticks_until_next_break
            for _, player in pairs(game.connected_players) do
                local reminder_times = settings.get_player_settings(player)["break_reminder_times"].value
                for reminder_time in string.gmatch(tostring(reminder_times), '%d*%.?%d+') do
                    local reminder_ticks = tonumber(reminder_time) * (in_break_period and 60 or 3600)
                    if reminder_ticks == ticks_until_next_event then
                        player.print(get_next_break_time_string(), { sound_path = "utility/scenario_message"})
                    end
                end
            end
        end
    end
end)

script.on_event(defines.events.on_player_joined_game, function(event)
    -- Print a reminder to everyone whenever someone joins the game.
    game.print(get_next_break_time_string())
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    -- Print the new times when the settings are updated.
    if event.setting == "break_interval" or event.setting == "break_duration" then
        game.print("Settings updated. " .. get_next_break_time_string())
    end
end)