if nevermore_necromastery_custom == nil then nevermore_necromastery_custom = class({}) end

LinkLuaModifier("modifier_nevermore_necromastery_custom","heroes/hero_nevermore/necromastery.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nevermore_necromastery_custom_active","heroes/hero_nevermore/necromastery.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nevermore_necromastery_custom_active_hidden","heroes/hero_nevermore/necromastery.lua",LUA_MODIFIER_MOTION_NONE)

function nevermore_necromastery_custom:GetIntrinsicModifierName(  )
	return "modifier_nevermore_necromastery_custom"
end

require('libraries/timers')

function nevermore_necromastery_custom:OnToggle(  )
	local caster = self:GetCaster()
	local timer
	if self:GetToggleState() == true then 
		local min_souls = self:GetSpecialValueFor("spt")
		local stacks = caster:GetModifierStackCount("modifier_nevermore_necromastery_custom",caster)
		local rate = self:GetSpecialValueFor("tick")
		local duration = self:GetSpecialValueFor("duration")
		if stacks > min_souls then
			self:EndCooldown()
			timer = Timers:CreateTimer(function()

				if caster:HasScepter() then
					rate = self:GetSpecialValueFor("tick_scepter")
				else
					rate = self:GetSpecialValueFor("tick")
				end
				
				if self:GetCooldownTimeRemaining() > 0 then return nil; end

				stacks = caster:GetModifierStackCount("modifier_nevermore_necromastery_custom",caster)
				local stacks_c = caster:GetModifierStackCount("modifier_nevermore_necromastery_custom_active",caster)

				if stacks > min_souls then
					caster:SetModifierStackCount("modifier_nevermore_necromastery_custom",caster,stacks - min_souls)
					caster:AddNewModifier(caster,self,"modifier_nevermore_necromastery_custom_active",{duration = duration})
					caster:AddNewModifier(caster,self,"modifier_nevermore_necromastery_custom_active_hidden",{duration = duration})
					caster:SetModifierStackCount("modifier_nevermore_necromastery_custom_active",caster,stacks_c + 1)
					return rate
				elseif self:GetToggleState() == true then 
					self:ToggleAbility() 
					return nil
				end
				Dotimer(duration,caster)
			return nil
			end)
		else
			if timer then Timers:RemoveTimer(timer) end
			if self:GetToggleState() == true then self:ToggleAbility() return nil end
		end
	else
		Timers:CreateTimer(0.1,function()
			self:StartCooldown(self:GetCooldown(self:GetLevel())) 
			if timer then Timers:RemoveTimer(timer) end
		end)
	end
end

function nevermore_necromastery_custom:ResetToggleOnRespawn(  )
	return true
end

if modifier_nevermore_necromastery_custom == nil then modifier_nevermore_necromastery_custom = class({}) end

function modifier_nevermore_necromastery_custom:GetTexture(  )
	return "nevermore_necromastery_custom"
end

function modifier_nevermore_necromastery_custom:IsPurgable(  )
	return false
end

function modifier_nevermore_necromastery_custom:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_DEATH,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end

function modifier_nevermore_necromastery_custom:RemoveOnDeath(  )
	return false
end

function modifier_nevermore_necromastery_custom:GetModifierPreAttack_BonusDamage(  )
	return self:GetAbility():GetSpecialValueFor("soul_damage") * self:GetStackCount()
end

function modifier_nevermore_necromastery_custom:OnDeath( params )
	local caster = self:GetCaster()
	local soul_loss = self.soul_loss
	local max_souls = self.max_souls
	local stacks = self:GetStackCount()
	local ability = self:GetAbility()
	if params.attacker == caster then
		local target = params.unit
		if caster:HasScepter() then 
			max_souls = ability:GetSpecialValueFor("max_souls_scepter")
		else 
			max_souls = ability:GetSpecialValueFor("max_souls")
		end
		if stacks == 0 then 
			stacks = 1 
		end
		if stacks < max_souls then
			if params.unit:IsRealHero() then 
			local chance_c = ability:GetSpecialValueFor("hero_chance")
				if RollPercentage(chance_c) then
					local hero_souls = ability:GetSpecialValueFor("hero_souls")
					local id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf",PATTACH_ABSORIGIN_FOLLOW, target)
					ParticleManager:SetParticleControlEnt(id0, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
					caster:SetStackCount(stacks + self.hero_souls)
				end
			elseif params.unit:IsCreep() or params.unit:IsCreature() then
			local chance = ability:GetSpecialValueFor("chance")
				if RollPercentage(chance) then
					local id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf",PATTACH_ABSORIGIN_FOLLOW, target)
					ParticleManager:SetParticleControlEnt(id0, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
					self:SetStackCount(stacks + 1)
				end
			end
		end
	end

	if caster:HasScepter() then 
		soul_loss = ability:GetSpecialValueFor("soul_loss_scepter") 
	else 
		soul_loss = ability:GetSpecialValueFor("soul_loss") 
	end


	if params.unit == caster then
		local lost_souls = math.floor(stacks * soul_loss * 0.01)
		self:SetStackCount(lost_souls)
	end
end

if modifier_nevermore_necromastery_custom_active == nil then modifier_nevermore_necromastery_custom_active = class({}) end

function modifier_nevermore_necromastery_custom_active:GetTexture(  )
	return "nevermore_necromastery_custom_active"
end

function modifier_nevermore_necromastery_custom_active:IsPurgable(  )
	return false
end

if modifier_nevermore_necromastery_custom_active_hidden == nil then modifier_nevermore_necromastery_custom_active_hidden = class({}) end

function modifier_nevermore_necromastery_custom_active_hidden:IsPurgable(  )
	return false
end

function modifier_nevermore_necromastery_custom_active_hidden:IsHidden(  )
	return true
end

function modifier_nevermore_necromastery_custom_active_hidden:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end

function modifier_nevermore_necromastery_custom_active_hidden:OnCreated(  )
	self.damage = self:GetAbility():GetSpecialValueFor("dpt")
end

function modifier_nevermore_necromastery_custom_active_hidden:GetModifierPreAttack_BonusDamage(  )
	return self.damage
end

function modifier_nevermore_necromastery_custom_active_hidden:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_nevermore_necromastery_custom_active_hidden:OnDestroy()
	local caster = self:GetParent()
	if caster and IsServer() then
		local stacks = caster:GetModifierStackCount("modifier_nevermore_necromastery_custom_active",caster)
		if stacks >= 1 then
			caster:SetModifierStackCount("modifier_nevermore_necromastery_custom_active",caster,stacks-1)
		else 
			caster:RemoveModifierByName("modifier_nevermore_necromastery_custom_active")
		end
	end
end