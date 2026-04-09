if Healers == nil then
	Healers = class({})
end

local home_position

function Healers:Init()
    home_position = Entities:FindByName(nil, "healers_home"):GetAbsOrigin()
    local home = CreateUnitByName("npc_build_healertent", home_position, true, nil, nil, DOTA_TEAM_GOODGUYS)
    home:SetAbsOrigin(home_position)
    home:SetHealthBarOffsetOverride(10000)
    self.home = home

    self.healers = {}
    local spawns = Entities:FindAllByName("npc_healer")
    self.amount = #spawns
    for i=1, self.amount do
        local healer = CreateUnitByName("npc_healer", spawns[i]:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
        self.healers[i] = healer
        healer.picked_hero = nil
        healer.target = nil
        healer.is_healer = true
    end
end

function Healers:Revive(healer)
    healer.picked_hero:RespawnHero(false, false)
    FindClearSpaceForUnit(healer.picked_hero, home_position, true)
    healer.target = nil
    healer.picked_hero = nil
end

function Healers:Home(healer)
    healer:StartGesture(ACT_DOTA_CAPTURE)
    Timers:CreateTimer(1, function()
        healer:FadeGesture(ACT_DOTA_CAPTURE)
        self:GoTo(healer, home_position)
    end)
end

function Healers:GoTo(healer ,position)
    ExecuteOrderFromTable({
        UnitIndex = healer:GetEntityIndex(),
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        Position = position,
        Queue = false
    })
end