function omnislash(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
  
  local ability_stacks = caster:FindAbilityByName("satir_agility")
  local ALevel_Stacks = ability_stacks:GetLevel()
  local agilitybuff = ability_stacks:GetLevelSpecialValueFor("agilitybuff", ALevel_Stacks - 1)
  local duration = ability_stacks:GetLevelSpecialValueFor("duration", ALevel_Stacks - 1)
  local maxstacks = ability_stacks:GetLevelSpecialValueFor("maxstacks", ALevel_Stacks - 1)
	
  local ALevel = ability:GetLevel()
	local chance = ability:GetLevelSpecialValueFor("chance", ALevel - 1)
	local agility = caster:GetAgility()
	local attackdamage = caster:GetAttackDamage()
	local damage = agility
  local stacksagility = caster:GetModifierStackCount("modifier_agility_buff", ability_stacks)
  local int = RandomInt(1, 100)
  local i = 0
  Timers:CreateTimer(0, function()
    if i < 2 then
      if caster:IsAlive() == false or target:IsAlive() == false then
        target:RemoveModifierByName("modifier_debuff")
        caster:RemoveModifierByName("modifier_buff")
        caster:RemoveNoDraw()
        caster:RemoveModifierByName("untouch")
        caster:Stop()
        print("LOH")
      end
      i = i + 1
      return 0.15
    else 
      return nil
    end
  end)
    if int < (chance + 1) then
      local damagetype = DAMAGE_TYPE_PURE
      local damage_table = {
          victim = target,
          attacker = caster,
          damage = damage,
          damage_type = damagetype
        }
      if caster:GetRangeToUnit(target) < 500 then   
         caster:SetAbsOrigin(target:GetAbsOrigin())
         FindClearSpaceForUnit(keys.caster, caster:GetAbsOrigin(), false)
      else
    	  caster:RemoveModifierByName("modifier_buff")
    	  caster:RemoveModifierByName("untouch")
    	  target:RemoveModifierByName("modifier_debuff")
    	  caster:Stop()
    	  return nil
      end
     caster:PerformAttack(target, true, false, true, false, false)
     ApplyDamage(damage_table)
     ParticleManager:CreateParticle("particles/heroes/satir/juggernaut_omni_slash_tgt.vpcf", PATTACH_POINT, target)
     ParticleManager:CreateParticle("particles/heroes/satir/juggernaut_omni_slash_tgt.vpcf", PATTACH_POINT, target)
     ParticleManager:CreateParticle("particles/heroes/satir/juggernaut_omni_slash_tgt.vpcf", PATTACH_POINT, target)
     ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_blood.vpcf", PATTACH_POINT, target)
     caster:EmitSound("Hero_Riki.Backstab")

     --[[if caster:HasModifier("modifier_agility_buff") then
      local modifier = caster:FindModifierByName("modifier_agility_buff")
      local stacks = caster:GetModifierStackCount("modifier_agility_buff", ability_stacks)
      local coff = maxstacks - stacks
      if coff > agilitybuff then
        caster:SetModifierStackCount("modifier_agility_buff", ability_stacks, stacks + agilitybuff)
        modifier:ForceRefresh()
      else
        caster:SetModifierStackCount("modifier_agility_buff", ability_stacks, maxstacks)
        modifier:ForceRefresh()
      end
    elseif caster:FindAbilityByName("satir_agility"):GetLevel() > 0 then
      ability_stacks:ApplyDataDrivenModifier(caster, caster, "modifier_agility_buff", { Duration = duration })
      caster:SetModifierStackCount("modifier_agility_buff", ability_stacks, agilitybuff)
    end]]--
    else
      local damagetype = DAMAGE_TYPE_PHYSICAL
      local damage_table = {
          victim = target,
          attacker = caster,
          damage = damage,
          damage_type = damagetype
        }
     if caster:GetRangeToUnit(target) < 500 then   
         caster:SetAbsOrigin(target:GetAbsOrigin())
         FindClearSpaceForUnit(keys.caster, caster:GetAbsOrigin(), false)
     else
    	  caster:RemoveModifierByName("modifier_buff")
    	  caster:RemoveModifierByName("untouch")
    	  target:RemoveModifierByName("modifier_debuff")
    	  caster:Stop()
    	  return nil
     end
     caster:PerformAttack(target, true, false, true, false, false)
     ApplyDamage(damage_table)
     ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", PATTACH_POINT, target)
     ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", PATTACH_POINT, target)
     ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", PATTACH_POINT, target)
     ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_blood.vpcf", PATTACH_POINT, target)
     caster:EmitSound("Hero_Riki.Backstab")

    --[[if caster:HasModifier("modifier_agility_buff") then
      local modifier = caster:FindModifierByName("modifier_agility_buff")
      local stacks = caster:GetModifierStackCount("modifier_agility_buff", ability_stacks)
      local coff = maxstacks - stacks
      if coff > agilitybuff then
        caster:SetModifierStackCount("modifier_agility_buff", ability_stacks, stacks + agilitybuff)
        modifier:ForceRefresh()
      else
        caster:SetModifierStackCount("modifier_agility_buff", ability_stacks, maxstacks)
        modifier:ForceRefresh()
      end
    elseif caster:FindAbilityByName("satir_agility"):GetLevel() > 0 then
      ability_stacks:ApplyDataDrivenModifier(caster, caster, "modifier_agility_buff", { Duration = duration })
      caster:SetModifierStackCount("modifier_agility_buff", ability_stacks, agilitybuff)
    end]]--
  end
end

function omnislash_nodraw(keys)
   keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "untouch", {})
   keys.caster:AddNoDraw()

