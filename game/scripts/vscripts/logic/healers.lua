if Healers == nil then
	Healers = class({})
end

function Healers:Init()
    self.healers = {}
    self.wagons = {}
    local spawns = Entities:FindAllByName("npc_healer")
    self.amount = #spawns
    for i=1, self.amount do
        local healer = CreateUnitByName("npc_healer", spawns[i]:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
        local wagon = SpawnEntityFromTableSynchronous("prop_dynamic", {
            model = "models/props_generic/wagon_wood_02_centaur.vmdl"
        })
        wagon:FollowEntity(healer, true)
        self.healers[i] = healer
        self.wagons[i] = wagon
    end
    self:GoTo((Vector(0, 0, 0)))
end

function Healers:GoTo(position)
    for i=1, self.amount do
        ExecuteOrderFromTable({
            UnitIndex = self.healers[i]:GetEntityIndex(),
            OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
            Position = position,
            Queue = true
        })
    end
end