-- Include global functions and updates to LUA
---------------------------------------------------------------------------
require("global")

for set in each(data.raw.item, data.raw.module, data.raw.fluid, data.raw.recipe) do
--    for prefix in each("__base__/.*", "__space-age__/.*", "__Krastorio2Assets__/.*") do -- note that base and Krastorio 2 use different paths, and also "fluid/..." vs "fluids/..."
        for old, new in pairs({
            ["/advanced-oil-processing.png"] = "fluid/advanced-oil-processing.png",
            ["/ammoniacal-solution-separation.png"] = "fluid/ammoniacal-solution-separation.png",
            ["/ammoniacal-solution.png"] = "fluid/ammoniacal-solution.png",
            ["/basic-oil-processing.png"] = "fluid/basic-oil-processing.png",
            ["/fluoroketone-hot.png"] = "fluid/fluoroketone-hot.png",
            ["/heavy-oil.png"] = "fluid/heavy-oil.png",
            ["/heavy-oil-cracking.png"] = "fluid/heavy-oil-cracking.png",
            ["/light-oil.png"] = "fluid/light-oil.png",
            ["/light-oil-cracking.png"] = "fluid/light-oil-cracking.png",
            ["/petroleum-gas.png"] = "fluid/petroleum-gas.png",
            ["/solid-fuel-from-petroleum-gas.png"] = "solid-fuel-from-petroleum-gas.png",
            ["/speed-module.png"] = "speed-module.png",
            ["/speed-module-2.png"] = "speed-module-2.png",
            ["/uranium-235.png"] = "uranium-235.png",
            ["/uranium-fuel-cell.png"] = "uranium-fuel-cell.png",
        }) do
            for key, value in wherehas(set, "icon", escape_pattern(old)) do
                print("Replacing", value.type, value.name, value.icon, "with", "__ClearerIcons__/graphics/icons/" .. new)
                value.icon = "__ClearerIcons__/graphics/icons/" .. new
            end
        end
--    end
end
