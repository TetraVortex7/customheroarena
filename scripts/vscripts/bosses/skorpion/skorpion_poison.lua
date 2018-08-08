--[[
	Author: Tetravortex
	Date: 08.08.2018.
	Just damage per tick
]]
function damage_target(keys)	
	local damage_to_deal = keys.PoisonDamagePerSecond * keys.PoisonDamageInterval   --This gives us the damage per interval.
	local current_hp = keys.caster:GetHealth()
	
	if damage_to_deal >= current_hp then  --Poison Attack damage over time is non-lethal, so deal less damage if needed.
		damage_to_deal = current_hp - 1
	end
	
	ApplyDamage({victim = keys.target, attacker = keys.caster, damage = damage_to_deal, damage_type = DAMAGE_TYPE_MAGICAL,})
end