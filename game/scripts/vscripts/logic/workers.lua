if Workers == nil then
	Workers = class({})
end

local Camp_spawner

function Workers:Init()
    Camp_spawner = GameRules.AddonTemplate.CampSpawner

    local spawns = Entities:FindAllByName("npc_worker")
    self.workers = {}
    self.buildings = {}
    for i = 1, #spawns do
        local origin = spawns[i]:GetAbsOrigin()
        local worker = CreateUnitByName("npc_worker", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)
        worker.is_worker = true
        worker.target = nil
        self.workers[i] = worker
    end
end

function Workers:BuildOn(camp)
    self.target = camp
    local position = Camp_spawner.camp_position[camp]
    for i=1, #self.workers do
        ExecuteOrderFromTable({
            UnitIndex = self.workers[i]:GetEntityIndex(),
            OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
            Position = position,
            Queue = true
        })
    end
    if self.buildings[camp] ~= nil then
        self.buildings[camp]:RemoveSelf()
    end
    local placeholder = CreateUnitByName("npc_build_place", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
    Timers:CreateTimer(function() placeholder:SetAbsOrigin(position) end)
    self.buildings[camp] = placeholder
    --self:PushOut(placeholder)
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