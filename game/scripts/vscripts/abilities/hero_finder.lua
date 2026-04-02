LinkLuaModifier("modifier_hero_finder", "abilities/hero_finder", LUA_MODIFIER_MOTION_NONE)

hero_finder = class({})

function hero_finder:GetIntrinsicModifierName()
    return "modifier_hero_finder"
end

modifier_hero_finder = class({})


local interval = 2

function modifier_hero_finder:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(interval)
end

function modifier_hero_finder:DeclareFunctions()
    return {
    }
end

function modifier_hero_finder:OnIntervalThink()
    if not IsServer() then return end
    local heroes = FindUnitsInRadius(
            DOTA_TEAM_GOODGUYS, 
            self:GetParent():GetAbsOrigin(), 
            nil, 
            400,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
            DOTA_UNIT_TARGET_HERO, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER, 
            false)

    if #heroes > 0 then
        self:ShowBuildingWindow(heroes[1]:GetPlayer())
        --local camp = self:GetParent().camp
        --GameRules.AddonTemplate.Workers:BuildOn(camp)
    end
end

function modifier_hero_finder:ShowBuildingWindow(player)
    CustomGameEventManager:Send_ServerToPlayer(
        player,
        'custom_building_window_show',
        {
            {
                class = 'npc_dota_sawmill',
                title = 'Лесопилка',
                image = 's2r://panorama/images/hud/facets/innate_icon_large_png.vtex',
                price = 1000,
                description = 'Описание постройки "Лесопилка"'
            },
            {
                class = 'npc_dota_anvil',
                title = 'Кузница',
                image = 's2r://panorama/images/hud/facets/innate_icon_large_png.vtex',
                price = 1200,
                description = 'Описание постройки "Кузница"'
            }
        }
    );
end


function modifier_hero_finder:IsHidden() return true end
