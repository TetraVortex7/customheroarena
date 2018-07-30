if modifier_creep_grow == nil then modifier_creep_grow = class({}) end

function modifier_creep_grow:IsPurgable(  )
	return false
end

function modifier_creep_grow:GetTexture(  )
	return "modifier_creep_grow"
end

function modifier_creep_grow:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_HEALTH_BONUS}
end
require('libraries/IsBoss')
require('libraries/timers')
function modifier_creep_grow:OnCreated(  )
	local parent = self:GetParent()
	if IsServer() then
		if IsBoss(parent) then 
			CustomNetTables:SetTableValue("item_nettable","creep_grow",{hp = 0, armor = 0.75, dmg = 6.75})
		else
			CustomNetTables:SetTableValue("item_nettable","creep_grow",{hp = 34, armor = 0.4, dmg = 2})
		end
	end
end

function modifier_creep_grow:GetModifierHealthBonus(  )
	local nettable = CustomNetTables:GetTableValue("item_nettable","creep_grow")
	return nettable.hp * self:GetStackCount()
end

function modifier_creep_grow:GetModifierPreAttack_BonusDamage(  )
	local nettable = CustomNetTables:GetTableValue("item_nettable","creep_grow")
	return nettable.dmg * self:GetStackCount()
end

function modifier_creep_grow:GetModifierPhysicalArmorBonus(  )
	local nettable = CustomNetTables:GetTableValue("item_nettable","creep_grow")
	return nettable.armor * self:GetStackCount()
end