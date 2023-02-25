-- Mods to any of the early-logistics mods like https://mods.factorio.com/mod/early-logistics, https://mods.factorio.com/mod/early-logistics11, https://mods.factorio.com/mod/space-exp-early-logistics, etc --
if not containsmatch(mods, "early%-logistics") then
	return
end

local ModMods = require("lib/ModMods")

---------------------------------------------------------------------------
-- Remove difficult requirements from logistics technologies
---------------------------------------------------------------------------
local function earlify(tech_name, prerequisites_to_remove)
    local tech = data.raw.technology[tech_name]

    if tech.prerequisites then
        for i = #tech.prerequisites, 1, -1 do
            local prerequisite = tech.prerequisites[i]
            if contains(prerequisites_to_remove, prerequisite) then
                log ("Early Logistics ModMods: Removing " .. tech.name .. "'s prerequisite #" .. i .. ": " .. prerequisite)
                table.remove(tech.prerequisites, i);
            else
                log ("Early Logistics ModMods: Keeping " .. tech.name .. "'s prerequisite #" .. i .. ": " .. prerequisite)
            end
        end
    end

    if tech.unit.ingredients then
        for i = #tech.unit.ingredients, 1, -1 do
            local ingredient =tech.unit.ingredients[i][1]
            if contains(prerequisites_to_remove, ingredient) then
                log ("Early Logistics ModMods: Removing " .. tech.name .. "'s ingredient #" .. i .. ": " .. ingredient)
                table.remove(tech.unit.ingredients, i)
            else
                log ("Early Logistics ModMods: Keeping " .. tech.name .. "'s ingredient #" .. i .. ": " .. ingredient)
            end
        end
    end

    for other in values(data.raw.technology) do
        if other.prerequisites and contains(other.prerequisites, tech_name) then
            earlify(other.name, prerequisites_to_remove)
        end
    end
end

earlify("logistic-robotics", { "utility-science-pack", "production-science-pack", "space-science-pack", "rocket-science-pack", "se-rocket-science-pack" })