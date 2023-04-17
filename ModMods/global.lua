---------------------------------------------------------------------------
-- Global functions/additions to the Lua standard library
---------------------------------------------------------------------------

---@diagnostic disable: lowercase-global

-- Unpacks an iterator that returns at most one value (i.e. not a tuple) per iteration, such as string.gmatch()
-- The name comes from the star/asterisk operator in Python
function star(iter, t, k)
    k = iter(t, k)
    if k ~= nil then
        return k, star(iter, t, k)
    end
end

-- Unpacks an iterator that returns a tuple (i.e. key, value pair) per iteration, such as pairs() or ipairs(), as k1, v1, k2, v2, k3, v3 ...
-- Not quite the same as ** in Python, but this may be useful in Lua
function star2(iter, t, k)
    local v
    k, v = iter(t, k)
    if k ~= nil then
        return k, v, star2(iter, t, k)
    end
end

-- Unpacks an iterator that returns a tuple (i.e. key, value pair) per iteration, such as pairs() or ipairs() as v1, v2, v3 ...
-- Functionally equivalent to star(values(t)) for a table, which is similar to unpack(t), except that star(values(t)) works for dictionaries in addition to just "arrays"
function starv(iter, t, k)
    local v
    k, v = iter(t, k)
    if k ~= nil then
        return v, starv(iter, t, k)
    end
end

-- Returns an array (i.e. a table with indexes 1, 2, 3...) containing all of the values returned by the given iterator
-- When the iterator returns key, value elements, the key is discarded
function array(iter, t, k)
    local ret = {}
    local i = 1
    ---@diagnostic disable-next-line: redefined-local
    for k, v in iter, t, k do
        if v ~= nil then
            ret[i] = v
        else
            ret[i] = k
        end
        i = i + 1
    end
    return ret
end

-- Returns a table containing all of the (key, value) elements returned by the given iterator
-- Duplicate keys are overridden by later values
function dict(iter, t, k)
    local ret = {}
    ---@diagnostic disable-next-line: redefined-local
    for k, v in iter, t, k do
        ret[k] = v
    end
    return ret
end

-- Returns an iterator that returns the values of a table (or stateful iterator), without the keys
function values(t)
    local next = type(t) == "function" and t or pairs(t) -- need to use the returned function from factorio's overridden pairs() here to avoid getting back userdata
    local k = nil
    local function iter()
        local v
        k, v = next(t, k)
        return v
    end
    return iter
end

-- Returns an iterator that returns the values of a variables number of arguments
function each(...)
    return values({...})
end

-- Returns an iterator that returns the elements of a table (or stateful iterator) recursively. Circular references are not detected and may cause the iterator to iterate forever.
function flatten(t)
    local next = type(t) == "function" and t or pairs(t) -- need to use the returned function from factorio's overridden pairs() here to avoid getting back userdata
    local k = nil
    local viter = nil
    local function iter()
        if viter then
            local vk, vv = viter()
            if vk ~= nil then
                return vk, vv
            else
                viter = nil
            end
        end
        local v
        k, v = next(t, k)
        if type(v) == "table" then
            viter = flatten(v) -- start returning elements from v next time
        end
        return k, v
    end
    return iter
end

-- Returns an iterator that returns the elements of a table where predicate(key, value) is truthy
function where(t, predicate)
    local next = type(t) == "function" and t or pairs(t) -- need to use the returned function from factorio's overridden pairs() here to avoid getting back userdata
    local k = nil
    local function iter()
        local v
        repeat
            k, v = next(t, k)
            if k ~= nil and predicate(k, v) then
                return k, v
            end
        until k == nil
    end
    return iter
end

-- Returns an iterator that returns the elements of a table where the element's value is a given value
function whereis(t, value)
    return where(t, function (_, v) return v == value end)
end

-- Returns true if the given table contains a given value
function contains(t, value)
    return whereis(t, value)() ~= nil
end

-- Returns an iterator that returns the elements of a table where the key and/or value matches a given pattern
function wherematch(t, pattern)
    return where(t, function (k, v) return (type(k) == "string" and string.match(k, pattern)) or (type(v) == "string" and string.match(v, pattern)) end)
end

-- Returns true if the given table contains a key and/or value that matches a given pattern
function containsmatch(t, pattern)
    return wherematch(t, pattern)() ~= nil
end

-- Returns an iterator that returns the elements of a table that have a property with a given name that's value matches a given pattern
function wherehas(t, prop_name, prop_value)
    return where(t, function(_, v) return type(v) == "table" and type(v[prop_name]) == "string" and string.find(v[prop_name], prop_value) end)
end

-- Escape a string so it can be used in string.find without it being interpreted as a pattern
function escape_pattern(text)
    return string.gsub(text, "[^%w]", "%%%1")
end