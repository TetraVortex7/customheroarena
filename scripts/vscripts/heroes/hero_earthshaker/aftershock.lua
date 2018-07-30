--[[Author: YOLOSPAGHETTI
	Date: July 30, 2016
	Triggers an aftershock when the caster casts a spel
	Rewrited: Se7eN
	Date: 25.10.2016]]
function Aftershock(keys)
	if keys.ability and keys.event_ability:GetCooldown(keys.event_ability:GetLevel()-1) > 3 and keys.ability:IsCooldownReady() and not keys.event_ability:IsItem() then
	local caster = keys.caster
	local ability = keys.ability
	local aftershock_range = ability:GetLevelSpecialValueFor("aftershock_range", (ability:GetLevel() -1))
	local tooltip_duration = ability:GetLevelSpecialValueFor("tooltip_duration", (ability:GetLevel() -1))
	local cd = ability:GetCooldown(ability:GetLevel()-1)
	local target = keys.target_entities
	for _,v in pairs(target) do
	print(target)
	end
	
	local particle1 = ParticleManager:CreateParticle(keys.particle1, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
	ParticleManager:SetParticleControl(particle1, 1, Vector(aftershock_range,aftershock_range,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
	ParticleManager:SetParticleControl(particle1, 2, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
	-- Loops throught the caster's abilities
			if target then
				for _,unit in pairs(target) do
					
					-- Applies the stun modifier to the target
					unit:AddNewModifier(caster, nil, "modifier_stunned", {Duration = tooltip_duration})
					-- Applies the damage to the target
					ApplyDamage({victim = unit, attacker = caster, damage = ability:GetAbilityDamage(), damage_type = ability:GetAbilityDamageType()})
					
					-- Renders the dirt particle around the caster
				end
				ability:StartCooldown(ability:GetCooldown(ability:GetLevel()-1))
			end
			
	end
end