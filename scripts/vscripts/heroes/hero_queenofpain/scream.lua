function Damage(event) 
local ability = event.ability
local caster = event.caster
local victim = event.target
local abilityDamage = ability:GetAbilityDamage()
local hpAsDamage = ability:GetLevelSpecialValueFor( "damage_pct", ( ability:GetLevel() - 1 ) )
local percentageDamage = victim:GetMaxHealth() * hpAsDamage / 100
local damageType = ability:GetAbilityDamageType()
local totalDamage = percentageDamage + abilityDamage

		local damageTable =
		{
			victim = victim,
			attacker = caster,
			damage = totalDamage,
			damage_type = damageType --stands for magical
		}
		ApplyDamage( damageTable )
end