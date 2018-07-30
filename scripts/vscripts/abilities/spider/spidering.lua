function RestoreStart(keys)
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local caster = keys.caster
  local restoreStart = false
  local restoreTime = ability:GetSpecialValueFor("restoreTime")
  local modifierName = "modifier_spidering"
  local modifierName2 = "modifier_restore"
  local maxModifiers = ability:GetLevelSpecialValueFor("maxModifiers", ALevel - 1)
  if ALevel == 1 then
    ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
    caster:SetModifierStackCount(modifierName, ability, 1) 
    local StackCount = caster:GetModifierStackCount(modifierName, ability)
    if StackCount < maxModifiers then
      ability:ApplyDataDrivenModifier(caster, caster, modifierName2, { Duration = restoreTime })
    end
   else
   	if ALevel < 5 then
      if caster:HasModifier(modifierName2) then
      	return nil
      else
        ability:ApplyDataDrivenModifier(caster, caster, modifierName2, { Duration = restoreTime })
      end
    end
  end
end

function Restoring(keys)
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local caster = keys.caster
  local restoreStart = false
  local restoreTime = ability:GetSpecialValueFor("restoreTime")
  local modifierName = "modifier_spidering"
  local modifierName2 = "modifier_restore"
  local maxModifiers = ability:GetLevelSpecialValueFor("maxModifiers", ALevel - 1)
  local StackCount = caster:GetModifierStackCount(modifierName, ability)
  if caster:HasModifier(modifierName) then  
    caster:SetModifierStackCount(modifierName, ability, StackCount + 1)
    if caster:GetModifierStackCount(modifierName, ability) < maxModifiers then
  	  ability:ApplyDataDrivenModifier(caster, caster, modifierName2, { Duration = restoreTime })
    end
  else
  	ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
    caster:SetModifierStackCount(modifierName, ability, 1)
    if caster:GetModifierStackCount(modifierName, ability) < maxModifiers then
  	  ability:ApplyDataDrivenModifier(caster, caster, modifierName2, { Duration = restoreTime })
    end
  end
  ability:EndCooldown()
end

function SpellStart(keys)
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local caster = keys.caster
  local restoreStart = false
  local restoreTime = ability:GetSpecialValueFor("restoreTime")
  local modifierName = "modifier_spidering"
  local modifierName2 = "modifier_restore"
  local maxModifiers = ability:GetLevelSpecialValueFor("maxModifiers", ALevel - 1)
  local StackCount = caster:GetModifierStackCount(modifierName, ability)
  local casterPos = caster:GetAbsOrigin()
  local player = caster:GetPlayerID()
  if caster.kolvo == nil then caster.kolvo = 0 end
  if caster.kolvo == 8 then
    print("3", caster.kolvo)
    caster:Stop()
    return nil
  end
  if caster.kolvo > 0 then
    spidor = CreateUnitByName("spidor_" .. ALevel, casterPos + RandomFloat(10, 15), true, caster, caster, caster:GetTeamNumber())
    spidor:SetControllableByPlayer(player, true)
    local spidorA = spidor:FindAbilityByName("spider_spidermine")
    spidorA:SetLevel(ALevel)
    caster.kolvo = caster.kolvo + 1
    print("2", caster.kolvo)
  end
  if caster.kolvo == 0 then
    spidor = CreateUnitByName("spidor_" .. ALevel, casterPos + RandomFloat(10, 15), true, caster, caster, caster:GetTeamNumber())
    spidor:SetControllableByPlayer(player, true)
    local spidorA = spidor:FindAbilityByName("spider_spidermine")
    spidorA:SetLevel(ALevel)
    caster.kolvo = 1
    print("1", caster.kolvo)
  end
  if caster:GetModifierStackCount(modifierName, ability) == 1 then
    ability:StartCooldown(9999999)
  end
  caster:SetModifierStackCount(modifierName, ability, StackCount - 1)
  if caster:HasModifier(modifierName2) then return end
  if caster:GetModifierStackCount(modifierName, ability) < maxModifiers then
    ability:ApplyDataDrivenModifier(caster, caster, modifierName2, { Duration = restoreTime })
  end
end

function SpawnedRestore(keys)
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local caster = keys.caster
  local restoreStart = false
  local restoreTime = ability:GetSpecialValueFor("restoreTime")
  local modifierName = "modifier_spidering"
  local modifierName2 = "modifier_restore"
  local maxModifiers = ability:GetLevelSpecialValueFor("maxModifiers", ALevel - 1)
  ability:StartCooldown(9999999)
  ability:ApplyDataDrivenModifier(caster, caster, modifierName2, { Duration = restoreTime })
  print("4", caster.kolvo)
end

function SpiderDie(keys)
  local caster = keys.caster:GetOwner()
  print("6", caster.kolvo)
  caster.kolvo = caster.kolvo - 1
