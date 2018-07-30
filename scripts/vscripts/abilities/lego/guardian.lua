function check(event)
	if event.ability ~= nil then
		local caster = event.caster
		local ability = event.ability
		local dmg = caster:GetAverageTrueAttackDamage(caster)
		local GG = ability:GetLevelSpecialValueFor("dmg", ability:GetLevel())
		local def = math.ceil(dmg/GG)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_legion_guardian", {})
		caster:SetModifierStackCount("modifier_legion_guardian", caster, def)
	end
end