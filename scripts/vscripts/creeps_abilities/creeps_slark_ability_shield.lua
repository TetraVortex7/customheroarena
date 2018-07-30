if creeps_slark_ability_shield == nil then
	creeps_slark_ability_shield = class({})
end

LinkLuaModifier("modifier_creeps_slark_ability_shield","creeps_abilities/creeps_slark_ability_shield.lua",LUA_MODIFIER_MOTION_NONE)

function creeps_slark_ability_shield:OnSpellStart(  )
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSound("ui.crafting_gem_create|soundevents/game_sounds_ui.vsndevts")
		local ability = self
		local particle = "particles/slark_infinity_blades.vpcf"
		local ID0 = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt(ID0, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(ID0, 3, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
		Timers:CreateTimer({endTime = 0.3, callback = function() 

		ParticleManager:DestroyParticle(ID0,false)
		caster:AddNewModifier(caster, ability, "modifier_creeps_slark_ability_shield", {duration = ability:GetSpecialValueFor("duration")}) end})
	end
end

------------------------

if modifier_creeps_slark_ability_shield == nil then
	modifier_creeps_slark_ability_shield = class({})
end

function modifier_creeps_slark_ability_shield:DeclareFunctions(  )
	local hFuncs = { MODIFIER_EVENT_ON_TAKEDAMAGE }
	return hFuncs
end

function modifier_creeps_slark_ability_shield:OnTakeDamage( params )
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local attacker = params.attacker
	if params.unit == caster then
		local damage_type = GetDamageTypeFromNumber(params.damage_type)
		local enemies = 0
		local Units = FindUnitsInRadius(caster:GetTeamNumber(),
						caster:GetAbsOrigin(),
						nil,
						900,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_ALL,
						DOTA_UNIT_TARGET_FLAG_NONE,
						FIND_ANY_ORDER,
						false)

		for _, unit in pairs(Units) do
			if unit:IsRealHero() then 
				enemies = enemies + 1
			elseif unit:IsHero() then
				enemies = enemies + 0.5
			else
				enemies = enemies + 0.1
			end
		end

		for _, unit in pairs(Units) do
			local damage = params.damage
			if damage_type == 1 then damage = params.damage * 2 end
			ApplyDamage({victim = unit, attacker = caster, damage = damage / math.floor(enemies), damage_type = damage_type, ability = ability})
		end
	end
end

function modifier_creeps_slark_ability_shield:GetTexture(  )
	return "creeps_slark_ability_shield"
end