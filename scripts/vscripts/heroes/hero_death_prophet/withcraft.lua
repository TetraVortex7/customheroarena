if death_prophet_witchcraft_c == nil then death_prophet_witchcraft_c = class({}) end

LinkLuaModifier("modifier_death_prophet_witchcraft_c_passive","heroes/hero_death_prophet/withcraft.lua",LUA_MODIFIER_MOTION_NONE)

function death_prophet_witchcraft_c:GetIntrinsicModifierName(  )
	return "modifier_death_prophet_witchcraft_c_passive"
end

if modifier_death_prophet_witchcraft_c_passive == nil then modifier_death_prophet_witchcraft_c_passive = class({}) end

function modifier_death_prophet_witchcraft_c_passive:IsHidden(  )
	return true
end

function modifier_death_prophet_witchcraft_c_passive:IsPurgable(  )
	return false
end

function modifier_death_prophet_witchcraft_c_passive:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_ABILITY_EXECUTED,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_death_prophet_witchcraft_c_passive:OnCreated(  )
	local ability = self:GetAbility()
	self.min_cd = ability:GetSpecialValueFor("min_cd")
	self.reduce = ability:GetSpecialValueFor("reduce")
	self.speed = ability:GetSpecialValueFor("speed")
end

function modifier_death_prophet_witchcraft_c_passive:OnRefresh(  )
	local ability = self:GetAbility()
	self.min_cd = ability:GetSpecialValueFor("min_cd")
	self.reduce = ability:GetSpecialValueFor("reduce")
	self.speed = ability:GetSpecialValueFor("speed")
end

function modifier_death_prophet_witchcraft_c_passive:OnAbilityExecuted( params )
	local caster = self:GetCaster()
	if params.unit == caster then 
		local ability = params.ability
		local ab_lvl = ability:GetLevel()
		local ab_cd = ability:GetCooldown(ab_lvl)
		local cd = ab_cd - self.reduce
		if not ability:GetName() == ("puck_phase_shift" or "necrolyte_reapers_scythe" or "pugna_decrepify" or "earthshaker_enchant_totem") then 
			if cd < self.min_cd then cd = self.min_cd end
			Timers:CreateTimer({endTime = 0.02, callback = function()
				ability:EndCooldown()

				ability:StartCooldown(cd)
			end})
		end
	end
end

function modifier_death_prophet_witchcraft_c_passive:GetModifierMoveSpeedBonus_Percentage(  )
	return self.speed
end