end

function omnislash_draw(keys)
  keys.caster:RemoveNoDraw()
  keys.caster:RemoveModifierByName("untouch")
  keys.caster:Stop()
end


function satir_agility(keys)
  local caster = keys.caster
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local agilitybuff = ability:GetLevelSpecialValueFor("agilitybuff", ALevel - 1)
  local duration = ability:GetLevelSpecialValueFor("duration", ALevel - 1)
  local maxstacks = ability:GetLevelSpecialValueFor("maxstacks", ALevel - 1)
  if caster:HasModifier("modifier_agility_buff") then
    local modifier = caster:FindModifierByName("modifier_agility_buff")
    local stacks = caster:GetModifierStackCount("modifier_agility_buff", ability)
    local coff = maxstacks - stacks
    if coff > agilitybuff then
      caster:SetModifierStackCount("modifier_agility_buff", ability, stacks + agilitybuff)
      modifier:ForceRefresh()
    else
      caster:SetModifierStackCount("modifier_agility_buff", ability, maxstacks)
      modifier:ForceRefresh()
    end
  else
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_agility_buff", { Duration = duration })
    caster:SetModifierStackCount("modifier_agility_buff", ability, agilitybuff)
  end
end

function satir_fly(keys)
  local caster = keys.caster
  local attacker = keys.attacker
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local chance = ability:GetLevelSpecialValueFor("chance", ALevel - 1)
  local coff = ability:GetLevelSpecialValueFor("coff", ALevel - 1)
  local int = RandomInt(1, 100)
  if not caster:HasModifier("modifier_dodge") and int < (chance + 1) then
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_dodge", {})
    ability:ApplyDataDrivenModifier(caster, attacker, "modifier_dodge_debuff", {})
  end
  for k, v in pairs(keys.target) do
    print(k, v)
  end
end

function satir_fly_failed(keys)
  local target = keys.target
  local attacker = keys.attacker
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local chance = ability:GetLevelSpecialValueFor("chance", ALevel - 1)
  local coff = ability:GetLevelSpecialValueFor("coff", ALevel - 1)
  local agility = target:GetAgility()
  local attackdamage = target:GetAttackDamage()
  local int = RandomInt(1, 100)
  local int2 = RandomInt(1, 100)
  local damage = (coff * agility) + attackdamage
  local buff = target:FindModifierByName("modifier_dodge")
  local debuff = attacker:FindModifierByName("modifier_dodge_debuff")
  local damage_table = {
          victim = attacker,
          attacker = target,
          damage = damage,
          damage_type = DAMAGE_TYPE_PHYSICAL
        }
  if target:HasModifier("modifier_dodge") then
    if int < (chance + 1) then
      ApplyDamage(damage_table)
      attacker:EmitSound("Hero_Riki.Blink_Strike")
      local particle = ParticleManager:CreateParticle("particles/heroes/satir/templar_assassin_meld_hit_arcs_butterfly.vpcf", PATTACH_POINT, target)
      ParticleManager:SetParticleControl(particle, 3, target:GetAbsOrigin())
      local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_backstab.vpcf", PATTACH_POINT, attacker)
      local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_backstab.vpcf", PATTACH_POINT, attacker)
      local particle3 = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_backstab.vpcf", PATTACH_POINT, attacker)
      ParticleManager:SetParticleControlForward(particle2, 0, attacker:GetForwardVector() + RandomVector(360))
      ParticleManager:SetParticleControlForward(particle3, 0, attacker:GetForwardVector() + RandomVector(360))
      if int2 < (chance + 1) then
        buff:ForceRefresh()
        debuff:ForceRefresh()
      else
        target:RemoveModifierByName("modifier_dodge")
        attacker:RemoveModifierByName("modifier_dodge_debuff") 
      end
    else
      local particle = ParticleManager:CreateParticle("particles/heroes/satir/templar_assassin_meld_hit_arcs_butterfly.vpcf", PATTACH_POINT, target)
      ParticleManager:SetParticleControl(particle, 3, target:GetAbsOrigin())
      if int2 < (chance + 1) then
        buff:ForceRefresh()
        debuff:ForceRefresh()
      else
        target:RemoveModifierByName("modifier_dodge")
        attacker:RemoveModifierByName("modifier_dodge_debuff") 
      end
    end
  end
end

function satir_duel(keys)
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local chance = ability:GetLevelSpecialValueFor("chance", ALevel - 1)
  local player = caster:GetPlayerOwner()
  player.duel_target = nil
  player.duel_target = target
  if player.duel_bonus == nil then
    player.duel_bonus = 0
  end
  --ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_duel_ring.vpcf", PATTACH_POINT, caster)
  target:MoveToTargetToAttack(caster)
  caster:MoveToTargetToAttack(target)
