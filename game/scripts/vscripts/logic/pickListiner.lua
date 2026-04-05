if PickListener == nil then
	PickListener = class({})
end

function PickListener:OnPick(event)
	PlayerResource:GetPlayer(event.playerId):SetSelectedHero(event.heroname)
end
