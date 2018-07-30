function spheres_cast(keys)
 local caster = keys.caster
 local player = caster:GetPlayerOwner()
 local ability = keys.ability
 local Alevel = ability:GetLevel()
 local maxSpheres = ability:GetLevelSpecialValueFor("maxSpheres", Alevel - 1)
 local RandomVect1 = RandomVector(75) + Vector(0, 0, 150)
 local RandomVect2 = RandomVector(75) + Vector(0, 0, 150)
 local stackCount = caster:GetModifierStackCount("modifier_spheres", ability)
 local abilitySpheres = caster:FindAbilityByName("ghoul_spheres")
 local i = 1
 local d = 0
 local d2 = 0
 if caster:HasModifier("modifier_spheres") and caster:GetModifierStackCount("modifier_spheres", abilitySpheres) < maxSpheres then
   while d ~= 1 and i < (maxSpheres + 1) do
     if player.spheres[i] == nil then
       player.spheres[i] =  ParticleManager:CreateParticle("particles/heroes/ghoul/wisp_tether_b.vpcf", PATTACH_POINT, caster)
       caster:SetModifierStackCount("modifier_spheres", ability, stackCount + 1)
       caster:EmitSound("Hero_Invoker.Invoke")
       d = 1
     else
       i = i + 1
     end
   end
 elseif not caster:HasModifier("modifier_spheres") then
  ability:ApplyDataDrivenModifier(caster, caster, "modifier_spheres", {})
  caster:EmitSound("Hero_Invoker.Invoke")
  caster:SetModifierStackCount("modifier_spheres", ability, 1)
  while d ~= 1 and i < (maxSpheres + 1) do
    if player.spheres[i] == nil then      
      player.spheres[i] =  ParticleManager:CreateParticle("particles/heroes/ghoul/wisp_tether_b.vpcf", PATTACH_POINT, caster)
      d = 1
    else
      i = i + 1
    end
  end
 end
 --[[if caster:HasModifier("modifier_spheres") then
   if stackCount < maxSpheres then
     caster:SetModifierStackCount("modifier_spheres", ability, stackCount + 1)
     if stackCount == 1 then  
       player.spheres[2] = ParticleManager:CreateParticle("particles/heroes/ghoul/wisp_tether_b.vpcf", PATTACH_POINT, caster)
       caster:EmitSound("Hero_Invoker.Invoke")
       Timers:CreateTimer(0, function()
         if player.spheres[2] ~= nil then  
           ParticleManager:SetParticleControl(player.spheres[2], 0, caster:GetAbsOrigin() + Vector(-64.95, 37.5, 150))
           ParticleManager:SetParticleControl(player.spheres[2], 1, caster:GetAbsOrigin() + Vector(64.95, -37.5, 150))
        end
       return 0.03
      end) 
     end
     if stackCount == 2 then  
       player.spheres[3] = ParticleManager:CreateParticle("particles/heroes/ghoul/wisp_tether_b.vpcf", PATTACH_POINT, caster)
       caster:EmitSound("Hero_Invoker.Invoke")
       Timers:CreateTimer(0, function()
         if player.spheres[3] ~= nil then  
           ParticleManager:SetParticleControl(player.spheres[3], 0, caster:GetAbsOrigin() + Vector(37.5, 64.95, 150))
           ParticleManager:SetParticleControl(player.spheres[3], 1, caster:GetAbsOrigin() + Vector(-37.5, -64.95, 150))
          end
       return 0.03
      end) 
     end
     if stackCount == 3 then  
       player.spheres[4] = ParticleManager:CreateParticle("particles/heroes/ghoul/wisp_tether_b.vpcf", PATTACH_POINT, caster)
       caster:EmitSound("Hero_Invoker.Invoke")
       Timers:CreateTimer(0, function()
         if player.spheres[4] ~= nil then  
           ParticleManager:SetParticleControl(player.spheres[4], 0, caster:GetAbsOrigin() + Vector(-37.5, 64.95, 150))
           ParticleManager:SetParticleControl(player.spheres[4], 1, caster:GetAbsOrigin() + Vector(37.5, -64.95, 150))
         end
       return 0.03
      end) 
     end
     if stackCount == 4 then  
       player.spheres[5] = ParticleManager:CreateParticle("particles/heroes/ghoul/wisp_tether_b.vpcf", PATTACH_POINT, caster)
       caster:EmitSound("Hero_Invoker.Invoke")
       Timers:CreateTimer(0, function()
         if player.spheres[5] ~= nil then  
           ParticleManager:SetParticleControl(player.spheres[5], 0, caster:GetAbsOrigin() + Vector(0, 75, 150))
           ParticleManager:SetParticleControl(player.spheres[5], 1, caster:GetAbsOrigin() + Vector(0, -75, 150))
         end
       return 0.03
      end) 
     end
   end 
 else
   --player.spheres = {}
   ability:ApplyDataDrivenModifier(caster, caster, "modifier_spheres", {})
   caster:SetModifierStackCount("modifier_spheres", ability, 1)
   player.spheres[1] =  ParticleManager:CreateParticle("particles/heroes/ghoul/wisp_tether_b.vpcf", PATTACH_POINT, caster)
   caster:EmitSound("Hero_Invoker.Invoke")
   Timers:CreateTimer(0, function()
      if player.spheres[1] ~= nil then
        ParticleManager:SetParticleControl(player.spheres[1], 0, caster:GetAbsOrigin() + Vector(64.95, 37.5, 150))
        ParticleManager:SetParticleControl(player.spheres[1], 1, caster:GetAbsOrigin() - Vector(64.95, 37.5, -150))
      end
     return 0.03
    end)
 end]]--
