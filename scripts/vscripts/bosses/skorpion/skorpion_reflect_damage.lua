--[[
	Author: Tetravortex
	Date: 08.08.2018.
	Reflect damage
]]
function reflect_damage( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local damageTaken = keys.DamageTaken
	local ability = keys.ability
	local reflect = ability:GetLevelSpecialValueFor( "reflect_back_percentage", ( ability:GetLevel() - 1 ) )
  local damage = damageTaken * reflect / 100
  local damage_table = {
          victim = attacker,
          attacker = caster,
          damage = damage,
          damage_type = DAMAGE_TYPE_MAGICAL,
		  damage_flags = DOTA_DAMAGE_FLAG_REFLECTION
        }
  ApplyDamage(damage_table)
end
