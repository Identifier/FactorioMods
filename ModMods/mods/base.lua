-- Mods to the base game --

---------------------------------------------------------------------------
-- Remove difficult requirements from logistics technologies
---------------------------------------------------------------------------
if settings.startup["identifier-early-robot-logistics"].value then
    removePrerequisitesFrom('logistic-robotics', difficult_logistics_technologies)
    removePrerequisitesFrom('logistic-system', difficult_logistics_technologies)
end    