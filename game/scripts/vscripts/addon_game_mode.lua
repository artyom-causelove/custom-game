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

	PrecacheResource( "model", "models/props_structures/radiant_ranged_barracks001.vmdl", context )
	PrecacheResource( "model", "models/props_gameplay/item_repair_kit_round.vmdl", context )
	PrecacheResource( "particle", "particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_ring_wave.vpcf", context )
end


function Activate()
	GameRules.AddonTemplate = MainMode()
	GameRules.AddonTemplate:InitGameMode()
end

