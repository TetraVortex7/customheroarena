if creeps_doom_ability_shift == nil then creeps_doom_ability_shift = class({}) end

LinkLuaModifier("modifier_creeps_doom_ability_shift_passive","creeps_abilities/creeps_doom_ability_shift.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_doom_ability_shift_debuff","creeps_abilities/creeps_doom_ability_shift.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_doom_ability_shift_buff","creeps_abilities/creeps_doom_ability_shift.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_true_strike","libraries/modifiers/modifier_true_strike.lua",LUA_MODIFIER_MOTION_NONE)

function creeps_doom_ability_shift:GetIntrinsicModifierName(  )
	return "modifier_creeps_doom_ability_shift_passive"
end

if modifier_creeps_doom_ability_shift_passive == nil then modifier_creeps_doom_ability_shift_passive = class({}) end

function modifier_creeps_doom_ability_shift_passive:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_ATTACK_START,MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_creeps_doom_ability_shift_passive:IsHidden(  )
	return true
end

function modifier_creeps_doom_ability_shift_passive:OnCreated(  )
	self:GetCaster():SetHullRadius(90)
end

function modifier_creeps_doom_ability_shift_passive:IsPurgable(  )
	return false
end

function modifier_creeps_doom_ability_shift_passive:OnAttackStart(  )
	if RollPercentage(33) then
		self:GetCaster():EmitSound("Hero_DoomBringer.Attack")
		self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_true_strike",{})
	end
end

function modifier_creeps_doom_ability_shift_passive:OnAttackLanded( params )
	local caster = self:GetCaster()
	local target = params.target
	local ability = self:GetAbility()
	local damage = caster:GetAverageTrueAttackDamage(caster)
	local duration = ability:GetSpecialValueFor("duration")
	local prc = ability:GetSpecialValueFor("prc")
	local prc_c = ability:GetSpecialValueFor("prc_c")
	local stacks_c = 1
	local stacks = 1
	if params.attacker == caster then
		caster:RemoveModifierByName("modifier_true_strike")
		if target:IsHero() then
			local attribute_type = target:GetPrimaryAttribute()
			local attribute
			local base_attribute

			if attribute_type == 0 then 
				base_attribute = target:GetBaseStrength()
				attribute = target:GetStrength() 
			elseif attribute_type == 1 then 
				base_attribute = target:GetBaseAgility()
				attribute = target:GetAgility() 
			else 
				base_attribute = target:GetBaseIntellect()
				attribute = target:GetIntellect() 
			end

			caster:AddNewModifier(caster,ability,"modifier_creeps_doom_ability_shift_buff",{duration = duration})
			target:AddNewModifier(caster,ability,"modifier_creeps_doom_ability_shift_debuff",{duration = duration})
			if target:HasModifier("modifier_creeps_doom_ability_shift_debuff") then print("Has Modifier") end

					stacks_c = target:GetModifierStackCount("modifier_creeps_doom_ability_shift_debuff",caster)
					stacks = caster:GetModifierStackCount("modifier_creeps_doom_ability_shift_buff",caster)
					target:SetModifierStackCount("modifier_creeps_doom_ability_shift_debuff",caster,stacks_c + 1)
					caster:SetModifierStackCount("modifier_creeps_doom_ability_shift_buff",caster,stacks + 1)
					Timers:CreateTimer({
						endTime = duration, 
						callback = function()
						stacks_c = target:GetModifierStackCount("modifier_creeps_doom_ability_shift_debuff",caster) 
						stacks = caster:GetModifierStackCount("modifier_creeps_doom_ability_shift_buff",caster)
						target:SetModifierStackCount("modifier_creeps_doom_ability_shift_debuff",caster,stacks_c - 1) 
						caster:SetModifierStackCount("modifier_creeps_doom_ability_shift_buff",caster,stacks_c - 1)
						end})
		end

		damage = damage * ((prc + prc_c * (stacks_c +1)) * 0.01)
		local numbers = string.len(tostring(math.floor(damage))) + 1
		local visual = damage

			local id0 = ParticleManager:CreateParticle("particles/msg_damage.vpcf",PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(id0, 1, Vector(8,visual,4))
			ParticleManager:SetParticleControl(id0, 2, Vector(3,numbers,0))
			ParticleManager:SetParticleControl(id0, 3, Vector(0,60,90))
			target:EmitSound("n_creep_SatyrSoulstealer.ManaBurn")
			local id1 = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start_magic.vpcf",
				PATTACH_ABSORIGIN_FOLLOW, target)
			
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL,ability = self})
	end
