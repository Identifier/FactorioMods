-------------------------------------------------------------------------------------
-- Settings stage mods to https://mods.factorio.com/mod/Krastorio2
-------------------------------------------------------------------------------------
if not mods["Krastorio2"] then
    return
end

local ModMods = require("lib/ModMods")

data:extend({
    {
        name = ModMods.settings.give_logistic_roboport_construction_radius,
        type = "bool-setting",
        setting_type = "startup",
        default_value = false,
        order = "roboport-a"
    },
    {
        name = ModMods.settings.extra_logistic_roboport_construction_radius,
        type = "int-setting",
        setting_type = "startup",
        minimum_value = 0,
        default_value = "0",
        maximum_value = 128,
        order = "roboport-b"
    }
})