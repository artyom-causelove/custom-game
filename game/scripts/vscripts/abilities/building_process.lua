LinkLuaModifier("modifier_building_process", "abilities/building_process", LUA_MODIFIER_MOTION_NONE)

building_process = class({})

function building_process:GetIntrinsicModifierName()
    return "modifier_building_process"
end

modifier_building_process = class({})

function modifier_building_process:IsHidden() return true end
function modifier_building_process:IsPurgable() return false end

function modifier_building_process:OnCreated()
    if not IsServer() then return end
    self.built = 0
end

function modifier_building_process:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
    }
end

function modifier_building_process:GetModifierTotal_ConstantBlock(params)
    if not IsServer() then return 0 end
    if params.attacker.is_worker then
        self.built = self.built + 1

    end
    if self.built == 10 then
        local Workers = GameRules.AddonTemplate.Workers
        local KillListener = GameRules.AddonTemplate.KillListener
        local home = Entities:FindByName(nil, "workers_home")
        local parent = self:GetParent()
        local building_name = parent.buiding_to_build
        local camp_id = parent.camp

        local building = CreateUnitByName(building_name, parent:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
        building:SetAbsOrigin(parent:GetAbsOrigin())
        Workers.buildings[camp_id] = building
        Workers:PushOut(building)

        KillListener:KillAfterTimer(parent)
        Workers:GoTo(home:GetAbsOrigin())
    end
    return params.damage
end