end

if modifier_creeps_doom_ability_shift_debuff == nil then modifier_creeps_doom_ability_shift_debuff = class({}) end

function modifier_creeps_doom_ability_shift_debuff:GetTexture(  )
	return "creeps_doom_ability_shift"
end

function modifier_creeps_doom_ability_shift_debuff:IsDebuff(  )
	return true
end

function modifier_creeps_doom_ability_shift_debuff:IsPurgable(  )
	return false
end

function modifier_creeps_doom_ability_shift_debuff:OnCreated(  )
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.stats_count = self.ability:GetSpecialValueFor("stats")
	self.id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast_slow.vpcf",PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_creeps_doom_ability_shift_debuff:OnDestroy(  )
	ParticleManager:DestroyParticle(self.id0,false)
end

function modifier_creeps_doom_ability_shift_debuff:GetModifierBonusStats_Strength(  )
	local ability = self.ability
	local parent = self.parent
	local stats_count = self.stats_count
	local stats_debuff = stats_count + stats_count * parent:GetLevel() * 0.01

	if self:GetParent():GetPrimaryAttribute() == 0 then 
		return -stats_debuff * self:GetStackCount()
	end
	return nil
end

function modifier_creeps_doom_ability_shift_debuff:GetModifierBonusStats_Agility(  )
	local ability = self.ability
	local parent = self.parent
	local stats_count = self.stats_count
	local stats_debuff = stats_count + stats_count * parent:GetLevel() * 0.01

	if self:GetParent():GetPrimaryAttribute() == 1 then 
		return -stats_debuff * self:GetStackCount()
	end
	return nil
end

function modifier_creeps_doom_ability_shift_debuff:GetModifierBonusStats_Intellect(  )
	local ability = self.ability
	local parent = self.parent
	local stats_count = self.stats_count
	local stats_debuff = stats_count + stats_count * parent:GetLevel() * 0.01
	local attribute_type = self.attribute_type

	if self:GetParent():GetPrimaryAttribute() == 2 then 
		return -stats_debuff * self:GetStackCount()
	end
	return nil
end

function modifier_creeps_doom_ability_shift_debuff:OnTooltip(  )
	local ability = self.ability
	local parent = self.parent
	local stats_count = self.stats_count
	local stats_debuff = stats_count + stats_count * parent:GetLevel() * 0.01
	
	return stats_debuff * self:GetStackCount()
end

function modifier_creeps_doom_ability_shift_debuff:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_TOOLTIP,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_STATS_AGILITY_BONUS,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
end

if modifier_creeps_doom_ability_shift_buff == nil then modifier_creeps_doom_ability_shift_buff = class({}) end

function modifier_creeps_doom_ability_shift_buff:GetTexture(  )
	return "creeps_doom_ability_shift"
end

function modifier_creeps_doom_ability_shift_buff:IsPurgable(  )
	return false
end

function modifier_creeps_doom_ability_shift_buff:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_creeps_doom_ability_shift_buff:OnCreated(  )
	self.id0 = ParticleManager:CreateParticle("particles/creep_rage_bonus.vpcf",PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.id0, 7, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(self.id0, 6, Vector(1,0,0))
	self.prc_c = self:GetAbility():GetSpecialValueFor("prc_c")
	self.armor = self:GetAbility():GetSpecialValueFor("armor")
end

function modifier_creeps_doom_ability_shift_buff:OnTooltip(  )
	return self.prc_c * self:GetStackCount()
end

function modifier_creeps_doom_ability_shift_buff:GetModifierPhysicalArmorBonus(  )
	return self.armor * self:GetStackCount()
end

function modifier_creeps_doom_ability_shift_buff:OnDestroy(  )
	ParticleManager:DestroyParticle(self.id0,false)
end