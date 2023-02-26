-------------------------------------------------------------------------------------
-- Settings stage mods to https://mods.factorio.com/mod/aai-loaders
-------------------------------------------------------------------------------------
if not mods["aai-loaders"] then
    return
end

local ModMods = require("lib/ModMods")

-- If Krastorio 2 is installed then set aai-loader's default setting to graphics-only
if mods["Krastorio2"] then
    data.raw["string-setting"]["aai-loaders-mode"].default_value = "graphics-only"
end