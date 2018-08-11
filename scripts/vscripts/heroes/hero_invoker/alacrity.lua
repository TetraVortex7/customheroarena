--[[Author: Pizzalol reworked by Morningstar
	Date: 12.04.2015 > 11.08.2018
	Applies the alacrity values depending on ability lvl]]
function Alacrity( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_lvl = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor("bonus_damage", ability_lvl) 
	local attack_speed = ability:GetLevelSpecialValueFor("bonus_attack_speed", ability_lvl)
	local damage_modifier = keys.damage_modifier
	local speed_modifier = keys.speed_modifier

	-- Apply the bonus modifiers
	ability:ApplyDataDrivenModifier(caster, target, damage_modifier, {}) 
	ability:ApplyDataDrivenModifier(caster, target, speed_modifier, {})

	-- Set the values
	target:SetModifierStackCount(damage_modifier, ability, damage)
	target:SetModifierStackCount(speed_modifier, ability, attack_speed) 
end