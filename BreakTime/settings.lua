-- settings.lua
data:extend({
    {
        type = "int-setting",
        name = "break_interval",
        setting_type = "runtime-global",
        default_value = 50,
        minimum_value = 0,
        order = "a",
        localised_name = "Break Interval",
        localised_description = "The amount of time (in minutes) to play in between breaks."
    },
    {
        type = "int-setting",
        name = "break_duration",
        setting_type = "runtime-global",
        default_value = 10,
        minimum_value = 1,
        order = "b",
        localised_name = "Break Duration",
        localised_description = "The duration (in minutes) that the game will remain paused."
    }
})
