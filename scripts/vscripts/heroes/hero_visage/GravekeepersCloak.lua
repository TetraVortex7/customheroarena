if visage_gravekeepers_cloak_custom == nil then visage_gravekeepers_cloak_custom = class({}) end

LinkLuaModifier("modifier_visage_gravekeepers_cloak_custom_passive","heroes/hero_visage/GravekeepersCloak.lua",LUA_MODIFIER_MOTION_NONE)

function visage_gravekeepers_cloak_custom:GetIntrinsicModifierName(  )
	return "modifier_visage_gravekeepers_cloak_custom_passive"
end

if modifier_visage_gravekeepers_cloak_custom_passive == nil then modifier_visage_gravekeepers_cloak_custom_passive = class({}) end

function modifier_visage_gravekeepers_cloak_custom_passive:IsPurgable(  )
	return false
end

function modifier_visage_gravekeepers_cloak_custom_passive:IsHidden(  )
	return false
end

function modifier_visage_gravekeepers_cloak_custom_passive:RemoveOnDeath(  )
	return false
end

function modifier_visage_gravekeepers_cloak_custom_passive:GetTexture(  )
	return "visage_gravekeepers_cloak_custom"
end


function modifier_visage_gravekeepers_cloak_custom_passive:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_TAKEDAMAGE,MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end

require('libraries/timers')

function modifier_visage_gravekeepers_cloak_custom_passive:OnCreated(  )
	local ability = self:GetAbility()
	local modifier = "modifier_visage_gravekeepers_cloak_custom_passive"
	local caster = self:GetCaster()
	self.resist = self:GetAbility():GetSpecialValueFor("damage_reduction")
	caster:SetModifierStackCount(self:GetName(), caster, 1)
	self.timer = Timers:CreateTimer(0.2, function() 
		local delay = 0.2
		local count = caster:GetModifierStackCount(modifier,caster)
		local max_stack = ability:GetSpecialValueFor("max_layers")
		if count >= max_stack then 
			delay = 0.2 
		else 
			delay = ability:GetSpecialValueFor("recovery_time") 
		end
		if count >= max_stack then caster:SetModifierStackCount(modifier, caster, max_stack) end
		if count < max_stack then 
			caster:SetModifierStackCount(self:GetName(), caster, count + 1)
		end
	return delay
	end)
end

function modifier_visage_gravekeepers_cloak_custom_passive:OnTakeDamage( params )
	local caster = self:GetCaster()
	if params.unit == caster then 
		local ability = self:GetAbility()
		local min_damage = ability:GetSpecialValueFor("minimum_damage")
		local dpm = (ability:GetSpecialValueFor("dpm") / 60) * TIME
		if params.damage > min_damage + math.floor(dpm) then 
			local attacker = params.attacker
			local max_range = ability:GetSpecialValueFor("radius")
			local distance = (caster:GetAbsOrigin() - attacker:GetAbsOrigin()):Length2D()
			if math.floor(distance) <= max_range then 
				local modifier = "modifier_visage_gravekeepers_cloak_custom_passive"
				if caster:HasModifier(modifier) then 
					local count = caster:GetModifierStackCount(modifier,caster)
					if count < 1 then 
						caster:SetModifierStackCount(modifier, caster, 0)
					else
						caster:SetModifierStackCount(modifier, caster, count - 1)
					end
				end
			end
		end
	end
end

function modifier_visage_gravekeepers_cloak_custom_passive:GetModifierIncomingDamage_Percentage(  )
	return math.floor(self.resist * self:GetStackCount())
end