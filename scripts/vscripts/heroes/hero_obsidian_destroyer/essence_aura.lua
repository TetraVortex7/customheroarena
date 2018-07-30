function RestoreMana( keys )

	if keys.ability and keys.event_ability:GetManaCost(keys.event_ability:GetLevel()) > 30 and keys.event_ability:GetCooldown(keys.event_ability:GetLevel()) > 4 and not keys.event_ability:IsItem() then

			local target = keys.unit
			local ability = keys.ability
			local chance = ability:GetSpecialValueFor("restore_chance")
			local a = math.random(1,100)
			if RollPercentage(chance) then
				local restore_amount = ability:GetSpecialValueFor("restore_amount")
				local max_mana = target:GetMaxMana() * restore_amount / 100 
				local new_mana = target:GetMana() + max_mana
				local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN_FOLLOW, caster) 
				ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
				
				EmitSoundOn(keys.sound, target)
				if new_mana > target:GetMaxMana() then
					local value = target:GetMaxMana() - target:GetMana()
					target:SetMana(target:GetMaxMana())
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, target, value, nil )
				else
					local value = target:GetMana()
					target:SetMana(new_mana)
					local dd = target:GetMana() - value
					SendOverheadEventMessage( nil, OVERHEAD_ALERT_MANA_ADD , target, dd, nil )
				end
				
			end
	end
end