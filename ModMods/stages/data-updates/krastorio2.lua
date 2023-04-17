---------------------------------------------------------------------------
-- Data-updates stage mods to https://mods.factorio.com/mod/Krastorio2
---------------------------------------------------------------------------
if not mods["Krastorio2"] then
    return
end

local ModMods = require("lib/ModMods")

---------------------------------------------------------------------------
-- Icon unification
---------------------------------------------------------------------------

-- Krastorio 2 introduced new colors for heavy and light oil, but didn't update the fluid colors in pipes, and there are still some combination recipe icons using the original colors as well.
-- So bring back the original oil icons, except for petroleum gas which is purple now to match its fluid color in pipes.
for kind in each(data.raw.fluid, data.raw.recipe) do
    for prefix in each("__base__/.*", "__Krastorio2Assets__/.*") do -- note that base and Krastorio 2 use different paths, and also "fluid/..." vs "fluids/..."
        for old, new in pairs({
            ["/heavy-oil.png"] = "fluid/heavy-oil.png",
            ["/light-oil.png"] = "fluid/light-oil.png",
            ["/petroleum-gas.png"] = "fluid/petroleum-gas.png",
            ["/light-oil-cracking.png"] = "recipes/light-oil-cracking.png",
            ["/heavy-oil-cracking.png"] = "recipes/heavy-oil-cracking.png",
            ["/solid-fuel-from-petroleum-gas.png"] = "recipes/solid-fuel-from-petroleum-gas.png",
        }) do
            for _, obj in wherehas(flatten(kind), "icon", prefix .. escape_pattern(old)) do
                obj.icon = ModMods.path.icons .. new
            end
        end
    end
end

-- Krastorio 2 sets the icons for advanced-oil-processing and oil-processing-heavy to light-oil and heavy-oil respectively
-- So also set the icon for basic-oil-processing to petroleum-gas as well.
if data.raw.recipe["basic-oil-processing"].icon == "__base__/graphics/icons/fluid/basic-oil-processing.png" then
    data.raw.recipe["basic-oil-processing"].icon = data.raw.fluid["petroleum-gas"].icon
    data.raw.recipe["basic-oil-processing"].icon_size = data.raw.fluid["petroleum-gas"].icon_size
end

------------------------------------------------------------------------------
-- Use aai-loaders loader graphics if aai-loaders mode is set to graphics-only
------------------------------------------------------------------------------
if settings.startup["aai-loaders-mode"].value == "graphics-only" and settings.startup["kr-loaders"].value == true then
    local update_loader = require("lib/aai-loader-updater")
    update_loader("kr-loader", { 255, 217, 85 })
    update_loader("kr-fast-loader", { 255, 24, 38 })
    update_loader("kr-express-loader", { 90, 190, 255 })
    update_loader("kr-advanced-loader", { 34, 236, 23 })
    update_loader("kr-superior-loader", { 210, 1, 247 })
    update_loader("kr-se-loader", { 255, 255, 255 })
    update_loader("kr-se-deep-space-loader-black", { r = 0.1, g = 0.1, b = 0.1 }, true)
end

---------------------------------------------------------------------------
-- Give logistic-mode roboports a minimal construction radius
---------------------------------------------------------------------------
if settings.startup[ModMods.settings.give_logistic_roboport_construction_radius].value then
    for _, entity in wherematch(data.raw.roboport, "%-logistic%-mode$") do
        if entity.logistics_radius > 0 and entity.construction_radius == 0 then
            entity.construction_radius = entity.logistics_radius + settings.startup[ModMods.settings.extra_logistic_roboport_construction_radius].value
        end
    end
end
