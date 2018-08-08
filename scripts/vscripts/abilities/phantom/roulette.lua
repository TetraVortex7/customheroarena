function roulette(event)
	if event.ability ~= nil then
		local caster = event.caster
		local ability = event.ability
		caster:RemoveModifierByName("modifier_inc")
			if RollPercentage(50) then 
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_inc", {}) 
			end
	end
end