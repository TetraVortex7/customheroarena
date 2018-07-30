
function SupersonicStart(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local casterPos = caster:GetAbsOrigin()
	local targetPos = target:GetAbsOrigin()
	local difference = targetPos - casterPos
	local modifierName = "modifier_supersonic_casterbuff"
	local modifierName2 = "modifier_supersonic_targetbuff"
	local distance = difference:Length2D()
	local targetID = target:GetPlayerOwnerID()
	local casterID = caster:GetPlayerOwnerID()
	  caster:Stop()
	  target:Stop()
	  ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
	  ability:ApplyDataDrivenModifier(caster, target, modifierName2, {})
	  caster:SetModifierStackCount(modifierName, ability, 4)
	  caster:MoveToTargetToAttack(target)
	  Timers:CreateTimer(0.03, function()
        if caster:IsStunned() then
          caster:RemoveModifierByName(modifierName)
  	      target:RemoveModifierByName(modifierName2)
	      return nil
	    else return 0.03 end
	  end)
end

function SetModifier(keys)
  local caster = keys.caster
  local target = keys.target
  local casterPos = caster:GetAbsOrigin()
  local targetPos = target:GetAbsOrigin()
  local modifierName = "modifier_supersonic_casterbuff"
  local modifierName2 = "modifier_supersonic_targetbuff"
  local particleName = "particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_d_gold.vpcf"
  local ability = keys.ability
  local stack_count = caster:GetModifierStackCount(modifierName, ability)
  local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
  if stack_count <= 4 and stack_count > -1 then
  	if stack_count == 1 then
  	  caster:RemoveModifierByName(modifierName)
  	  target:RemoveModifierByName(modifierName2)
  	else	
  	  caster:SetModifierStackCount(modifierName, ability, stack_count - 1)
    end
  else
  	return nil
  end
end

function OnOwnerDied(keys)
	local caster = keys.caster
	local units_table = keys.target_entities
	local modifierName = "modifier_supersonic_casterbuff"
	local modifierName2 = "modifier_supersonic_targetbuff"
	for k, v in pairs(units_table) do
		local unit = v
		local unitName = unit:GetUnitName()
		caster:RemoveModifierByName(modifierName)
  	    unit:RemoveModifierByName(modifierName2)
	end
end

function CreateParticle(keys)
  local caster = keys.caster
  local target = keys.target
  local particleName = "particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_basher_lightning_impact_gold.vpcf"
  ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
end