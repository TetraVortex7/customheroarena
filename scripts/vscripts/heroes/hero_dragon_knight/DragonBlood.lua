if dragon_knight_dragon_blood_custom == nil then dragon_knight_dragon_blood_custom = class({}) end

LinkLuaModifier("modifier_dragon_knight_dragon_blood_custom_passive","heroes/hero_dragon_knight/DragonBlood.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dragon_knight_dragon_blood_custom_act","heroes/hero_dragon_knight/DragonBlood.lua",LUA_MODIFIER_MOTION_NONE)

function dragon_knight_dragon_blood_custom:OnSpellStart(  )
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_dragon_knight_dragon_blood_custom_act",{duration = self:GetSpecialValueFor("duration")})
end

function dragon_knight_dragon_blood_custom:GetIntrinsicModifierName(  )
	return "modifier_dragon_knight_dragon_blood_custom_passive"
end

if modifier_dragon_knight_dragon_blood_custom_passive == nil then modifier_dragon_knight_dragon_blood_custom_passive = class({}) end

function modifier_dragon_knight_dragon_blood_custom_passive:IsHidden(  )
	return true
end

function modifier_dragon_knight_dragon_blood_custom_passive:IsPurgable(  )
	return false
end

function modifier_dragon_knight_dragon_blood_custom_passive:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_dragon_knight_dragon_blood_custom_passive:OnCreated(  )
	local ability = self:GetAbility()
	self.regen = ability:GetSpecialValueFor("health_regen")
	self.armor = ability:GetSpecialValueFor("armor")
end

function modifier_dragon_knight_dragon_blood_custom_passive:OnRefresh(  )
	local ability = self:GetAbility()
	self.regen = ability:GetSpecialValueFor("health_regen")
	self.armor = ability:GetSpecialValueFor("armor")
end

function modifier_dragon_knight_dragon_blood_custom_passive:GetModifierConstantHealthRegen(  )
	return self.regen
end

function modifier_dragon_knight_dragon_blood_custom_passive:GetModifierPhysicalArmorBonus(  )
	return self.armor
end

if modifier_dragon_knight_dragon_blood_custom_act == nil then modifier_dragon_knight_dragon_blood_custom_act = class({}) end

function modifier_dragon_knight_dragon_blood_custom_act:IsPurgable(  )
	return false
end

function modifier_dragon_knight_dragon_blood_custom_act:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}
end

function modifier_dragon_knight_dragon_blood_custom_act:GetTexture(  )
	return self:GetAbility():GetName()
end

function modifier_dragon_knight_dragon_blood_custom_act:OnCreated(  )
	local ability = self:GetAbility()
	self.regen = ability:GetSpecialValueFor("additive_regen_active")
end

function modifier_dragon_knight_dragon_blood_custom_act:OnRefresh(  )
	local ability = self:GetAbility()
	self.regen = ability:GetSpecialValueFor("additive_regen_active")
end

function modifier_dragon_knight_dragon_blood_custom_act:GetModifierConstantHealthRegen(  )
	return self.regen
end