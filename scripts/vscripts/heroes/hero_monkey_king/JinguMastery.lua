if monkey_king_jingu_mastery_custom == nil then monkey_king_jingu_mastery_custom = class({}) end

LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_passive","heroes/hero_monkey_king/JinguMastery.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_buff","heroes/hero_monkey_king/JinguMastery.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_jingu_mastery_custom_debuff","heroes/hero_monkey_king/JinguMastery.lua",LUA_MODIFIER_MOTION_NONE)

function monkey_king_jingu_mastery_custom:GetIntrinsicModifierName(  )
	return "modifier_monkey_king_jingu_mastery_custom_passive"
end

if modifier_monkey_king_jingu_mastery_custom_passive == nil then modifier_monkey_king_jingu_mastery_custom_passive = class({}) end

function modifier_monkey_king_jingu_mastery_custom_passive:IsPurgable(  )
	return false
end

function modifier_monkey_king_jingu_mastery_custom_passive:IsHidden(  )
	return true
end

function modifier_monkey_king_jingu_mastery_custom_passive:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

require("libraries/IsBoss")

function modifier_monkey_king_jingu_mastery_custom_passive:OnAttackLanded( params )
	local caster = self:GetCaster()
	if params.attacker == caster then 
		local ability = self:GetAbility()
		local debuff = "modifier_monkey_king_jingu_mastery_custom_debuff"
		local buff = "modifier_monkey_king_jingu_mastery_custom_buff"
		local duration = ability:GetSpecialValueFor("duration")
		local counter_duration = ability:GetSpecialValueFor("counter_duration")
		local target = params.target
		local charges = ability:GetSpecialValueFor("charges")
		local ranged_required_hits = ability:GetSpecialValueFor("ranged_required_hits")
		local required_hits = ability:GetSpecialValueFor("required_hits")
		if caster:GetAttackCapability() == 1 then hits = required_hits else hits = ranged_required_hits end
		if target:GetTeam() ~= caster:GetTeam() and (target:IsRealHero() or IsBoss(target)) and not caster:HasModifier(buff) then 
			if not target:HasModifier(debuff) then 
				ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_start.vpcf",PATTACH_WORLDORIGIN, target)
			end
				
			target:AddNewModifier(caster,ability,debuff,{duration = duration})
			local stack = target:GetModifierStackCount(debuff,caster)
			if stack < hits - 1 then
				target:AddNewModifier(caster,ability,debuff,{duration = duration})
				target:SetModifierStackCount(debuff,caster,stack + 1)
			else
				target:RemoveModifierByName(debuff)
				caster:AddNewModifier(caster,ability,buff,{duration = counter_duration})
				caster:SetModifierStackCount(buff,caster, charges)
			end
		end
	end
end

require('libraries/timers')

if modifier_monkey_king_jingu_mastery_custom_buff == nil then modifier_monkey_king_jingu_mastery_custom_buff = class({}) end

function modifier_monkey_king_jingu_mastery_custom_buff:GetTexture(  )
	return self:GetAbility():GetName()
end

function modifier_monkey_king_jingu_mastery_custom_buff:IsPurgable(  )
	return false
end

function modifier_monkey_king_jingu_mastery_custom_buff:OnCreated(  )
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	self.lifesteal = ability:GetSpecialValueFor("lifesteal")
	self.dmg = ability:GetSpecialValueFor("bonus_damage")
	self.id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_overhead.vpcf",PATTACH_OVERHEAD_FOLLOW, caster)
end

function modifier_monkey_king_jingu_mastery_custom_buff:OnRefresh(  )
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	self.lifesteal = ability:GetSpecialValueFor("lifesteal")
	self.dmg = ability:GetSpecialValueFor("bonus_damage")
end

function modifier_monkey_king_jingu_mastery_custom_buff:OnDestroy(  )
	ParticleManager:DestroyParticle(self.id0,false)
end

function modifier_monkey_king_jingu_mastery_custom_buff:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end

function modifier_monkey_king_jingu_mastery_custom_buff:OnAttackLanded( params )
	local caster = self:GetCaster()
	if params.attacker == caster then 
		local lifesteal = params.damage * (self.lifesteal * 0.01)
		local stack = self:GetStackCount()
		caster:HealCustom(lifesteal,caster,true,false)
		caster:SetModifierStackCount("modifier_monkey_king_jingu_mastery_custom_buff", caster, stack - 1)
		if stack <= 1 then 
			ParticleManager:DestroyParticle(self.id0,false)
			caster:RemoveModifierByName(self:GetName())
		end
	end
end

function modifier_monkey_king_jingu_mastery_custom_buff:GetModifierPreAttack_BonusDamage(  )
	return self.dmg
end

if modifier_monkey_king_jingu_mastery_custom_debuff == nil then modifier_monkey_king_jingu_mastery_custom_debuff = class({}) end

function modifier_monkey_king_jingu_mastery_custom_debuff:GetTexture(  )
	return self:GetAbility():GetName()
end

function modifier_monkey_king_jingu_mastery_custom_debuff:IsPurgable(  )
	return false
end

function modifier_monkey_king_jingu_mastery_custom_debuff:IsDebuff(  )
	return true
end

function modifier_monkey_king_jingu_mastery_custom_debuff:OnCreated(  )
	local caster = self:GetCaster()	
	local target = self:GetParent()
	self.id0 = nil
	self.stacks = nil
	Timers:CreateTimer(0.15, function()
		self.stacks = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack.vpcf",PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(self.stacks, 1, Vector(0,self:GetStackCount(),0))
	return
	end)

	self.timer = Timers:CreateTimer(0.3, function()
		local stack = self:GetStackCount()
		ParticleManager:SetParticleControl(self.stacks, 1, Vector(0,self:GetStackCount(),0))
	return 0.1
	end)
end

function modifier_monkey_king_jingu_mastery_custom_debuff:OnDestroy(  )
	ParticleManager:DestroyParticle(self.stacks,false)
	Timers:RemoveTimer(self.timer)
end