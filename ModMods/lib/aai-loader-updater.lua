-- Code based on aai-loaders/prototypes/phase-1/combined/loaders.lua to update graphics of other mods' loaders
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

return update_loader