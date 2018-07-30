function apply(event)
local caster = event.caster
local ability = event.ability
local ability = event.ability
	if caster:IsMoving() 
		then 
		ability:ApplyDataDrivenModifier(caster, caster, "resist", {})
		else
		caster:RemoveModifierByName("resist")
	end
end