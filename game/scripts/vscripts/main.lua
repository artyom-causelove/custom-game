require("logic/camp_spawner")
require("logic/workers")
require("logic/killListener")
require("logic/particleCreator")

require("utils/timers");

if MainMode == nil then
	MainMode = class({})
end

function MainMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function MainMode:InitGameMode()
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
    GameRules:SetPreGameTime(0)
    GameRules:SetStrategyTime(0)
    GameRules:SetShowcaseTime(0)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 5)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)

    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(self, 'modeStateChange'), self)
end

function MainMode:modeStateChange(data)
    local new_state = GameRules:State_Get()
    if new_state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        self:StartGame()
    end
end

function MainMode:StartGame()
    MainMode.Workers = Workers()
    MainMode.CampSpawner = CampSpawner()
    MainMode.KillListener = KillListener()
    MainMode.ParticleCreator = ParticleCreator()

    MainMode.CampSpawner:SpawnCamps()
    MainMode.Workers:Init()
    MainMode.KillListener:Init()

    -- Удалить когда будут доделаны триггеры на зачищенные кемпы.
    -- И вызывать этот эвент только тому игроку который зашел в триггер.
    -- CustomGameEventManager:Send_ServerToPlayer(
    --     player, <- Это должена быть сущность игрока можно получить, например, вот так PlayerResource:GetPlayer(int playerID)
    --     'custom_building_window_show',
    --     {
    --         {
    --             class = 'npc_dota_sawmill',
    --             title = 'Лесопилка',
    --             image = 's2r://panorama/images/hud/facets/innate_icon_large_png.vtex',
    --             price = 1000,
    --             description = 'Описание постройки "Лесопилка"'
    --         },
    --         {
    --             class = 'npc_dota_anvil',
    --             title = 'Кузница',
    --             image = 's2r://panorama/images/hud/facets/innate_icon_large_png.vtex',
    --             price = 1200,
    --             description = 'Описание постройки "Кузница"'
    --         }
    --     }
    -- );
    Timers:CreateTimer(10, function()
        CustomGameEventManager:Send_ServerToAllClients('custom_building_window_show', {
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
        });
        return 10;
    end)
end