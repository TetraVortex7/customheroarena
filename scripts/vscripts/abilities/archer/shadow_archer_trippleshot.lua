function OnSpellStart(keys)
  local caster = keys.caster
  --local target = keys.target
  local ability = keys.ability
  local casterPos = caster:GetAbsOrigin()
  --local targetPos = target:GetAbsOrigin()
  --local difference = targetPos - casterPos
  local modifierName = "modifier_trippleshot_buff"
  local shots = ability:GetLevelSpecialValueFor("shots", ability:GetLevel())
  --local distance = difference:Length2D()
  --local targetID = target:GetPlayerOwnerID()
  local casterID = caster:GetPlayerOwnerID()
  local particleName = "particles/heroes/archer/faster/clinkz_windwalk.vpcf"
  local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, caster)
  EmitSoundOn("Hero_Clinkz.DeathPact.Cast", caster)
  ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
  caster:SetModifierStackCount(modifierName, ability, shots)
end

function SetModifier(keys)
  local caster = keys.caster
  local modifierName = "modifier_trippleshot_buff"
  --local target = keys.target
  local casterPos = caster:GetAbsOrigin()
 --local targetPos = target:GetAbsOrigin()
  local ability = keys.ability
  local shots = ability:GetLevelSpecialValueFor("shots", ability:GetLevel())
  local stack_count = caster:GetModifierStackCount(modifierName, ability)
  if stack_count <= shots and stack_count > -1 then
    if stack_count == 1 then  
      caster:RemoveModifierByName(modifierName)
    else
      caster:SetModifierStackCount(modifierName, ability, stack_count - 1)  
    end
  else
    return nil
  end
end