end

function spheres_move(keys)
  local caster = keys.caster
  local player = caster:GetPlayerOwner()
  if player.spheres[1] ~= nil then
  ParticleManager:SetParticleControl(player.spheres[1], 0, caster:GetAbsOrigin() + Vector(64.95, 37.5, 150))
  ParticleManager:SetParticleControl(player.spheres[1], 1, caster:GetAbsOrigin() - Vector(64.95, 37.5, -150))
  end
  if player.spheres[2] ~= nil then
  ParticleManager:SetParticleControl(player.spheres[2], 0, caster:GetAbsOrigin() + Vector(-64.95, 37.5, 150))
  ParticleManager:SetParticleControl(player.spheres[2], 1, caster:GetAbsOrigin() + Vector(64.95, -37.5, 150))
  end
  if player.spheres[3] ~= nil then
  ParticleManager:SetParticleControl(player.spheres[3], 0, caster:GetAbsOrigin() + Vector(37.5, 64.95, 150))
  ParticleManager:SetParticleControl(player.spheres[3], 1, caster:GetAbsOrigin() + Vector(-37.5, -64.95, 150))
  end
  if player.spheres[4] ~= nil then
  ParticleManager:SetParticleControl(player.spheres[4], 0, caster:GetAbsOrigin() + Vector(-37.5, 64.95, 150))
  ParticleManager:SetParticleControl(player.spheres[4], 1, caster:GetAbsOrigin() + Vector(37.5, -64.95, 150))
  end
  if player.spheres[5] ~= nil then
  ParticleManager:SetParticleControl(player.spheres[5], 0, caster:GetAbsOrigin() + Vector(0, 75, 150))
  ParticleManager:SetParticleControl(player.spheres[5], 1, caster:GetAbsOrigin() + Vector(0, -75, 150))
  end
end

function spheres_died(keys)
  local caster = keys.caster
  local player = caster:GetPlayerOwner()
  if player.spheres ~= nil then  
    for i = 1, 5 do
      if player.spheres[i] ~= nil then
        ParticleManager:DestroyParticle(player.spheres[i], true)
        player.spheres[i] = nil
      end
    end
  end
end

function gnev_start(keys)
  local caster = keys.caster
  local ability = keys.ability
  local player = caster:GetPlayerOwner()
  local abilitySpheres = caster:FindAbilityByName("ghoul_spheres")
  local needSpheres = ability:GetLevelSpecialValueFor("need_spheres", ability:GetLevel() - 1)
  local t = 0
  local i = 5
  if caster:HasModifier("modifier_spheres") then
    if caster:GetModifierStackCount("modifier_spheres", abilitySpheres) > needSpheres then
      caster:SetModifierStackCount("modifier_spheres", abilitySpheres, caster:GetModifierStackCount("modifier_spheres", abilitySpheres) - needSpheres)
      ability:ApplyDataDrivenModifier(caster, caster, "modifier_gnev", {})
      while t < needSpheres do
        if player.spheres[i] ~= nil then
          caster:EmitSound("Hero_LifeStealer.Rage")
          ParticleManager:DestroyParticle(player.spheres[i], true)
          player.spheres[i] = nil
          t = t + 1
          i = i - 1
        else
          i = i - 1
        end
      end
    elseif caster:GetModifierStackCount("modifier_spheres", abilitySpheres) == needSpheres then
      caster:RemoveModifierByName("modifier_spheres")
      ability:ApplyDataDrivenModifier(caster, caster, "modifier_gnev", {})
      while t < needSpheres do
        if player.spheres[i] ~= nil then
          caster:EmitSound("Hero_LifeStealer.Rage")
          ParticleManager:DestroyParticle(player.spheres[i], true)
          player.spheres[i] = nil
          t = t + 1
          i = i -1
        else
          i = i - 1
        end
      end
    end
  end
