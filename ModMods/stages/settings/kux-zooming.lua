-------------------------------------------------------------------------------------
-- Settings stage mods to https://mods.factorio.com/mod/Kux-Zooming
-------------------------------------------------------------------------------------
if not mods["Kux-Zooming"] then
    return
end

local ModMods = require("lib/ModMods")

data:extend({
    {
        name = ModMods.settings.restore_zoom_on_surface_change,
        type = "bool-setting",
        setting_type = "runtime-per-user",
        default_value = true,
        order = "zoom-a"
    },
    {
        name = ModMods.settings.restore_zoom_on_position_change,
        type = "bool-setting",
        setting_type = "runtime-per-user",
        default_value = true,
        order = "zoom-b"
    },
    {
        name = ModMods.settings.restore_zoom_position_threshold,
        type = "int-setting",
        setting_type = "runtime-per-user",
        minimum_value = 0,
        default_value = "1",
        maximum_value = 100,
        order = "zoom-b-a"
    }
})