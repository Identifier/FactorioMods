-- Mods to https://mods.factorio.com/mod/logistic-cargo-wagon --

---------------------------------------------------------------------------
-- Remove difficult requirements from logistics technologies
---------------------------------------------------------------------------
if settings.startup["identifier-early-robot-logistics"].value then
    removePrerequisitesFrom('logistic-cargo-wagon', difficult_logistics_technologies)
end