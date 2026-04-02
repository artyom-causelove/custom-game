if KillListener == nil then
	KillListener = class({})
end

local Camp_spawner
local Workers
local ParticleCreator

function KillListener:Init()
    ListenToGameEvent("entity_killed", Dynamic_Wrap(self, 'entityKilled'), self)
    Camp_spawner = GameRules.AddonTemplate.CampSpawner
    Workers = GameRules.AddonTemplate.Workers
    ParticleCreator = GameRules.AddonTemplate.ParticleCreator
end

function KillListener:entityKilled(data)
    local killed = EntIndexToHScript(data.entindex_killed)
    if killed.is_camp_creep then
        if Camp_spawner.enemies_on_camp_left[killed.camp] > 1 then
            Camp_spawner.enemies_on_camp_left[killed.camp] = Camp_spawner.enemies_on_camp_left[killed.camp] - 1
        else
            self:CampCleared(killed.camp)
        end
    end
end

function KillListener:CampCleared(camp)
    GameRules:SendCustomMessage("<font color='#700072'>Лагерь ".. camp .." зачищен</font>", 0, 0)
    local position = Camp_spawner.camp_position[camp]
    ParticleCreator:FreeCampParticle(position)
    local placeholder = CreateUnitByName("npc_build_placeholder", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
    placeholder.camp = camp
    ParticleCreator:BuildingPlaceholder(placeholder)
    Workers.buildings[camp] = placeholder
end

function KillListener:KillAfterTimer(entity)
    Timers:CreateTimer(2, function()
        entity:RemoveSelf()
    end)
end