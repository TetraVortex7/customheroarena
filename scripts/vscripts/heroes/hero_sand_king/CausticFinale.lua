if sandking_caustic_finale_custom == nil then sandking_caustic_finale_custom = class({}) end

LinkLuaModifier("modifier_caustic_finale_custom_passive","heroes/hero_sand_king/CausticFinale.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_caustic_finale_custom_poison","heroes/hero_sand_king/CausticFinale.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_caustic_finale_custom_slow","heroes/hero_sand_king/CausticFinale.lua",LUA_MODIFIER_MOTION_NONE)

function sandking_caustic_finale_custom:GetIntrinsicModifierName(  )
	return "modifier_caustic_finale_custom_passive"
end

if modifier_caustic_finale_custom_passive == nil then modifier_caustic_finale_custom_passive = class({}) end

function modifier_caustic_finale_custom_passive:IsHidden(  )
	return true
end

function modifier_caustic_finale_custom_passive:IsPurgable(  )
	return false
end

function modifier_caustic_finale_custom_passive:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_caustic_finale_custom_passive:OnAttackLanded( params )
	local caster = self:GetCaster()
	if caster == params.attacker and not params.target:IsMagicImmune() then 
		local ability = self:GetAbility()
		local duration = ability:GetSpecialValueFor("duration")
		if params.target:HasModifier("modifier_caustic_finale_custom_poison") then
			if RollPercentage(50) then 
				params.target:EmitSound("Ability.SandKing_CausticFinale")
				params.target:AddNewModifier(caster,ability,"modifier_caustic_finale_custom_poison", {duration = duration})
			end
		else
			params.target:EmitSound("Ability.SandKing_CausticFinale")
			params.target:AddNewModifier(caster,ability,"modifier_caustic_finale_custom_poison", {duration = duration})
		end
	end
end

if modifier_caustic_finale_custom_poison == nil then modifier_caustic_finale_custom_poison = class({}) end

function modifier_caustic_finale_custom_poison:IsDebuff(  )
	return true
end

function modifier_caustic_finale_custom_poison:GetAttributes(  )
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_caustic_finale_custom_poison:IsPurgable(  )
	return false
end

function modifier_caustic_finale_custom_poison:OnOwnerDied(  )
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local target = self:GetParent()
	local aoe = ability:GetSpecialValueFor("aoe")
	local duration = ability:GetSpecialValueFor("duration")
	local damage = ability:GetSpecialValueFor("damage")
	local Units = FindUnitsInRadius(caster:GetTeamNumber(),
                              target:GetAbsOrigin(),
                              nil,
                              aoe,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	for _, unit in pairs(Units) do
		if not unit:IsMagicImmune() then 
			local id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf",PATTACH_ABSORIGIN, unit)
			params.target:AddNewModifier(caster,ability,"modifier_caustic_finale_custom_poison", {duration = duration * 1.45})
			ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType(), ability = ability})
		end
	end
end

function modifier_caustic_finale_custom_poison:OnDestroy(  )
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local target = self:GetParent()
	local aoe = ability:GetSpecialValueFor("aoe")
	local duration = ability:GetSpecialValueFor("slow_duration")
	local damage = ability:GetSpecialValueFor("damage")
	local dmg_reduce = ability:GetSpecialValueFor("end_damage")
	damage = damage * dmg_reduce * 0.01
	local Units = FindUnitsInRadius(caster:GetTeamNumber(),
                              target:GetAbsOrigin(),
                              nil,
                              aoe,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	for _, unit in pairs(Units) do 
		if not unit:IsMagicImmune() then 
			local id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf",PATTACH_ABSORIGIN, unit)
			unit:AddNewModifier(caster,ability,"modifier_caustic_finale_custom_slow", {duration = duration})
			ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType(), ability = ability})
		end
	end
end

if modifier_caustic_finale_custom_slow == nil then modifier_caustic_finale_custom_slow = class({}) end

function modifier_caustic_finale_custom_slow:IsDebuff(  )
	return true
end

function modifier_caustic_finale_custom_slow:OnCreated(  )
	local ability = self:GetAbility()
	self.slow = ability:GetSpecialValueFor("slow")
end

function modifier_caustic_finale_custom_slow:OnRefresh(  )
	local ability = self:GetAbility()
	self.slow = ability:GetSpecialValueFor("slow")
end

function modifier_caustic_finale_custom_slow:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_caustic_finale_custom_slow:GetModifierMoveSpeedBonus_Percentage(  )
	return -self.slow
end