---------------------------------------------------------------------------
-- Global and functions
---------------------------------------------------------------------------
modmods_path = "__ModMods__/"

-- Escape a string so it can be used in string.find without it being interpreted as a pattern
function escape_pattern(text)
    return string.gsub(text, "[^%w]", "%%%1")
end

-- Recursively search for an object with a property that contains a specific substring
function foreach_wherematch(obj, prop_name, prop_pattern, callback)
    return foreach_where(obj, prop_name, function(v) return string.find(v, prop_pattern) end, callback)
end

function foreach_wherecontains(obj, prop_name, prop_substring, callback)
    return foreach_where(obj, prop_name, function(v) return string.find(v, prop_substring, 1, true) end, callback)
end

-- Recursively search for an object with a property that matches a specific predicate
function foreach_where(obj, prop_name, predicate, callback)
    for k, v in next, obj do
        if type(v) == "table" then
            foreach_where(v, prop_name, predicate, callback)
        elseif k == prop_name then
            if predicate(v) then
                callback(obj)
            end
        end
    end
end

-- Removes the given prerequesite techs/ingredients from a technology
function removePrerequisitesFrom(name, prerequisites)

    local tech = data.raw.technology[name]
    if not tech then
        log("Technology " .. name .. " does not exist")
        return
    end

    if #prerequisites == 0 then
        log("No prerequisite technologies/ingredients passed to removePrerequisitesFrom")
        return
    end

    if tech.prerequisites then
        -- For diagnostic purposes when mods introduce new prerequisites
        for i, prereq in next, tech.prerequisites do
            log("Found " .. name .. " prerequisite " .. i .. ": " .. prereq)
        end

        for _, prereq in next, prerequisites do
            for i = #tech.prerequisites, 1, -1 do -- Work backwards to avoid index changes when removing elements
                if tech.prerequisites[i] == prereq then
                    log ("Removing " .. name .. " prerequisite " .. i .. ": " .. prereq)
                    table.remove(tech.prerequisites, i);
                end
            end
        end
    end

    if tech.unit.ingredients then
        -- For diagnostic purposes when mods introduce new ingredients
        for i, ingredient in next, tech.unit.ingredients do
            log("Found " .. name .. " ingredient " .. i .. ":" .. ingredient[1])
        end

        for _, ingredient in next, prerequisites do
            for i = #tech.unit.ingredients, 1, -1 do
                if tech.unit.ingredients[i][1] == ingredient then
                    log ("Removing " .. name .. " ingredient " .. i .. ": " .. ingredient)
                    table.remove(tech.unit.ingredients, i)
                end
            end
        end
    end
end

-- List of "difficult" prerequisites for logistics.
-- This list is here in global.lua because it's used in multiple mod mods.
difficult_logistics_technologies = {
    "utility-science-pack",
    "production-science-pack",
    "space-science-pack",
    "se-rocket-science-pack"
}