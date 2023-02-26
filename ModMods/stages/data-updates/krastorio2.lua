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

------------------------------------------------------------------------------
-- Use aai-loaders loader graphics if aai-loaders mode is set to graphics-only
------------------------------------------------------------------------------
if settings.startup["aai-loaders-mode"].value == "graphics-only" and settings.startup["kr-loaders"].value == true then
    -- Code from aai-loaders/prototypes/phase-1/combined/loaders.lua
    local graphics_path = "__aai-loaders__/graphics/"
    local dark_suffix = "_dark"
    local sprite_shift = {0, -0.15}
    local shadow_shift = {0.4, 0.15}

    local function get_backsprite(spritename)
        return {
          priority = "high",
          filename = graphics_path .. "entity/loader/" .. spritename,
          line_length = 1,
          width = 49,
          height = 59,
          frame_count = 1,
          direction_count = 1,
          shift = sprite_shift,
          hr_version = {
            priority = "high",
            filename = graphics_path .. "entity/loader/hr_" .. spritename,
            line_length = 1,
            width = 99,
            height = 117,
            frame_count = 1,
            direction_count = 1,
            shift = sprite_shift,
            scale = 0.5
          }
        }
    end

    local function update_loader(name, color, dark)
        local suffix = dark and dark_suffix or ""

        local item = data.raw.item[name]
        if item then
            item.icons = {
                { icon = graphics_path .. "icons/loader" .. suffix .. ".png", icon_size = 64 },
                { icon = graphics_path .. "icons/loader_mask" .. suffix .. ".png", icon_size = 64, tint = color }
            }
        end

        local entity = data.raw["loader-1x1"][name]
        if entity then
            entity.icons = {
                { icon = graphics_path .. "icons/loader" .. suffix .. ".png", icon_size = 64 },
                { icon = graphics_path .. "icons/loader_mask" .. suffix .. ".png", icon_size = 64, tint = color }
            }
            entity.collision_box = { {-0.4, -0.45}, {0.4, 0.45} }
            entity.selection_box = { {-0.5, -0.5}, {0.5, 0.5} }
            entity.drawing_box = { {-0.4, -0.4}, {0.4, 0.4} }
            entity.container_distance = 0.75
            entity.integration_patch_render_layer = "decals"
            entity.integration_patch = {
              north = get_backsprite("loader_empty.png"),
              east = get_backsprite("loader_side.png"),
              south = get_backsprite("loader_empty.png"),
              west = get_backsprite("loader_side.png"),
            }
            entity.structure = {
                direction_in = {
                    sheets = {
                        {
                            filename = graphics_path .. "entity/loader/loader" .. "_shadows.png",
                            priority = "extra-high",
                            shift = shadow_shift,
                            width = 69,
                            height = 39,
                            draw_as_shadow = true,
                            hr_version = {
                                filename = graphics_path .. "entity/loader/hr_loader" .. "_shadows.png",
                                priority = "extra-high",
                                shift = shadow_shift,
                                width = 138,
                                height = 79,
                                scale = 0.5,
                                draw_as_shadow = true
                            }
                        },
                        {
                            filename = graphics_path .. "entity/loader/loader" .. suffix .. ".png",
                            priority = "extra-high",
                            shift = sprite_shift,
                            width = 49,
                            height = 58,
                            hr_version = {
                                filename = graphics_path .. "entity/loader/hr_loader" .. suffix .. ".png",
                                priority = "extra-high",
                                shift = sprite_shift,
                                width = 99,
                                height = 117,
                                scale = 0.5
                            }
                        },
                        {
                            filename = graphics_path .. "entity/loader/loader" .. "_tint" .. suffix .. ".png",
                            priority = "extra-high",
                            shift = sprite_shift,
                            width = 49,
                            height = 58,
                            tint = color,
                            hr_version = {
                                filename = graphics_path .. "entity/loader/hr_loader" .. "_tint" .. suffix .. ".png",
                                priority = "extra-high",
                                shift = sprite_shift,
                                width = 99,
                                height = 117,
                                scale = 0.5,
                                tint = color
                            }
                        }
                    }
                },
                direction_out = {
                    sheets = {
                        {
                            filename = graphics_path .. "entity/loader/loader" .. "_shadows.png",
                            priority = "extra-high",
                            shift = shadow_shift,
                            width = 69,
                            height = 39,
                            y = 39,
                            draw_as_shadow = true,
                            hr_version = {
                                filename = graphics_path .. "entity/loader/hr_loader" .. "_shadows.png",
                                priority = "extra-high",
                                shift = shadow_shift,
                                width = 138,
                                height = 79,
                                y = 79,
                                scale = 0.5,
                                draw_as_shadow = true,
                            }
                        },
                        {
                            filename = graphics_path .. "entity/loader/loader" .. suffix .. ".png",
                            priority = "extra-high",
                            shift = sprite_shift,
                            width = 49,
                            height = 58,
                            y = 59,
                            hr_version = {
                                filename = graphics_path .. "entity/loader/hr_loader" .. suffix .. ".png",
                                priority = "extra-high",
                                shift = sprite_shift,
                                width = 99,
                                height = 117,
                                y = 117,
                                scale = 0.5
                            }
                        },
                        {
                            filename = graphics_path .. "entity/loader/loader" .. "_tint" .. suffix .. ".png",
                            priority = "extra-high",
                            shift = sprite_shift,
                            width = 49,
                            height = 58,
                            tint = color,
                            y = 59,
                            hr_version = {
                                filename = graphics_path .. "entity/loader/hr_loader" .. "_tint" .. suffix .. ".png",
                                priority = "extra-high",
                                shift = sprite_shift,
                                width = 99,
                                height = 117,
                                scale = 0.5,
                                y = 117,
                                tint = color
                            }
                        }
                    }
                }
            }
        end
    end

    update_loader("kr-loader", {255, 217, 85})
    update_loader("kr-fast-loader", {255, 24, 38})
    update_loader("kr-express-loader", {90, 190, 255})
    update_loader("kr-advanced-loader", {34, 236, 23})
    update_loader("kr-superior-loader", {210, 1, 247})
    update_loader("kr-se-loader", {255, 255, 255})
    update_loader("kr-se-deep-space-loader-black", {r=0.1, g=0.1, b=0.1}, true)
end