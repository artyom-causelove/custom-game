if ParticleCreator == nil then
	ParticleCreator = class({})
end

function ParticleCreator:FreeCampParticle(position)
	local field_particle = ParticleManager:CreateParticle(
		"particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_ring_wave.vpcf", 
		PATTACH_WORLDORIGIN, 
		nil
	)
	ParticleManager:SetParticleControl(field_particle, 0, position)
	
	--ParticleManager:DestroyParticle(field_particle, false)
	--ParticleManager:ReleaseParticleIndex(field_particle)
end