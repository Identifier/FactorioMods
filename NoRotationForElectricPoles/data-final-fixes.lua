-- original code from darkfrei: https://mods.factorio.com/mod/NoRotationForElectricPoles/discussion/6718a8d8a5f1c3fa2e125e75

for pole_name, pole_prototype in pairs(data.raw["electric-pole"]) do
  if pole_prototype.pictures then

    -- this was the original condition from darkfrei's 0.16 version
    if pole_prototype.pictures.direction_count then
      pole_prototype.pictures.direction_count = 1
    end

    -- this seems to be the new structure for 2.0
    if pole_prototype.pictures.layers then
      for _, layer in pairs(pole_prototype.pictures.layers) do
        if layer.direction_count then
          layer.direction_count = 1
        end

        -- also new for this version is the straighter graphics for the poles themselves
        for _, filename in pairs({
          "small-electric-pole.png",
          "medium-electric-pole.png",
        }) do
          if string.sub(layer.filename, -string.len(filename)) == filename then
            -- if it does, replace it with the new version
            layer.filename = "__NoRotationForElectricPoles__/graphics/" .. filename
          end
        end
      end
    end
  end

  -- this code from darkfrei seems to still be fine for version 2.0
  if pole_prototype.connection_points then
    pole_prototype.connection_points = {pole_prototype.connection_points[1]}
  end
end