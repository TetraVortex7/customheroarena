if slardar_bash_of_the_deep == nil then slardar_bash_of_the_deep = class({}) end

LinkLuaModifier("modifier_slardar_bash_of_the_deep_passive","heroes/hero_slardar/Bash.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stun","libraries/modifiers/modifier_stun.lua",LUA_MODIFIER_MOTION_NONE)

function slardar_bash_of_the_deep:GetIntrinsicModifierName(  )
	return "modifier_slardar_bash_of_the_deep_passive"
end

function slardar_bash_of_the_deep:GetCooldown( nLevel )
	if self:GetCaster():HasAbility("faceless_void_time_lock_custom_custom") then return self:GetSpecialValueFor("cd") * 2 end
	return self:GetSpecialValueFor("cd")
end

if modifier_slardar_bash_of_the_deep_passive == nil then modifier_slardar_bash_of_the_deep_passive = class({}) end

function modifier_slardar_bash_of_the_deep_passive:IsPurgable(  )
	return false
end

function modifier_slardar_bash_of_the_deep_passive:IsHidden(  )
	return true
end

function modifier_slardar_bash_of_the_deep_passive:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

require('libraries/IsBoss')

function modifier_slardar_bash_of_the_deep_passive:OnAttackLanded( params )
	local caster = self:GetCaster()
	if params.attacker == caster then 
		local ability = self:GetAbility()
		local chance = ability:GetSpecialValueFor("chance")
		local damage = ability:GetSpecialValueFor("damage")
		local duration = ability:GetSpecialValueFor("duration")
		local damage_type = ability:GetAbilityDamageType()
		local target = params.target
		if RollPercentage(chance) and not IsBoss(target) and ability:IsCooldownReady() and target:IsAlive() then 
			target:EmitSound("Hero_Slardar.Bash")
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
			ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = damage_type, ability = ability})
			target:AddNewModifier(caster,ability,"modifier_stun",{duration = duration})
		end
	end
end