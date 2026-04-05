if Wearable == nil then
	Wearable = class({})
end

function Wearable:Dress(params)
  local item = SpawnEntityFromTableSynchronous(params.type, { model = params.model })
  item:SetParent(params.hero, params.slot)
  item:FollowEntity(params.hero, true)
  item:SetOwner(params.hero)
end
