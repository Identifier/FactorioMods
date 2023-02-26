---------------------------------------------------------------------------
-- Data stage mods to https://mods.factorio.com/mod/Krastorio2
---------------------------------------------------------------------------
if not mods["Krastorio2"] then
	return
end

local ModMods = require("lib/ModMods")

--[[ ChatGPT says:
The amount of energy released by burning hydrogen and petroleum gas will depend 
on the heating value and the amount of each substance that is burned. In general, 
hydrogen has a higher heating value than petroleum gas, with an average heating 
value of 141 MJ/kg compared to an average heating value of 55-58 MJ/m^3 for petroleum gas.

When burned, hydrogen produces only water vapor as a byproduct. On the other hand, petroleum 
gas, also known as natural gas, when burned releases carbon dioxide (CO2), nitrogen oxides (NOx), 
and other pollutants into the atmosphere. 
]]-- 

if data.raw.fluid["hydrogen"] then
    data.raw.fluid["hydrogen"].fuel_value = "230MJ"
    data.raw.fluid["hydrogen"].emissions_multiplier = 0
end