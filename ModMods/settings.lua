---------------------------------------------------------------------------
-- Remove difficult requirements from logistics technologies
---------------------------------------------------------------------------
data:extend({
    {
        type = "bool-setting",
        name = "identifier-early-robot-logistics",
        setting_type = "startup",
        default_value = false
    }
})