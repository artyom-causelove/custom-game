require("logic/camp_spawner")
require("logic/workers")
require("logic/killListener")
require("logic/particleCreator")

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
end