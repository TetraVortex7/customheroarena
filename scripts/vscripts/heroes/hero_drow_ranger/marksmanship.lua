function kill_target( keys )
	local caster = keys.caster
	local ability = keys.ability
	local chanceProc = ability:GetLevelSpecialValueFor( "chance", ( ability:GetLevel() - 1 ) )
	local modifierName = "modifier_marksmanship_effect_datadriven"
	local victim = keys.target
	local differenceBetweenLevels = (caster:GetLevel() - victim:GetLevel()) >= 0
	
	if RollPercentage(chanceProc) and not victim:IsHero() and not IsBoss(victim) and not IsSummoned(victim) and differenceBetweenLevels then 
	victim:Kill(ability, caster)
	end
	
end