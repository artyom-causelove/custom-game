if CampSpawner == nil then
	CampSpawner = class({})
end

local camps_enemies = {"npc_troll_bandit"}
local camps = 2

function CampSpawner:SpawnCamps()
    print("Дошли до спавна")
    for i = 1, #camps_enemies do
        local camp_entity = Entities:FindAllByName(camps_enemies[i])
        for id = 1, #camp_entity do
            local camp_origin = camp_entity[id]:GetAbsOrigin()
            local enemy = CreateUnitByName(camps_enemies[i], camp_origin, true, nil, nil, DOTA_TEAM_BADGUYS)
            enemy.is_camp_creep = true
            enemy:SetForwardVector(Vector(math.cos(math.rad(RandomFloat(0, 360))), math.sin(math.rad(RandomFloat(0, 360))), 0))
        end
    end
    self.enemies_on_camp_left = {}
    self:AttachToCamps()
end

function CampSpawner:AttachToCamps()
    self.camp_position = {}
    for i = 1, camps do
        local camp_name = "camp_"..i
        local camp = Entities:FindByName(nil, camp_name)
        self.camp_position[i] = camp:GetAbsOrigin()
        local enemies = FindUnitsInRadius(
            DOTA_TEAM_GOODGUYS, 
            camp:GetAbsOrigin(), 
            nil, 
            1200, --радиус лагеря
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_ALL, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER, 
            false)
        print(#enemies)
        self.enemies_on_camp_left[i] = 0
        for j=1, #enemies do
            enemies[j].camp = i
            print(i)
            self.enemies_on_camp_left[i] = self.enemies_on_camp_left[i] + 1
            print(enemies[j].camp .. " - " .. self.enemies_on_camp_left[i])
        end
    end
end
