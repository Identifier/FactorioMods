-- Mods to https://mods.factorio.com/mod/aai-containers (included as a dependency of Krastorio 2) --

---------------------------------------------------------------------------
-- Remove difficult requirements from logistics technologies
---------------------------------------------------------------------------
if settings.startup["identifier-early-robot-logistics"].value then
    removePrerequisitesFrom('aai-strongbox-logistic', difficult_logistics_technologies)
    removePrerequisitesFrom('aai-storehouse-logistic', difficult_logistics_technologies)
    removePrerequisitesFrom('aai-warehouse-logistic', difficult_logistics_technologies)
end