if KillListener == nil then
	KillListener = class({})
end

function KillListener:Init()
    ListenToGameEvent("entity_killed", Dynamic_Wrap(self, 'entityKilled'), self)
end

function KillListener:entityKilled(data)
    local killed = EntIndexToHScript(data.entindex_killed)
    local Camp_spawner = GameRules.AddonTemplate.CampSpawner
    local Workers = GameRules.AddonTemplate.Workers
    local ParticleCreator = GameRules.AddonTemplate.ParticleCreator

    if killed.is_camp_creep then
        print("Убит противник с кемпа " .. killed.camp)
        if Camp_spawner.enemies_on_camp_left[killed.camp] > 1 then
            Camp_spawner.enemies_on_camp_left[killed.camp] = Camp_spawner.enemies_on_camp_left[killed.camp] - 1
            print("Осталось противников в лагере: " .. Camp_spawner.enemies_on_camp_left[killed.camp])   
        else
            GameRules:SendCustomMessage("<font color='#700072'>Лагерь ".. killed.camp .." зачищен</font>", 0, 0)
            local position = Camp_spawner.camp_position[killed.camp]
            ParticleCreator:FreeCampParticle(position)
            local build_trigger = SpawnEntityFromTableSynchronous("trigger_dota", {
                origin = position,
                scale = Vector(100,100,100)
            })
            build_trigger.OnStartTouch = function(self, entity)
                if entity:IsRealHero() then
                    print("Герой вошёл в триггер")
                end
            end
        end
    end
    
end