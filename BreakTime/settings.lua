-- settings.lua
data:extend({
    {
        type = "int-setting",
        name = "break_interval",
        setting_type = "runtime-global",
        default_value = 50,
        minimum_value = 1,
        maximum_value = 10080,
        order = "a",
        localised_name = "Break Interval",
        localised_description = "The amount of time (in minutes) to play in between breaks."
    },
    {
        type = "int-setting",
        name = "break_duration",
        setting_type = "runtime-global",
        default_value = 10,
        minimum_value = 0,
        maximum_value = 10080,
        order = "b",
        localised_name = "Break Duration",
        localised_description = "The duration (in minutes) that the game will remain paused. Set to 0 to disable."
    },
    {
        type = "string-setting",
        name = "break_reminder_times",
        setting_type = "runtime-per-user",
        default_value = ".5, 1, 10",
        order = "c",
        allow_blank = true,
        localised_name = "Break Reminders",
        localised_description = "Reminder times (in minutes) before pausing/unpausing occurs. Useful during battles or doing time-sensitive tasks."
    }
})
