function punch_str_start(keys)
  local caster = keys.caster
  local ability = keys.ability
  local target = keys.target
  local damage = caster:GetStrength() * keys.coff + keys.bonusdamage
  local damage_table = {
          victim = target,
          attacker = caster,
          damage = damage,
          damage_type = DAMAGE_TYPE_PHYSICAL
        }
  ApplyDamage(damage_table)
  target:EmitSound("Hero_Nightstalker.Void")
  local particle = ParticleManager:CreateParticle("particles/heroes/alastar/nyx_assassin_mana_burn_flash_red.vpcf", PATTACH_POINT, target)
  ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() + Vector(0, 0, 0))
end

function punch_agi_start(keys)
  local caster = keys.caster
  local ability = keys.ability
  local target = keys.target
  local damage = caster:GetAgility() * keys.coff + keys.bonusdamage
  local damage_table = {
          victim = target,
          attacker = caster,
          damage = damage,
          damage_type = DAMAGE_TYPE_MAGICAL
        }
  ApplyDamage(damage_table)
  target:EmitSound("Hero_Nightstalker.Void")
  local particle = ParticleManager:CreateParticle("particles/heroes/alastar/nyx_assassin_mana_burn_flash_green.vpcf", PATTACH_POINT, target)
  ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() + Vector(0, 0, 0))
  ability:ApplyDataDrivenModifier(caster, caster, "modifier_alastar_punch_agi_buff", {})
end

function punch_int_start(keys)
  local caster = keys.caster
  local ability = keys.ability
  local target = keys.target
  local damage = caster:GetIntellect() * keys.coff + keys.bonusdamage
  local damage_table = {
          victim = target,
          attacker = caster,
          damage = damage,
          damage_type = DAMAGE_TYPE_MAGICAL
        }
  ApplyDamage(damage_table)
  target:EmitSound("Hero_Nightstalker.Void")
  local particle = ParticleManager:CreateParticle("particles/heroes/alastar/nyx_assassin_mana_burn_flash_blue.vpcf", PATTACH_POINT, target)
  ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() + Vector(0, 0, 0))
end


function change_start(keys)
  local caster = keys.caster
  local ability = keys.ability
  local atribute = caster:GetPrimaryAttribute()
  if atribute == 0 then 
  	caster:SetPrimaryAttribute(1)
  	caster:RemoveModifierByName("modifier_change_str")
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_change_agi", {})
  end
  if atribute == 1 then 
  	caster:SetPrimaryAttribute(2)
  	caster:RemoveModifierByName("modifier_change_agi")
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_change_int", {})
  end
  if atribute == 2 then 
  	caster:SetPrimaryAttribute(0)
  	caster:RemoveModifierByName("modifier_change_int")
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_change_str", {})
  end
end

function change_learn(keys)
  local caster = keys.caster
  local ability = keys.ability
  local atribute = caster:GetPrimaryAttribute()
  if ability:GetLevel() == 1 then
    if atribute == 0 then
  	  ability:ApplyDataDrivenModifier(caster, caster, "modifier_change_str", {})
    end
    if atribute == 1 then 
    	ability:ApplyDataDrivenModifier(caster, caster, "modifier_change_agi", {})
    end
    if atribute == 2 then 
  	  ability:ApplyDataDrivenModifier(caster, caster, "modifier_change_int", {})
    end
  elseif ability:GetLevel() > 1 then
  	if atribute == 0 then
  	  caster:RemoveModifierByName("modifier_change_str")
  	  ability:ApplyDataDrivenModifier(caster, caster, "modifier_change_str", {})
    end
    if atribute == 1 then 
    	caster:RemoveModifierByName("modifier_change_agi")
    	ability:ApplyDataDrivenModifier(caster, caster, "modifier_change_agi", {})
    end
    if atribute == 2 then
      caster:RemoveModifierByName("modifier_change_int")
  	  ability:ApplyDataDrivenModifier(caster, caster, "modifier_change_int", {})
    end
  end
end

function change_spawn(keys)
  local caster = keys.caster
  local ability = keys.ability
  local atribute = caster:GetPrimaryAttribute()
  if atribute == 0 then 
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_change_str", {})
  end
  if atribute == 1 then 
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_change_agi", {})
  end
  if atribute == 2 then 
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_change_int", {})
  end 
end

function punch_stats(keys)
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local str = caster:GetStrength()
  local agi = caster:GetAgility()
  local int = caster:GetIntellect()
  local damage = (str + agi + int) * keys.coff
  local damage_table = {
          victim = target,
          attacker = caster,
          damage = damage,
          damage_type = DAMAGE_TYPE_MAGICAL
        }
  ApplyDamage(damage_table)
  target:EmitSound("Hero_Nightstalker.Trickling_Fear")
  local particle = ParticleManager:CreateParticle("particles/heroes/alastar/nyx_assassin_mana_burn.vpcf", PATTACH_POINT, target)
  ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() + Vector(0, 0, 0))
end

function bonus_learn(keys)
  local caster = keys.caster
  local ability = keys.ability
  local atribute = caster:GetPrimaryAttribute()
  if atribute == 0 then 
  	caster:RemoveModifierByName("modifier_bonus_str")
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bonus_str", {})
  end
  if atribute == 1 then
  	caster:RemoveModifierByName("modifier_bonus_agi")
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bonus_agi", {})
  end
  if atribute == 2 then 
  	caster:RemoveModifierByName("modifier_bonus_int")
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bonus_int", {})
  end 
end

function bonus_check(keys)
  local caster = keys.caster
  local ability = keys.ability
  local atribute = caster:GetPrimaryAttribute()
  local atributes_table = {}
  if atribute == 0 and caster:HasModifier("modifier_bonus_str") == false then 
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bonus_str", {})
  	if caster:HasModifier("modifier_bonus_agi") then caster:RemoveModifierByName("modifier_bonus_agi") end
  	if caster:HasModifier("modifier_bonus_int") then caster:RemoveModifierByName("modifier_bonus_int") end
  end
  if atribute == 1 and caster:HasModifier("modifier_bonus_agi") == false then 
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bonus_agi", {})
  	if caster:HasModifier("modifier_bonus_str") then caster:RemoveModifierByName("modifier_bonus_str") end
  	if caster:HasModifier("modifier_bonus_int") then caster:RemoveModifierByName("modifier_bonus_int") end
  end
  if atribute == 2 and caster:HasModifier("modifier_bonus_int") == false then 
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bonus_int", {})
  	if caster:HasModifier("modifier_bonus_str") then caster:RemoveModifierByName("modifier_bonus_str") end
  	if caster:HasModifier("modifier_bonus_agi") then caster:RemoveModifierByName("modifier_bonus_agi") end
  end 
end