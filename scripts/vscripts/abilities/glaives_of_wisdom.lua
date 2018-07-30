--[[Glaives of Wisdom intelligence to damage
	Author: chrislotix
	Date: 10.1.2015.
	
	Modified by Se7eN for Custom Hero Arena
	18 10 2016
	]]

function IntToDamage( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local int_caster = caster:GetIntellect()
	local int_damage = ability:GetLevelSpecialValueFor("intellect_damage_pct", (ability:GetLevel() -1)) 
	local dop_damage = ability:GetLevelSpecialValueFor("dop_uron", (ability:GetLevel() -1))
	
	
	local damage_table = {}

	damage_table.attacker = caster
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.victim = target

	damage_table.damage = (int_caster * int_damage / 100) + dop_damage
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage_table.damage, nil )
	ApplyDamage(damage_table)

end