LinkLuaModifier("modifier_call_for_help", "abilities/call_for_help", LUA_MODIFIER_MOTION_NONE)

call_for_help = class({})

local KillListener
local Healers
local interval

function call_for_help:OnSpellStart()
    local position = self:GetCaster():GetAbsOrigin()
    Healers = GameRules.AddonTemplate.Healers
    
    for i=1, Healers.amount do
        if Healers.healers[i] ~= nil and Healers.healers[i].target == nil then
            Healers.healers[i].target = self:GetCaster():GetOwner()
            Healers:GoTo(Healers.healers[i], position)
            break;
        end
    end
end

function call_for_help:GetIntrinsicModifierName()
    return "modifier_call_for_help"
end

modifier_call_for_help = class({})

function modifier_call_for_help:IsHidden() return true end
function modifier_call_for_help:IsPurgable() return false end




function modifier_call_for_help:OnCreated()
    if not IsServer() then return end
    KillListener = GameRules.AddonTemplate.KillListener
    interval = self:GetAbility():GetSpecialValueFor("interval")
    self:StartIntervalThink(interval)
end

function modifier_call_for_help:DeclareFunctions()
    return {
    }
end

function modifier_call_for_help:OnIntervalThink()
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
        if unit.is_healer then
            local hero = self:GetParent():GetOwner()
            if unit.target == hero and unit.picked_hero == nil then
                KillListener:KillAfterTimer(self:GetParent())
                self:CallBackOthers()
                unit.picked_hero = hero
                unit.target = "home"
                Healers:Home(unit)
            end
        end
    end
end

function modifier_call_for_help:CallBackOthers()
    for i=1, Healers.amount do
        if Healers.healers[i] ~= nil and Healers.healers[i].target == self:GetCaster():GetOwner() and Healers.healers[i].picked_hero == nil then
            Healers.healers[i].target = nil
            Healers:GoTo(Healers.healers[i], Healers.home:GetAbsOrigin())
        end
    end
end