end

function SpellStartWard(keys)
  local caster = keys.caster
  local owner = caster:GetOwner()
  local point = caster:GetAbsOrigin()
  local team = caster:GetTeamNumber()
  local ability = keys.ability
  if owner.wardsNow == nil then owner.wardsNow = 0 end
  if owner.wardsNow < ability:GetSpecialValueFor("max_wards") then
    local ward = CreateUnitByName("spidor_ward", point, true, owner, owner, team)
    ward:EmitSound("Hero_Broodmother.SpawnSpiderlingsDeath")
    ability:ApplyDataDrivenModifier(ward, ward, "modifier_destroy", {})
    caster:RemoveSelf()
    owner.kolvo = owner.kolvo - 1
    owner.wardsNow = owner.wardsNow + 1
  end
end

function DestroyWard(keys)
  local caster = keys.caster
  local owner = caster:GetOwner()
  caster:ForceKill(true)
end

function SpiderWardDie(keys)
  local caster = keys.caster
  local owner = caster:GetOwner()
  owner.wardsNow = owner.wardsNow - 1
end

function SpellStartMine(keys)
  local caster = keys.caster
  local owner = caster:GetOwner()
  local point = caster:GetAbsOrigin()
  local team = caster:GetTeamNumber()
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local ownerAbility = caster:FindAbilityByName("spider_spidermine")
  local ownerAbilityLevel = ownerAbility:GetLevel()
  if owner.minesNow == nil then owner.minesNow = 0 end
  if owner.minesNow < ability:GetSpecialValueFor("max_mines") then
    local mine = CreateUnitByName("spidor_mine", point, true, owner, owner, team)
    ability:ApplyDataDrivenModifier(mine, mine, "modifier_mineStart", {})
    mine:EmitSound("Hero_Broodmother.SpawnSpiderlings")
    mine:AddAbility("spider_spidermineSpell")
    local mineAbility = mine:FindAbilityByName("spider_spidermineSpell")
    mineAbility:SetLevel(ownerAbilityLevel)
    owner.minesNow = owner.minesNow + 1
    caster:RemoveSelf()
    owner.kolvo = owner.kolvo - 1
  end
end

function SpellStartMineCheck(keys)
  local caster = keys.caster
  local owner = caster:GetOwner()
  local point = caster:GetAbsOrigin()
  local team = caster:GetTeamNumber()
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
  local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
  local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
  local activate_radius = 50
  local damage_radius = 200
  Timers:CreateTimer(0.3, function()
    local units_activator = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, activate_radius, target_team, target_types, target_flags, FIND_CLOSEST, false)
    if #units_activator > 0 then
        caster:EmitSound("Ability.SandKing_CausticFinale")
        local particle = ParticleManager:CreateParticle("particles/heroes/spider/spider_boom.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        local units_damage = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, damage_radius, target_team, target_types, target_flags, FIND_CLOSEST, false)
        Timers:CreateTimer(0.03, function()
          caster:RemoveSelf()
          owner.minesNow = owner.minesNow - 1
          return nil
        end)
        for key, unit in pairs(units_damage) do
          local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode_c_lv.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
          local AbilityMine = caster:FindAbilityByName("spider_spidermineSpell")
          local AMineLevel = AbilityMine:GetLevel()
          local Ddamage = AbilityMine:GetLevelSpecialValueFor("damage", AMineLevel - 1)
          local damage_table = {
            victim = unit,
            attacker = owner,
            damage = Ddamage,
            damage_type = DAMAGE_TYPE_MAGICAL
          }
          ApplyDamage(damage_table)
        end
    else
      return 0.03
    end
  end)
end

function SpiderMineDie(keys)
  local caster = keys.caster
  local owner = caster:GetOwner()
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
  local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
  local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
  local damage_radius = 200
  local units_damage = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, damage_radius, target_team, target_types, target_flags, FIND_CLOSEST, false)
  caster:EmitSound("Ability.SandKing_CausticFinale")
  local particle = ParticleManager:CreateParticle("particles/heroes/spider/spider_boom.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        Timers:CreateTimer(0.03, function()
          caster:RemoveSelf()
          owner.minesNow = owner.minesNow - 1
          return nil
        end)
        for key, unit in pairs(units_damage) do
          local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode_c_lv.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
          local AbilityMine = caster:FindAbilityByName("spider_spidermineSpell")
          local AMineLevel = AbilityMine:GetLevel()
          local Ddamage = AbilityMine:GetLevelSpecialValueFor("damage", AMineLevel - 1)
          local damage_table = {
            victim = unit,
            attacker = owner,
            damage = Ddamage,
            damage_type = DAMAGE_TYPE_MAGICAL
          }
          ApplyDamage(damage_table)
        end
end