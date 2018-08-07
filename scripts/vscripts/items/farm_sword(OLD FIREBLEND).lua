function gold(event)
	if event.ability:IsCooldownReady() then
		event.ability:StartCooldown(event.ability:GetCooldown(event.ability:GetLevel()))			
		local current = event.caster:GetGold()
		event.caster:SetGold(current + 5, false)
		ParticleManager:CreateParticle("particles/econ/courier/courier_flopjaw_gold/flopjaw_death_coins_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.caster)
		local particle = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_OVERHEAD_FOLLOW, event.caster)
		ParticleManager:SetParticleControl(particle, 0, event.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(10, 5, 0))
		ParticleManager:SetParticleControl(particle, 2, Vector(1, 2, 0))
		ParticleManager:SetParticleControl(particle, 3, Vector(255, 255, 0))
	end

end