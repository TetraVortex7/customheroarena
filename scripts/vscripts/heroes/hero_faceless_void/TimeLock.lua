if faceless_void_time_lock_custom == nil then faceless_void_time_lock_custom = class({}) end

LinkLuaModifier("modifier_faceless_void_time_lock_custom_passive","heroes/hero_faceless_void/TimeLock.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stun","libraries/modifiers/modifier_stun.lua",LUA_MODIFIER_MOTION_NONE)

function faceless_void_time_lock_custom:GetIntrinsicModifierName(  )
	return "modifier_faceless_void_time_lock_custom_passive"
end

function faceless_void_time_lock_custom:GetCooldown(  )
	if self:GetCaster():HasAbility("slardar_bash_of_the_deep") then return self:GetSpecialValueFor("cd") * 2 end
	return self:GetSpecialValueFor("cd")
end

if modifier_faceless_void_time_lock_custom_passive == nil then modifier_faceless_void_time_lock_custom_passive = class({}) end

function modifier_faceless_void_time_lock_custom_passive:IsPurgable(  )
	return false
end

function modifier_faceless_void_time_lock_custom_passive:IsHidden(  )
	return true
end

function modifier_faceless_void_time_lock_custom_passive:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

require('libraries/IsBoss')

function modifier_faceless_void_time_lock_custom_passive:OnAttackLanded( params )
	local caster = self:GetCaster()
	if params.attacker == caster then 
		local ability = self:GetAbility()
		local chance = ability:GetSpecialValueFor("chance")
		local damage = ability:GetSpecialValueFor("damage")
		local duration = ability:GetSpecialValueFor("duration")
		local damage_type = ability:GetAbilityDamageType()
		local target = params.target
		if RollPercentage(chance) and not IsBoss(target) and ability:IsCooldownReady() and not target:IsMagicImmune() and target:IsAlive() then 
			target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
			ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = damage_type, ability = ability})
			target:AddNewModifier(caster,ability,"modifier_stun",{duration = duration})
		end
	end
end