require("main")
require("utils/timers")


function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheResource( "model", "models/heroes/troll_warlord/troll_warlord.vmdl", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_troll_warlord", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts", context )
	PrecacheResource( "model", "models/heroes/rattletrap/rattletrap.vmdl", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_rattletrap", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts", context )
	PrecacheResource( "model", "models/heroes/keeper_of_the_light/keeper_of_the_light.vmdl", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_keeper_of_the_light", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context )

	PrecacheResource( "model", "models/props_structures/radiant_ranged_barracks001.vmdl", context )
	PrecacheResource( "model", "models/props_gameplay/item_repair_kit_round.vmdl", context )
	PrecacheResource( "model", "models/development/invisiblebox.vmdl", context )
	PrecacheResource( "model", "models/buildings/blacksmith/blacksmith_house.vmdl", context )
	PrecacheResource( "model", "models/props_generic/wagon_wood_02_centaur.vmdl", context )

	PrecacheResource( "model", "models/heroes/dragon_knight_persona/dk_persona_weapon.vmdl", context )
	PrecacheResource( "model", "models/heroes/dragon_knight_persona/dk_persona_head_hair.vmdl", context )
	PrecacheResource( "model", "models/heroes/dragon_knight_persona/dk_persona_armor.vmdl", context )


	PrecacheResource( "particle", "particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_ring_wave.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_minefield_hammer.vpcf", context )
end


function Activate()
	GameRules.AddonTemplate = MainMode()
	GameRules.AddonTemplate:InitGameMode()
end

