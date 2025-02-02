if item_aether_lens_3 == nil then item_aether_lens_3 = class({}) end

LinkLuaModifier("modifier_lens_3_passive","items/item_lens_3.lua",LUA_MODIFIER_MOTION_NONE)

function item_aether_lens_3:GetIntrinsicModifierName(  ) return "modifier_lens_3_passive" end

if modifier_lens_3_passive == nil then modifier_lens_3_passive = class({}) end

function modifier_lens_3_passive:IsPurgable(  )
	return false
end

function modifier_lens_3_passive:GetAttributes(  )
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_lens_3_passive:IsHidden(  )
	return true
end

function modifier_lens_3_passive:OnCreated(  )
	local ability = self:GetAbility()
	self.mana = ability:GetSpecialValueFor("mana")
	self.int = ability:GetSpecialValueFor("int")
	self.hp_reg = ability:GetSpecialValueFor("hp_reg")
	self.ampl = ability:GetSpecialValueFor("spell_amp")
	self.range = ability:GetSpecialValueFor("cast_range_bonus")
end

function modifier_lens_3_passive:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_MANA_BONUS,MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE ,MODIFIER_PROPERTY_CAST_RANGE_BONUS}
end

function modifier_lens_3_passive:GetModifierManaBonus(  )
	return self.mana
end

function modifier_lens_3_passive:GetModifierBonusStats_Intellect(  )
	return self.int
end

function modifier_lens_3_passive:GetModifierConstantHealthRegen(  )
	return self.hp_reg
end

function modifier_lens_3_passive:GetModifierSpellAmplify_Percentage(  )
	return self.ampl
end

function modifier_lens_3_passive:GetModifierCastRangeBonus(  )
	return self.range
end