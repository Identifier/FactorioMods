-------------------------------------------------------------------------------------
-- If Krastorio 2 is installed then set aai-loader's default setting to graphics-only
-------------------------------------------------------------------------------------

local ModMods = require("lib/ModMods")

if mods["aai-loaders"] and mods["Krastorio2"] then
    data.raw["string-setting"]["aai-loaders-mode"].default_value = "graphics-only"
end