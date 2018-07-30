function mod(event)
if event.ability:IsCooldownReady() then
	local caster = event.caster
	local stacks
	if RollPercentage(50) then modifier = "modifier_templar_assassin_refraction_absorb" else modifier = "modifier_templar_assassin_refraction_damage" end
			if caster:HasModifier(modifier) then 
				local g = caster:GetModifierStackCount(modifier,caster)
				caster:SetModifierStackCount(modifier,ability,g+1)
				event.ability:StartCooldown(event.ability:GetCooldown(event.ability:GetLevel()))
			end
end
end
