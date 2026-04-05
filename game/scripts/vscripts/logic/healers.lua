if Healers == nil then
	Healers = class({})
end

function Healers:Init()
    self.healers = {}
    self.wagons = {}
    self.target = {}
    local spawns = Entities:FindAllByName("npc_healer")
    self.amount = #spawns
    for i=1, self.amount do
        local healer = CreateUnitByName("npc_healer", spawns[i]:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
        local wagon = SpawnEntityFromTableSynchronous("prop_dynamic", {
           model = "models/props_generic/wagon_wood_02_centaur.vmdl"
        })
        wagon:SetParent(healer, "")
        wagon:SetModelScale(0.65)
        wagon:SetLocalOrigin(Vector(-145, 0, 36))
        wagon:SetLocalAngles(-20, 0, 0)
        self.healers[i] = healer
        self.wagons[i] = wagon
        self.target[i] = nil
    end
    Timers:CreateTimer(5, function() self:GoTo((Vector(0, 0, 0))) end)
end

function Healers:GoTo(position)
    for i=1, self.amount do
        ExecuteOrderFromTable({
            UnitIndex = self.healers[i]:GetEntityIndex(),
            OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
            Position = position,
            Queue = true
        })
        --self.wagons[i]:SetSequence("centaur_mount_run")
    end
end