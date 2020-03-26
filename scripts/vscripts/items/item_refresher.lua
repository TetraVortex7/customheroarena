if not item_refresher then item_refresher = class({}) end

LinkLuaModifier("modifier_item_refresher_passive","items/item_refresher.lua",LUA_MODIFIER_MOTION_NONE)

function item_refresher:GetIntrinsicModifierName ()
    return "modifier_item_refresher_passive"
end

function item_refresher:OnSpellStart ()
	local caster = self:GetCaster()
	caster:EmitSound("DOTA_Item.Refresher.Activate")
	local id0 = ParticleManager:CreateParticle("particles/grand_magus_core.vpcf",PATTACH_ABSORIGIN_FOLLOW, caster)
    for i = 0, caster:GetAbilityCount() - 1 do
        local ability = caster:GetAbilityByIndex(i)
        if ability then
            ability:EndCooldown()
        end
    end
    for i=0, 5, 1 do
        local current_item = self:GetCaster():GetItemInSlot(i)
        if current_item ~= nil then
            if current_item ~= self and current_item:GetSharedCooldownName() ~= "refresher" then current_item:EndCooldown() end 
        end
    end
end

function item_refresher:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

if not modifier_item_refresher_passive then modifier_item_refresher_passive = class({}) end

function modifier_item_refresher_passive:IsHidden(  )
	return true
end

function modifier_item_refresher_passive:IsPurgable(  )
	return false
end

function modifier_item_refresher_passive:DeclareFunctions( )
	return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_PROPERTY_MANA_REGEN_CONSTANT}
end

function modifier_item_refresher_passive:OnCreated(  )
	local ability = self:GetAbility()
	self.hp_regen = ability:GetSpecialValueFor("bonus_health_regen")
	self.mana_regen = ability:GetSpecialValueFor("bonus_mana_regen")
end

function modifier_item_refresher_passive:GetModifierConstantManaRegen(  )
	return self.mana_regen
end

function modifier_item_refresher_passive:GetModifierConstantHealthRegen(  )
	return self.hp_regen
end
