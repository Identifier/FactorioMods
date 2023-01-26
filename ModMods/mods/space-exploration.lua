-- Mods to https://mods.factorio.com/mod/space-exploration --

---------------------------------------------------------------------------
-- Remove difficult requirements from logistics technologies
---------------------------------------------------------------------------
if settings.startup["identifier-early-robot-logistics"].value then
    removePrerequisitesFrom('robot-attrition-explosion-safety', difficult_logistics_technologies)
end