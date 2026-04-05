require("logic/pickListiner")

require("utils/wearables")

if SpawnListener == nil then
	SpawnListener = class({})
end

function SpawnListener:Init()
  ListenToGameEvent("npc_spawned", Dynamic_Wrap(self, "OnSpawn"), self)
end

function SpawnListener:OnSpawn(params)
  local unit = EntIndexToHScript(params.entindex)
  local isHero = unit:IsRealHero()

  -- Hero unit spawned strategy
  if isHero and params.is_respawn == 0 then
    Wearable:Dress({
      type = "prop_dynamic", slot = "attach_attack1", hero = unit,
      model = "models/heroes/dragon_knight_persona/dk_persona_weapon.vmdl"
    })
    Wearable:Dress({
      type = "prop_dynamic", slot = "attach_hitloc", hero = unit,
      model = "models/heroes/dragon_knight_persona/dk_persona_head_hair.vmdl"
    })
    Wearable:Dress({
      type = "prop_dynamic", slot = "attach_head", hero = unit,
      model = "models/heroes/dragon_knight_persona/dk_persona_armor.vmdl"
    })
    CustomGameEventManager:Send_ServerToAllClients("portraits_init", {{
      player_id = 0
    }})
  end
end
