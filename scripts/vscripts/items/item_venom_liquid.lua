if item_venom_liquid == nil then
	item_venom_liquid = class({})
end

LinkLuaModifier("modifier_venom_liquid_passive","items/item_venom_liquid.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_venom_liquid_venome","items/item_venom_liquid.lua",LUA_MODIFIER_MOTION_NONE)

function item_venom_liquid:GetIntrinsicModifierName(  )
	return "modifier_venom_liquid_passive"
end

------------------------

if modifier_venom_liquid_passive == nil then
	modifier_venom_liquid_passive = class({})
end

function modifier_venom_liquid_passive:IsHidden(  )
	return true
end

function modifier_venom_liquid_passive:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_ATTACK_LANDED} 
end

function modifier_venom_liquid_passive:OnAttackLanded( params )
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local target = params.target
		local cap = self:GetAbility():GetSpecialValueFor("cap")
		if params.attacker == caster then
			if target:HasModifier("modifier_venom_liquid_venome") then
				local stacks = target:GetModifierStackCount("modifier_venom_liquid_venome",caster)
				if stacks < cap then
					target:SetModifierStackCount("modifier_venom_liquid_venome",caster,target:GetModifierStackCount("modifier_venom_liquid_venome",caster) + 1)
				end
			end
			target:AddNewModifier(caster,ability,"modifier_venom_liquid_venome",{duration = ability:GetSpecialValueFor("duration")})
		end
	end
end

-------------------------

if modifier_venom_liquid_venome == nil then
	modifier_venom_liquid_venome = class({})
end

function modifier_venom_liquid_venome:IsDebuff(  )
	return true
end

function modifier_venom_liquid_venome:GetTexture(  )
	return "item_venom_liquid"
end

function modifier_venom_liquid_venome:DeclareFunctions(  )
	local hFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
	return hFuncs
end

require('libraries/StatsFinder')

function modifier_venom_liquid_venome:OnCreated(  )
	local caster = self:GetCaster()
	self.target = self:GetParent()
	local ability = self:GetAbility()
	self.slow = ability:GetSpecialValueFor("slow")
	local dps = ability:GetSpecialValueFor("dps")
	local hpd = ability:GetSpecialValueFor("hpd")
	if IsServer() then
		self.timer = Timers:CreateTimer(0,function() 
			local stacks = self:GetStackCount()
			--local int = (caster:GetIntellect() / 12) / 100
			local hp = self.target:GetMaxHealth() * 0.01 * hpd
			damage = hp + dps * stacks
			damage = damage + damage --*int
			damage = math.floor(damage)
			ApplyDamage({victim = self.target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE})
			return ability:GetSpecialValueFor("rate") 
		end)
	end
end

function modifier_venom_liquid_venome:OnDestroy(  )
	Timers:RemoveTimer(self.timer)
end

function modifier_venom_liquid_venome:GetModifierMoveSpeedBonus_Percentage(  )
	return -self.slow
end