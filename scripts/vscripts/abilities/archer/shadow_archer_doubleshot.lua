function OnAttackLanded(keys)
	local ability = keys.ability
	local modifierName = "modifier_doubleshot"
	local caster = keys.caster
	local Alevel = ability:GetLevel()
	local cooldownTime = ability:GetCooldown(Alevel)
	caster:RemoveModifierByName(modifierName)
	ability:StartCooldown(cooldownTime)
    Timers:CreateTimer(cooldownTime, function()
	  ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
      return nil
    end)
end

function OnUpgrade(keys)
  local caster = keys.caster
  local ability = keys.ability
  local Alevel = ability:GetLevel()
  local modifierName = "modifier_doubleshot"
  if Alevel == 1 then
  	ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
  end
end