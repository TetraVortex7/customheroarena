if elder_titan_natural_order_custom == nil then elder_titan_natural_order_custom = class({}) end

require("libraries/IsBoss")
LinkLuaModifier("modifier_elder_titan_natural_order_custom_passive","heroes/hero_elder_titan/elder_titan_natural_order_custom.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elder_titan_natural_order_custom_aura","heroes/hero_elder_titan/elder_titan_natural_order_custom.lua",LUA_MODIFIER_MOTION_NONE)

function elder_titan_natural_order_custom:GetIntrinsicModifierName(  )
	return "modifier_elder_titan_natural_order_custom_passive"
end

if modifier_elder_titan_natural_order_custom_passive == nil then modifier_elder_titan_natural_order_custom_passive = class({}) end

function modifier_elder_titan_natural_order_custom_passive:IsHidden(  )
	return true
end

function modifier_elder_titan_natural_order_custom_passive:IsAura()
	return true
end

function modifier_elder_titan_natural_order_custom_passive:IsPurgable()
    return false
end

function modifier_elder_titan_natural_order_custom_passive:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("range")
end

function modifier_elder_titan_natural_order_custom_passive:GetModifierAura()
    return "modifier_elder_titan_natural_order_custom_aura"
end
   
function modifier_elder_titan_natural_order_custom_passive:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_elder_titan_natural_order_custom_passive:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_elder_titan_natural_order_custom_passive:GetAuraDuration()
    return 0.1
end

if modifier_elder_titan_natural_order_custom_aura == nil then modifier_elder_titan_natural_order_custom_aura = class({}) end

function modifier_elder_titan_natural_order_custom_aura:IsPurgable(  )
	return false
end

function modifier_elder_titan_natural_order_custom_aura:DeclareFunctions(  )
	return { MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_elder_titan_natural_order_custom_aura:GetTexture()
	return "elder_titan_natural_order"
end

function modifier_elder_titan_natural_order_custom_aura:IsDebuff(  )
	return true
end

function modifier_elder_titan_natural_order_custom_aura:OnCreated(  )
	self.ability = self:GetAbility()
end

function modifier_elder_titan_natural_order_custom_aura:GetModifierPhysicalArmorBonus()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if not ability then return nil; end
	local parent_armor = parent:GetPhysicalArmorBaseValue()
	if self:GetAbility() == nil then return end
	local prc = ability:GetSpecialValueFor("disarmor") / 100
	local prc_c = ability:GetSpecialValueFor("b_disarmor") / 100
	local armor = 0
	if IsBoss(parent) then return -parent_armor * prc_c else return -parent_armor * prc end
	return -parent_armor * prc
end

function modifier_elder_titan_natural_order_custom_aura:GetModifierMagicalResistanceBonus()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if not ability then return nil; end
	local parent_armor = parent:GetBaseMagicalResistanceValue()
	local prc = ability:GetSpecialValueFor("disresist") / 100
	local prc_c = ability:GetSpecialValueFor("b_disresist") / 100
	local armor = 0
	if IsBoss(parent) then return -parent_armor * prc_c else return -parent_armor * prc end
	return -parent_armor * prc
end