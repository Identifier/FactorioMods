--------------------------------------------------------------------------------------
-- Data-updates stage mods to https://mods.factorio.com/mod/deadlock-beltboxes-loaders
--------------------------------------------------------------------------------------
if not mods["deadlock-beltboxes-loaders"] then
	return
end

local ModMods = require("lib/ModMods")

---------------------------------------------------------------------------
-- Use aai-loaders loader graphics if aai-loaders mode is set to graphics-only
------------------------------------------------------------------------------
if settings.startup["aai-loaders-mode"].value == "graphics-only" and settings.startup["deadlock-enable-loaders"].value == true then
    local update_loader = require("lib/aai-loader-updater")
    update_loader("transport-belt-loader", {255, 217, 85})
    update_loader("fast-transport-belt-loader", {255, 24, 38})
    update_loader("express-transport-belt-loader", {90, 190, 255})
    update_loader("kr-advanced-transport-belt-loader", {34, 236, 23})
    update_loader("kr-superior-transport-belt-loader", {210, 1, 247})
end