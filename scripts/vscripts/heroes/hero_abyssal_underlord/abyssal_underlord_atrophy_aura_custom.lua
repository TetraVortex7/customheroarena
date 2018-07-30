if abyssal_underlord_atrophy_aura_custom == nil then abyssal_underlord_atrophy_aura_custom = class({}) end

LinkLuaModifier("modifier_abyssal_underlord_atrophy_aura_custom_passive","heroes/hero_abyssal_underlord/abyssal_underlord_atrophy_aura_custom.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_underlord_atrophy_aura_custom_damage","heroes/hero_abyssal_underlord/abyssal_underlord_atrophy_aura_custom.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_underlord_atrophy_aura_custom_aura","heroes/hero_abyssal_underlord/abyssal_underlord_atrophy_aura_custom.lua",LUA_MODIFIER_MOTION_NONE)

function abyssal_underlord_atrophy_aura_custom:GetIntrinsicModifierName(  )
	return "modifier_abyssal_underlord_atrophy_aura_custom_passive"
end

if modifier_abyssal_underlord_atrophy_aura_custom_passive == nil then modifier_abyssal_underlord_atrophy_aura_custom_passive = class({}) end

function modifier_abyssal_underlord_atrophy_aura_custom_passive:IsHidden(  )
	return true
end

function modifier_abyssal_underlord_atrophy_aura_custom_passive:IsPurgable(  )
	return false
end

function modifier_abyssal_underlord_atrophy_aura_custom_passive:IsAura(  )
	return true
end

function modifier_abyssal_underlord_atrophy_aura_custom_passive:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("range")
end

function modifier_abyssal_underlord_atrophy_aura_custom_passive:GetModifierAura()
    return "modifier_abyssal_underlord_atrophy_aura_custom_aura"
end
   
function modifier_abyssal_underlord_atrophy_aura_custom_passive:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_abyssal_underlord_atrophy_aura_custom_passive:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_abyssal_underlord_atrophy_aura_custom_passive:GetAuraSearchFlags(  )
	return {DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES}
end

function modifier_abyssal_underlord_atrophy_aura_custom_passive:GetAuraDuration()
    return 0.1
end

function modifier_abyssal_underlord_atrophy_aura_custom_passive:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_DEATH}
end

function modifier_abyssal_underlord_atrophy_aura_custom_passive:OnDeath( params )
	local caster = self:GetCaster()
	if params.unit:GetTeamNumber() ~= caster:GetTeamNumber() and params.attacker:GetTeamNumber() == caster:GetTeamNumber() then
		local ability = self:GetAbility()

		local distance = math.abs((caster:GetAbsOrigin()-params.unit:GetAbsOrigin()):Length2D())
		local chance = ability:GetSpecialValueFor("normal_chance") - (distance * ability:GetSpecialValueFor("chance_per_unit"))
		if chance < ability:GetSpecialValueFor("min_chance") then
			chance = ability:GetSpecialValueFor("min_chance")
		elseif chance > ability:GetSpecialValueFor("max_chance") then 
			chance = ability:GetSpecialValueFor("max_chance")
		end
		if RollPercentage(chance) then
			local duration = ability:GetSpecialValueFor("duration")
			caster:AddNewModifier(caster,ability,"modifier_abyssal_underlord_atrophy_aura_custom_damage",{duration = duration})
			local stacks = caster:GetModifierStackCount("modifier_abyssal_underlord_atrophy_aura_custom_damage",caster)
			if params.unit:IsRealHero() then
				caster:SetModifierStackCount("modifier_abyssal_underlord_atrophy_aura_custom_damage",caster,stacks + ability:GetSpecialValueFor("damage_hero"))
				Timers:CreateTimer({endTime = duration, callback = function() 
						local stack = caster:GetModifierStackCount("modifier_abyssal_underlord_atrophy_aura_custom_damage",caster)
						local damage = ability:GetSpecialValueFor("damage_hero")
						caster:SetModifierStackCount("modifier_abyssal_underlord_atrophy_aura_custom_damage",caster,stacks - damage)
				end})
			else
				caster:SetModifierStackCount("modifier_abyssal_underlord_atrophy_aura_custom_damage",caster,stacks + ability:GetSpecialValueFor("damage"))
				Timers:CreateTimer({endTime = duration, callback = function() 
						local stack = caster:GetModifierStackCount("modifier_abyssal_underlord_atrophy_aura_custom_damage",caster)
						local damage = ability:GetSpecialValueFor("damage")
						caster:SetModifierStackCount("modifier_abyssal_underlord_atrophy_aura_custom_damage",caster,stacks - damage)
				end})
			end
		end
	end
end

if modifier_abyssal_underlord_atrophy_aura_custom_aura == nil then modifier_abyssal_underlord_atrophy_aura_custom_aura = class({}) end

function modifier_abyssal_underlord_atrophy_aura_custom_aura:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}
end

function modifier_abyssal_underlord_atrophy_aura_custom_aura:IsDebuff(  )
	return true
end

function modifier_abyssal_underlord_atrophy_aura_custom_aura:GetTexture(  )
	return "abyssal_underlord_atrophy_aura_custom"
end

function modifier_abyssal_underlord_atrophy_aura_custom_aura:IsPurgable(  )
	return false
end

function modifier_abyssal_underlord_atrophy_aura_custom_aura:OnCreated(  )
	self.reduce = -self:GetAbility():GetSpecialValueFor("reduce")
end

function modifier_abyssal_underlord_atrophy_aura_custom_aura:GetModifierBaseDamageOutgoing_Percentage(  )
	return self.reduce
end

if modifier_abyssal_underlord_atrophy_aura_custom_damage == nil then modifier_abyssal_underlord_atrophy_aura_custom_damage = class({}) end

function modifier_abyssal_underlord_atrophy_aura_custom_damage:GetTexture(  )
	return self:GetAbility():GetName()
end

function modifier_abyssal_underlord_atrophy_aura_custom_damage:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end

function modifier_abyssal_underlord_atrophy_aura_custom_damage:OnCreated(  )
	self.damage = self:GetAbility():GetSpecialValueFor("damage_per_stack")
end

function modifier_abyssal_underlord_atrophy_aura_custom_damage:GetModifierPreAttack_BonusDamage(  )
	return self:GetStackCount() * self.damage
end