end

function gnev_effect(keys)
  local caster = keys.caster
  local particle = ParticleManager:CreateParticle("particles/heroes/ghoul/invoker_sun_strike_glow_e_immortal1.vpcf", PATTACH_POINT, caster)
  ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
end

function azura_cast(keys)
  local caster = keys.caster
  local player = caster:GetPlayerOwner()
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local percent = ability:GetLevelSpecialValueFor("percent", ALevel - 1)
  local health = caster:GetMaxHealth()
  local mana = caster:GetMana()
  local need_spheres = ability:GetLevelSpecialValueFor("need_spheres", ALevel - 1)
  local abilitySpheres = caster:FindAbilityByName("ghoul_spheres")
  local target = keys.target
  local damage = (percent * health) /100
  local t = 0
  local i = 5
  local damage_table = {
          victim = target,
          attacker = caster,
          damage = damage,
          damage_type = DAMAGE_TYPE_PHYSICAL
        }
  
  if caster:GetModifierStackCount("modifier_spheres", abilitySpheres) > need_spheres then
    caster:SetModifierStackCount("modifier_spheres", abilitySpheres, caster:GetModifierStackCount("modifier_spheres", abilitySpheres) - need_spheres)
    caster:SpendMana(mana, ability)
    ApplyDamage(damage_table)
    caster:EmitSound("Hero_LifeStealer.Consume")
    local blood = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_POINT, caster)
    ParticleManager:SetParticleControlForward(blood, 1, caster:GetForwardVector() * -1)
    ParticleManager:SetParticleControl(blood, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(blood, 1, target:GetAbsOrigin())
    while t < need_spheres do
        if player.spheres[i] ~= nil then
          ParticleManager:DestroyParticle(player.spheres[i], true)
          player.spheres[i] = nil
          t = t + 1
          i = i -1
        else
          i = i - 1
        end
      end
  elseif caster:GetModifierStackCount("modifier_spheres", abilitySpheres) == need_spheres then
    caster:RemoveModifierByName("modifier_spheres")
    caster:SpendMana(mana, ability)
    ApplyDamage(damage_table)
    caster:EmitSound("Hero_LifeStealer.Consume")
    local blood = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_POINT, caster)
    ParticleManager:SetParticleControlForward(blood, 1, caster:GetForwardVector() * -1)
    ParticleManager:SetParticleControl(blood, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(blood, 1, target:GetAbsOrigin())
    while t < need_spheres do
        if player.spheres[i] ~= nil then
          ParticleManager:DestroyParticle(player.spheres[i], true)
          player.spheres[i] = nil
          t = t + 1
          i = i -1
        else
          i = i - 1
        end
      end
  else
    caster:Stop()
    ability:EndCooldown()
  end
end

function ghoul_hit(keys)
  print("KOOOOOOOOOOOOOOOOOOH")
  local caster = keys.caster
  local player = caster:GetPlayerOwner()
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local percent = ability:GetLevelSpecialValueFor("percent", ALevel - 1)
  local health = caster:GetMaxHealth()
  local mana = caster:GetMana()
  local need_spheres = ability:GetLevelSpecialValueFor("need_spheres", ALevel - 1)
  local abilitySpheres = caster:FindAbilityByName("ghoul_spheres")
  local target = keys.target
  local t = 0
  local d = 0
  local spheresCount = caster:GetModifierStackCount("modifier_spheres", abilitySpheres)
  local i = 5
  local projectile_info = 
  {
    EffectName = "particles/heroes/ghoul/ranged_tower_good.vpcf",
    Ability = ability,
    vSpawnOrigin = caster:GetAbsOrigin(),
    Target = target,
    Source = caster,
    bHasFrontalCone = false,
    bIsAttack = true,
    iMoveSpeed = 1400,
    bReplaceExisting = false,
    bProvidesVision = true
  }
  if caster:HasModifier("modifier_spheres") then
    caster:RemoveModifierByName("modifier_spheres")
    Timers:CreateTimer(0, function()
      local f = 0
      if d < spheresCount and caster:IsAlive() == true then
        ProjectileManager:CreateTrackingProjectile(projectile_info)      
        d = d + 1
        while f == 0 and caster:IsAlive() == true do
          if player.spheres[i] ~= nil then
            ParticleManager:DestroyParticle(player.spheres[i], true)
            player.spheres[i] = nil
            f = 1
          else
            i = i - 1
          end
        end
        return 0.15
      else 
        return nil
      end
    end)
  else
    caster:Stop()
    ability:EndCooldown()
  end
end

function ghoul_project(keys)
victim = keys.target
attacker = keys.caster
attacker:PerformAttack(victim,true, true, true, false, false)
victim:EmitSound("Hero_LifeStealer.Infest")
end

function spheres_learn(keys)
  if keys.ability:GetLevel() == 1 then
    local player = keys.caster:GetPlayerOwner()
    player.spheres = {}
  end
end

function ghoul_strenght(keys)
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local strenghtbuff = ability:GetLevelSpecialValueFor("strenghtbuff", ALevel - 1)
  local cooldown = ability:GetLevelSpecialValueFor("cooldown", ALevel - 1)
   if target:IsHero() == true then 
    if ability:IsCooldownReady() == true then
      ability:StartCooldown(cooldown)
      if caster:HasModifier("modifier_strenght_buff") then
        caster:SetModifierStackCount("modifier_strenght_buff", ability, caster:GetModifierStackCount("modifier_strenght_buff", abilitySpheres) + strenghtbuff)
      else
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_strenght_buff", {})
        caster:SetModifierStackCount("modifier_strenght_buff", ability, strenghtbuff)
      end
      if target:HasModifier("modifier_strenght_debuff") then
        target:SetModifierStackCount("modifier_strenght_debuff", ability, target:GetModifierStackCount("modifier_strenght_debuff", abilitySpheres) + strenghtbuff)
      else
        ability:ApplyDataDrivenModifier(caster, target, "modifier_strenght_debuff", {})
        target:SetModifierStackCount("modifier_strenght_debuff", ability, strenghtbuff)
      end
   end
  end 
end

function ghoul_shieldoff(keys)
  local caster = keys.caster
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local cooldown = ability:GetLevelSpecialValueFor("cooldown", ALevel - 1)
  caster:RemoveModifierByName("modifier_shield")
  ability:StartCooldown(cooldown)
end

function ghoul_shielddestroy(keys)
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local cooldown = ability:GetLevelSpecialValueFor("cooldown", ALevel - 1)
  ability:StartCooldown(cooldown)
end
--[[
 local projectile_info = 
  {
    EffectName = "particles/base_attacks/ranged_tower_good.vpcf",
    Ability = ability,
    vSpawnOrigin = caster:GetAbsOrigin(),
    Target = target,
    Source = caster,
    bHasFrontalCone = false,
    iMoveSpeed = 1200,
    bReplaceExisting = false,
    bProvidesVision = true
  }
  if caster:GetModifierStackCount("modifier_spheres", abilitySpheres) > need_spheres then
    
  elseif caster:GetModifierStackCount("modifier_spheres", abilitySpheres) == need_spheres then
    caster:SpendMana(mana, ability)
    ProjectileManager:CreateTrackingProjectile(projectile_info)]]

--[[
function ghoul_hit(keys)
  print("KOOOOOOOOOOOOOOOOOOH")
  local caster = keys.caster
  local player = caster:GetPlayerOwner()
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local percent = ability:GetLevelSpecialValueFor("percent", ALevel - 1)
  local health = caster:GetMaxHealth()
  local mana = caster:GetMana()
  local need_spheres = ability:GetLevelSpecialValueFor("need_spheres", ALevel - 1)
  local abilitySpheres = caster:FindAbilityByName("ghoul_spheres")
  local target = keys.target
  local t = 0
  local d = 0
  local spheresCount = caster:GetModifierStackCount("modifier_spheres", abilitySpheres)
  local i = 5
  local projectile_info = 
  {
    EffectName = "particles/base_attacks/ranged_tower_good.vpcf",
    Ability = ability,
    vSpawnOrigin = caster:GetAbsOrigin(),
    Target = target,
    Source = caster,
    bHasFrontalCone = false,
    bIsAttack = true,
    iMoveSpeed = 1200,
    bReplaceExisting = false,
    bProvidesVision = true
  }
  Timers:CreateTimer(0, function()  
    if d < spheresCount then
      while t < spheresCount do
        if player.spheres[i] ~= nil then
          if caster:GetModifierStackCount("modifier_spheres", abilitySpheres) > 1 then
            caster:SetModifierStackCount("modifier_spheres", abilitySpheres, caster:GetModifierStackCount("modifier_spheres", abilitySpheres) - 1)
          else
            caster:RemoveModifierByName("modifier_spheres")
          end
          ProjectileManager:CreateTrackingProjectile(projectile_info)
          ParticleManager:DestroyParticle(player.spheres[i], true)
          player.spheres[i] = nil
          t = t + 1
          i = i - 1
        else
          i = i - 1
        end
      end
    d = d + 1
    return 0.5
    else return nil
    end  
  end)
end
]]