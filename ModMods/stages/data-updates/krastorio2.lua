---------------------------------------------------------------------------
-- Data-updates stage mods to https://mods.factorio.com/mod/Krastorio2
---------------------------------------------------------------------------
if not mods["Krastorio2"] then
    return
end

local ModMods = require("lib/ModMods")

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
