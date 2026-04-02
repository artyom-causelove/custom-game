LinkLuaModifier("modifier_hero_finder", "abilities/hero_finder", LUA_MODIFIER_MOTION_NONE)

hero_finder = class({})

function hero_finder:GetIntrinsicModifierName()
    return "modifier_hero_finder"
end

modifier_hero_finder = class({})

function modifier_hero_finder:IsHidden() return true end
function modifier_hero_finder:IsPurgable() return false end

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

    for _, hero in pairs(heroes) do
        if hero:IsRealHero() and hero:IsAlive() and not hero:IsIllusion() then
            self:ShowBuildingWindow(hero:GetPlayerOwner())
        end
    end
end

function modifier_hero_finder:ShowBuildingWindow(player)
    CustomGameEventManager:Send_ServerToPlayer(
        player,
        'custom_building_window_show',
        {
            campId = self:GetParent().camp,
            buildings = {
                {
                    class = 'npc_build_sawmill',
                    title = 'Лесопилка',
                    image = 's2r://panorama/images/hud/facets/innate_icon_large_png.vtex',
                    price = 1000,
                    description = 'Описание постройки "Лесопилка"'
                },
                {
                    class = 'npc_build_anvil',
                    title = 'Кузница',
                    image = 's2r://panorama/images/hud/facets/innate_icon_large_png.vtex',
                    price = 1200,
                    description = 'Описание постройки "Кузница"'
                }
            }
        }
    );
end
