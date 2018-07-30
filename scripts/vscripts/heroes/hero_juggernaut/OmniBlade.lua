if juggernaut_omniblade == nil then juggernaut_omniblade = class({}) end

LinkLuaModifier("modifier_juggernaut_omniblade_passive","heroes/hero_juggernaut/OmniBlade.lua",LUA_MODIFIER_MOTION_NONE)

function juggernaut_omniblade:OnToggle(  )
	local toggle = self:GetToggleState()
	local caster = self:GetCaster()

	if toggle == true then 
		caster:AddNewModifier(caster,self,"modifier_juggernaut_omniblade_passive",{})
	end

	if toggle == false then 
		caster:RemoveModifierByName("modifier_juggernaut_omniblade_passive")
	end
end

if modifier_juggernaut_omniblade_passive == nil then modifier_juggernaut_omniblade_passive = class({}) end

function modifier_juggernaut_omniblade_passive:IsHidden(  )
	return true
end

function modifier_juggernaut_omniblade_passive:IsPurgable(  )
	return false
end

function modifier_juggernaut_omniblade_passive:DeclareFunctions(  )
	return {}
end

function modifier_juggernaut_omniblade_passive:OnAttackLanded( params )
	local caster = self:GetCaster()
	if params.attacker == caster then 
		local capab = caster:GetAttackCapability()
		if capab == 1 then 
			local ability = self:GetAbility()
			local aoe = ability:GetSpecialValueFor("aoe")
			local health_reduce = ability:GetSpecialValueFor("hpa")
			local debuff_d = ability:GetSpecialValueFor("duration")
			local speed_d = ability:GetSpecialValueFor("slow_duration")
			
		end
	end
end