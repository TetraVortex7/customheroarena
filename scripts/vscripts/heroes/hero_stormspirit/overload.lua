if storm_spirit_overload_c == nil then storm_spirit_overload_c = class({}) end

LinkLuaModifier("modifier_storm_spirit_overload_c_passive","heroes/hero_stormspirit/overload.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_storm_spirit_overload_buff","heroes/hero_stormspirit/overload.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_storm_spirit_overload_c_slow","heroes/hero_stormspirit/overload.lua",LUA_MODIFIER_MOTION_NONE)

function storm_spirit_overload_c:GetIntrinsicModifierName(  )
	return "modifier_storm_spirit_overload_c_passive"
end

if modifier_storm_spirit_overload_c_passive == nil then modifier_storm_spirit_overload_c_passive = class({}) end

function modifier_storm_spirit_overload_c_passive:IsHidden(  )
	return true
end

function modifier_storm_spirit_overload_c_passive:IsPurgable(  )
	return false
end

function modifier_storm_spirit_overload_c_passive:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_ABILITY_EXECUTED}
end

function modifier_storm_spirit_overload_c_passive:OnAbilityExecuted( params )
	local caster = self:GetCaster()
	if params.unit == caster then 
		local ability = self:GetAbility()
		if params.ability:GetCooldown(params.ability:GetLevel()) > 1 and params.ability:GetManaCost(params.ability:GetLevel()) > 20 then 
			caster:AddNewModifier(caster,ability,"modifier_storm_spirit_overload_buff",{})
		end
	end
end

if modifier_storm_spirit_overload_buff == nil then modifier_storm_spirit_overload_buff = class({}) end

function modifier_storm_spirit_overload_buff:GetTexture(  )
	return self:GetAbility():GetName()
end

function modifier_storm_spirit_overload_buff:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_storm_spirit_overload_buff:OnCreated(  )
	self.id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf",PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.id0, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
	local ability = self:GetAbility()
	self.prc = ability:GetSpecialValueFor("prc_scepter") * 0.01
	self.duration = ability:GetSpecialValueFor("duration")
	self.range = ability:GetSpecialValueFor("range")
	self.damage = ability:GetSpecialValueFor("damage")
end

function modifier_storm_spirit_overload_buff:OnDestroy(  )
	ParticleManager:DestroyParticle(self.id0, false)
end

function modifier_storm_spirit_overload_buff:OnAttackLanded( params )
	local caster = self:GetCaster()
	if params.attacker == caster then
		print("123") 
		local ability = self:GetAbility()
		local target = params.target
		local units = FindUnitsInRadius(caster:GetTeamNumber(),
                              target:GetAbsOrigin(),
                              nil,
                              self.range,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
		target:EmitSound("Hero_StormSpirit.Overload")
		local id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf",PATTACH_ABSORIGIN, target)
		if not target:IsMagicImmune() then
			ApplyDamage({victim = target, attacker = caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		end
		for _,unit in pairs(units) do 
			if not unit:IsMagicImmune() then
				if unit ~= target and caster:HasScepter() then 
					ApplyDamage({victim = unit, attacker = caster, damage = self.damage * self.prc, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
				end
				unit:AddNewModifier(caster,ability,"modifier_storm_spirit_overload_c_slow",{duration = self.duration})
			end
		end
		caster:RemoveModifierByName("modifier_storm_spirit_overload_buff")
	end
end

if modifier_storm_spirit_overload_c_slow == nil then modifier_storm_spirit_overload_c_slow = class({}) end

function modifier_storm_spirit_overload_c_slow:GetTexture(  )
	return self:GetAbility():GetName()
end

function modifier_storm_spirit_overload_c_slow:IsDebuff(  )
	return true
end

function modifier_storm_spirit_overload_c_slow:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_storm_spirit_overload_c_slow:OnCreated(  )
	local ability = self:GetAbility()
	self.slow = ability:GetSpecialValueFor("slow")
	self.as_slow = ability:GetSpecialValueFor("as_slow")
end

function modifier_storm_spirit_overload_c_slow:GetModifierMoveSpeedBonus_Percentage(  )
	return -self.slow
end

function modifier_storm_spirit_overload_c_slow:GetModifierAttackSpeedBonus_Constant(  )
	return -self.as_slow
end