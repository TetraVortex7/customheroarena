if creeps_doom_ability_mana_steal == nil then creeps_doom_ability_mana_steal = class({}) end

LinkLuaModifier("modifier_creeps_doom_ability_mana_steal_burn","creeps_abilities/creeps_doom_ability_mana_steal.lua",LUA_MODIFIER_MOTION_NONE)

function creeps_doom_ability_mana_steal:OnSpellStart(  )
	local caster = self:GetCaster()
	local mana = self:GetSpecialValueFor("prc")
	local max_targets = self:GetSpecialValueFor("max_targets")
	local current = 0
	local integer = RandomInt(0,3)
	if integer == 0 then 
		caster:EmitSound("Hero_DoomBringer.DevourCast")
	elseif integer == 1 then 
		caster:EmitSound("Hero_DoomBringer.DevourCast")
	elseif integer == 2 then 
		caster:EmitSound("Hero_DoomBringer.LvlDeath")
	elseif integer == 3 then 
		caster:EmitSound("Hero_DoomBringer.DevourCast")
	end

	local Units = FindUnitsInRadius(caster:GetTeamNumber(),
                              caster:GetAbsOrigin(),
                              nil,
                              self:GetSpecialValueFor("range"),
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	for _,target in pairs(Units) do

		current = current + 1
		if current > max_targets then break end
		if target:HasModifier("modifier_creeps_doom_ability_mana_steal_burn") then break end

		target:EmitSound("Hero_StormSpirit.BallLightning")
		local id0 = ParticleManager:CreateParticle("particles/econ/items/razor/razor_punctured_crest/razor_storm_lightning_strike_blade.vpcf",PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(id0, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z+caster:GetBoundingMaxs().z * 2), false)
		ParticleManager:SetParticleControlEnt(id0, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z+target:GetBoundingMaxs().z * 2), false)
		ParticleManager:SetParticleControl(id0, 18, Vector(1,1,2))
		local target_mana = target:GetMana() * self:GetSpecialValueFor("prc") * 0.01
		target:SpendMana(target_mana,self)
		caster:GiveMana(target_mana*0.75)
		if RollPercentage(self:GetSpecialValueFor("chance")) then
			target:AddNewModifier(caster,self,"modifier_creeps_doom_ability_mana_steal_burn",{duration = self:GetSpecialValueFor("duration")})
		end
	end
end

if modifier_creeps_doom_ability_mana_steal_burn == nil then modifier_creeps_doom_ability_mana_steal_burn = class({}) end

function modifier_creeps_doom_ability_mana_steal_burn:IsDebuff(  )
	return true
end

function modifier_creeps_doom_ability_mana_steal_burn:IsPurgable(  )
	return false
end

function modifier_creeps_doom_ability_mana_steal_burn:GetTexture(  )
	return "creeps_doom_ability_mana_steal"
end

require("libraries/timers")

function modifier_creeps_doom_ability_mana_steal_burn:OnCreated(  )
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local target = self:GetParent()
	local prc = ability:GetSpecialValueFor("prc_c") * 0.01
	local rate = ability:GetSpecialValueFor("rate")
	self.timer = Timers:CreateTimer(rate,
	function() 
		local mana = target:GetMana() * prc
		target:SpendMana(mana,ability)
		caster:GiveMana(mana*0.75)
		return rate 
	end)
end

function modifier_creeps_doom_ability_mana_steal_burn:OnDestroy(  )
	Timers:RemoveTimer(self.timer)
end