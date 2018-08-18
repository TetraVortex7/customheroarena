function kill_target( keys )
	local caster = keys.caster
	local ability = keys.ability
	local chanceProc = ability:GetLevelSpecialValueFor( "chance", ( ability:GetLevel() - 1 ) )
	local modifierName = "modifier_marksmanship_effect_datadriven"
	local victim = keys.target
	
	if RollPercentage(chanceProc) and not victim:IsHero() and not IsBoss(victim) and not IsSummoned(victim) then 
	victim:Kill(ability, caster)
	end
	
end