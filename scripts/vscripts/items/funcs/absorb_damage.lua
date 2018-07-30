function AbsorbDamage(event)
	local caster  = event.caster
	local ability = event.ability
	local damage  = event.damage or 0
	print("TRYING TO ABSORB DAMAGE")
	if not ability or not caster then return end
	if caster:IsIllusion() then return end
	
	caster:Heal(damage, ability)
end