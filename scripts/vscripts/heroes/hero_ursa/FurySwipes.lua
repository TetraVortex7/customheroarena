if ursa_fury_swipes_custom == nil then ursa_fury_swipes_custom = class({}) end

LinkLuaModifier("modifier_ursa_fury_swipes_custom_passive","heroes/hero_ursa/FurySwipes.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ursa_fury_swipes_custom_damage","heroes/hero_ursa/FurySwipes.lua",LUA_MODIFIER_MOTION_NONE)

function ursa_fury_swipes_custom:GetIntrinsicModifierName(  )
	return "modifier_ursa_fury_swipes_custom_passive"
end

if modifier_ursa_fury_swipes_custom_passive == nil then modifier_ursa_fury_swipes_custom_passive = class({}) end

function modifier_ursa_fury_swipes_custom_passive:IsPurgable(  )
	return false
end

function modifier_ursa_fury_swipes_custom_passive:IsHidden(  )
	return true
end

function modifier_ursa_fury_swipes_custom_passive:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_ATTACK_LANDED; MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL}
end

function modifier_ursa_fury_swipes_custom_passive:OnCreated(  )
	local ability = self:GetAbility()
	self.chance = ability:GetSpecialValueFor("chance")
	self.boss_chance = ability:GetSpecialValueFor("chance_c")
	self.duration = ability:GetSpecialValueFor("duration")
	self.damage = ability:GetSpecialValueFor("bonus_damage")
end

function modifier_ursa_fury_swipes_custom_passive:OnRefresh(  )
	local ability = self:GetAbility()
	self.chance = ability:GetSpecialValueFor("chance")
	self.boss_chance = ability:GetSpecialValueFor("chance_c")
	self.duration = ability:GetSpecialValueFor("duration")
	self.damage = ability:GetSpecialValueFor("bonus_damage")
end

function modifier_ursa_fury_swipes_custom_passive:OnAttackLanded( params )
	local caster = self:GetCaster()
	if params.attacker == caster then 
		self.active = false
		local chance
		local target = params.target
		local ability = self:GetAbility()
		if IsBoss(target) then chance = self.boss_chance else chance = self.chance end
		if RollPercentage(chance) and target:IsAlive() and ability:IsCooldownReady() then 
			target:AddNewModifier(caster,ability,"modifier_ursa_fury_swipes_custom_damage",{duration = self.duration})
			local stacks = target:GetModifierStackCount("modifier_ursa_fury_swipes_custom_damage",caster)
			target:SetModifierStackCount("modifier_ursa_fury_swipes_custom_damage",caster,stacks + 1)
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		end
		if target:HasModifier("modifier_ursa_fury_swipes_custom_damage") then 
			local stacks = target:GetModifierStackCount("modifier_ursa_fury_swipes_custom_damage",caster)
			self.active = true
			self.event_damage = stacks * self.damage
			print("Pure damage = "..self.damage)
			print("Stacks = "..stacks)
			print("Damage = "..self.event_damage)
		end
	end
end

function modifier_ursa_fury_swipes_custom_passive:GetModifierProcAttack_BonusDamage_Physical(  )
	if self.active then return self.event_damage end
	return 0
end

if modifier_ursa_fury_swipes_custom_damage == nil then modifier_ursa_fury_swipes_custom_damage = class({}) end

function modifier_ursa_fury_swipes_custom_damage:GetTexture(  )
	return self:GetAbility():GetName()
end

function modifier_ursa_fury_swipes_custom_damage:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_ursa_fury_swipes_custom_damage:OnCreated(  )
	self.id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_fury_swipes.vpcf",PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self.id1 = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf",PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage") * self:GetStackCount()
end

function modifier_ursa_fury_swipes_custom_damage:OnRefresh(  )
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage") * self:GetStackCount()
end

function modifier_ursa_fury_swipes_custom_damage:OnDestroy(  )
	ParticleManager:DestroyParticle(self.id1, false)
end

function modifier_ursa_fury_swipes_custom_damage:OnTooltip(  )
	return self.damage
end