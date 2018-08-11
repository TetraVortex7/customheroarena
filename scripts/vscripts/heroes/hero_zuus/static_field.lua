--[[Author: YOLOSPAGHETTI reworked by Morningstar 
	Date: March 24, 2016 > 11.08.2018
	Checks if the event was called by an ability and if so deals the health-based damage]]
function StaticField(keys)
	if not keys.caster:PassivesDisabled() then
		local caster = keys.caster
		local ability = keys.ability
		local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))
		local damage_health_pct = ability:GetLevelSpecialValueFor("damage_health_pct", (ability:GetLevel() -1))/100
			-- Finds every unit in the radius
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			DeepPrintTable(units)
			for i,unit in ipairs(units) do
				-- Attaches the particle
				local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN_FOLLOW, unit)
				ParticleManager:SetParticleControl(particle,0,unit:GetAbsOrigin())
				-- Plays the sound on the target
				EmitSoundOn(keys.sound, unit)
				-- Deals the damage based on the unit's current health
				ApplyDamage({victim = unit, attacker = caster, damage = unit:GetHealth() * damage_health_pct, damage_type = ability:GetAbilityDamageType()})
			end
	end
end
