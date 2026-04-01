if Workers == nil then
	Workers = class({})
end

function Workers:Init()
    local spawns = Entities:FindAllByName("npc_worker")
    print("Спавн рабочих")
    self.workers = {}
    for i = 1, #spawns do
        local origin = spawns[i]:GetAbsOrigin()
        local worker = CreateUnitByName("npc_worker", origin, true, nil, nil, DOTA_TEAM_GOODGUYS)
        worker.is_worker = true
        worker.target = nil
        print(i .. " рабочий готов")
        self.workers[i] = worker
    end
end

function Workers:BuildOn(position)
    self.target = position
    for i=1, #self.workers do
        ExecuteOrderFromTable({
            UnitIndex = self.workers[i]:GetEntityIndex(),
            OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
            Position = position,
            Queue = true
        })
    end
    --local placeholder = CreateUnitByName("npc_build_place", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
    --Timers:CreateTimer(function() placeholder:SetAbsOrigin(position) end)
    self:PushOut(placeholder)
end

function Workers:PushOut(building)
    local origin = building:GetAbsOrigin()
    local radius = 300
    local units = FindUnitsInRadius(
        building:GetTeamNumber(),
        building:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_ALL,
        DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
        FIND_ANY_ORDER,
        false
    )
    for i=1, #units do
        if units[i] ~= building then
            local direction = (units[i]:GetAbsOrigin() - origin):Normalized()
            local new_pos = origin + direction * (radius + 100)
            FindClearSpaceForUnit(units[i], new_pos, true)
        end
    end
end