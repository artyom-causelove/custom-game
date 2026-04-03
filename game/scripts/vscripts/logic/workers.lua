if Workers == nil then
	Workers = class({})
end

local Camp_spawner

function Workers:Init()
    CustomGameEventManager:RegisterListener('custom_building_picked', Dynamic_Wrap(self, 'Build'))

    Camp_spawner = GameRules.AddonTemplate.CampSpawner

    local spawns = Entities:FindAllByName("npc_worker")
    self.workers = {}
    self.buildings = {}
    self.amount = #spawns
    for i = 1, self.amount do
        local origin = spawns[i]:GetAbsOrigin()
        local worker = CreateUnitByName("npc_worker", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)
        worker.is_worker = true
        self.workers[i] = worker
    end

    self.target = nil
end

-- event: {
--   campId = integer
--   buildingName = string
-- }
function Workers:Build(event)
    local this = GameRules.AddonTemplate.Workers
    this.target = event.campId
    local position = Camp_spawner.camp_position[event.campId]
    if this.buildings[event.campId] ~= nil then
        this.buildings[event.campId]:RemoveSelf()
    end

    local placeholder = CreateUnitByName("npc_build_place", position, true, nil, nil, DOTA_TEAM_NEUTRALS)
    Timers:CreateTimer(function() placeholder:SetAbsOrigin(position) end)
    placeholder.buiding_to_build = event.buildingName
    placeholder.camp = event.campId
    placeholder:SetHealthBarOffsetOverride(10000)
    this.buildings[event.campId] = placeholder

    for i=1, #this.workers do
        this.workers[i]:SetForceAttackTarget(placeholder)
    end

end


function Workers:GoTo(position)
    for i=1, self.amount do
            ExecuteOrderFromTable({
            UnitIndex = self.workers[i]:GetEntityIndex(),
            OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
            Position = position,
            Queue = false
        })
    end
end

-- function Workers:PushOut(building)
--     local origin = building:GetAbsOrigin()
--     local radius = 300
--     local units = FindUnitsInRadius(
--         building:GetTeamNumber(),
--         building:GetAbsOrigin(),
--         nil,
--         radius,
--         DOTA_UNIT_TARGET_TEAM_BOTH,
--         DOTA_UNIT_TARGET_ALL,
--         DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
--         FIND_ANY_ORDER,
--         false
--     )
--     for i=1, #units do
--         if units[i] ~= building then
--             local direction = (units[i]:GetAbsOrigin() - origin):Normalized()
--             local new_pos = origin + direction * (radius + 100)
--             FindClearSpaceForUnit(units[i], new_pos, true)
--         end
--     end
-- end