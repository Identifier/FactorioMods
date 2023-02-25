-- Mods to https://mods.factorio.com/mod/Krastorio2 --
if not mods["Krastorio2"] then
	return
end

local ModMods = require("lib/ModMods")

---------------------------------------------------------------------------
-- Icon unification
---------------------------------------------------------------------------
local function wherehas(t, prop_name, prop_pattern)
    return where(t, function(_, v) return type(v) == "table" and type(v[prop_name]) == "string" and string.find(v[prop_name], prop_pattern) end)
end

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