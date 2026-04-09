LinkLuaModifier("modifier_hero_reviver", "abilities/hero_reviver", LUA_MODIFIER_MOTION_NONE)

hero_reviver = class({})

local Healers
local interval

function hero_reviver:GetIntrinsicModifierName()
    return "modifier_hero_reviver"
end

modifier_hero_reviver = class({})

function modifier_hero_reviver:IsHidden() return true end
function modifier_hero_reviver:IsPurgable() return false end


function modifier_hero_reviver:OnCreated()
    if not IsServer() then return end
    Healers = GameRules.AddonTemplate.Healers
    interval = self:GetAbility():GetSpecialValueFor("interval")
    self:StartIntervalThink(interval)
end

function modifier_hero_reviver:DeclareFunctions()
    return {
    }
end

function modifier_hero_reviver:OnIntervalThink()
    if not IsServer() then return end
    local units = FindUnitsInRadius(
            DOTA_TEAM_GOODGUYS, 
            self:GetParent():GetAbsOrigin(), 
            nil, 
            self:GetAbility():GetSpecialValueFor("aura_radius"),
            DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
            DOTA_UNIT_TARGET_ALL, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER, 
            false)

    for _, unit in pairs(units) do
        if unit.is_healer and unit.picked_hero ~= nil then
            Healers:Revive(unit)
        end
    end
end