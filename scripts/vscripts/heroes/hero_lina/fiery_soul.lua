--[[Handling the stacking of Linas Fiery Soul ability
	Author: Pizzalol
	Date: 30.12.2014.]]
function FierySoul( keys )
	if keys.ability and keys.event_ability:GetCooldown(keys.event_ability:GetLevel()-1) > 3 and not keys.event_ability:IsItem() then
		local caster = keys.caster
		local ability = keys.ability
		local level = ability:GetLevel() - 1
		local maxStack = ability:GetLevelSpecialValueFor("fiery_soul_max_stacks", level)
		local modifierBuffName = "modifier_fiery_soul_buff_datadriven"
		local modifierName
		local count = 1
		local chance = ability:GetLevelSpecialValueFor("chance", level)
		
		-- Always remove the stack modifier
		if caster:HasModifier("modifier_fiery_soul_buff_datadriven") and RollPercentage(chance) then 
			local modifier = caster:FindModifierByName(modifierBuffName)
			count = caster:GetModifierStackCount(modifierBuffName, caster)
			if count < maxStack then count = count + 1 end
			caster:SetModifierStackCount(modifierBuffName, ability, count)
			modifier:ForceRefresh()
		else
			ability:ApplyDataDrivenModifier(caster, caster, modifierBuffName, {})
			local modifier = caster:FindModifierByName(modifierBuffName)
			--modifier:ForceRefresh()
		end
	end
end