end

function satir_duelattack(keys)
  
end

function satir_duel_think(keys)
  local caster = keys.caster
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local player = caster:GetPlayerOwner()
  local target = player.duel_target
  local i = 0
  local agility = ability:GetLevelSpecialValueFor("agility", ALevel - 1)
  if target:IsAlive() == false and caster:IsAlive() == true  then
    caster:RemoveModifierByName("modifier_duel_buff")
    if not caster:HasModifier("modifier_duel_agility") then
      ability:ApplyDataDrivenModifier(caster, caster, "modifier_duel_agility", {})
      caster:SetModifierStackCount("modifier_duel_agility", ability, agility)
      player.duel_bonus = agility
      caster:EmitSound("Hero_LegionCommander.Duel.Victory")
      ability:ApplyDataDrivenModifier(caster, caster, "modifier_duel_victory", {})
    else
      local stacks = caster:GetModifierStackCount("modifier_duel_agility", ability)
      caster:SetModifierStackCount("modifier_duel_agility", ability, stacks + agility)
      player.duel_bonus = player.duel_bonus + agility
      caster:EmitSound("Hero_LegionCommander.Duel.Victory")
      ability:ApplyDataDrivenModifier(caster, caster, "modifier_duel_victory", {})
    end
  end
end

function satir_duel_caster_death(keys)
  local caster = keys.caster
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local player = caster:GetPlayerOwner()
  local target = player.duel_target
  local agility = ability:GetLevelSpecialValueFor("agility", ALevel - 1)
  target:RemoveModifierByName("modifier_duel_debuff")
  StopSoundEvent("Hero_LegionCommander.Duel", caster)
  if caster:IsAlive() == false and target:IsAlive() == true then
    target:EmitSound("Hero_LegionCommander.Duel.Victory")
    ability:ApplyDataDrivenModifier(target, target, "modifier_duel_victory", {})
  end
  if target:IsAlive() == true and caster:IsAlive() == true then
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_duel_pat", {})
  end
end

function satir_duel_spawned(keys)
  local caster = keys.caster
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local player = caster:GetPlayerOwner()
  local target = player.duel_target
  local agility = ability:GetLevelSpecialValueFor("agility", ALevel - 1)
  if player.duel_bonus > 0 then
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_duel_agility", {})
    caster:SetModifierStackCount("modifier_duel_agility", ability, player.duel_bonus)
  end
end

function satir_healh(keys)
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local health = ability:GetLevelSpecialValueFor("health", ALevel - 1)
  local casterHealth = caster:GetHealth()
  local new_health = health + casterHealth
  local targetHealth = target:GetHealth()
  local target_new_health = targetHealth - health
  local damage_table = {
          victim = target,
          attacker = caster,
          damage = health,
          damage_type = DAMAGE_TYPE_PURE
        }
  caster:ModifyHealth(new_health, ability, false, 0)
  ApplyDamage(damage_table)
  local particle = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
  local stun_digits = string.len(tostring(math.floor(health))) + 1
  ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
  ParticleManager:SetParticleControl(particle, 1, Vector(10, health, 0))
  ParticleManager:SetParticleControl(particle, 2, Vector(1, stun_digits, 0))
  ParticleManager:SetParticleControl(particle, 3, Vector(127, 255, 0))
end

function satir_marionet_start(keys)
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local player = caster:GetPlayerOwner()
  local agility = caster:GetModifierStackCount("modifier_agility_buff", caster:FindAbilityByName("satir_agility"))/2
  local base_agi = ability:GetLevelSpecialValueFor("base_agi", ALevel - 1)
  local projectile_info = 
  {
    EffectName = "particles/base_attacks/fountain_attack.vpcf",
    Ability = ability,
    vSpawnOrigin = caster:GetAbsOrigin(),
    Target = target,
    Source = caster,
    bHasFrontalCone = false,
    bIsAttack = true,
    iMoveSpeed = 600,
    bReplaceExisting = false,
    bProvidesVision = true
  }
  if target == caster then return end
  if caster:HasModifier("modifier_agility_buff") then  
    ProjectileManager:CreateTrackingProjectile(projectile_info)
    caster:EmitSound("Hero_Riki.Smoke_Screen")
    caster:RemoveModifierByName("modifier_agility_buff")
    player.marionet_agility = agility + base_agi
  end
end

function satir_marionet_projectile(keys)
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local player = caster:GetPlayerOwner()
  local agility = caster:GetModifierStackCount("modifier_agility_buff", caster:FindAbilityByName("satir_agility"))/2
  local target_agility = target:GetModifierStackCount("modifier_marionet_buff", ability)
  if not target:HasModifier("modifier_marionet_buff") then
    ability:ApplyDataDrivenModifier(caster, target, "modifier_marionet_buff", {})
  end
  target:SetModifierStackCount("modifier_marionet_buff", ability, player.marionet_agility + target_agility)
  target:EmitSound("Hero_Riki.Invisibility")
end
--particles/msg_fx/msg_heal.vpcf