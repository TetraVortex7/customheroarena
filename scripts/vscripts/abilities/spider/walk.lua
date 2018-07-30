function Start(keys)
  local caster = keys.caster
  local target = keys.target
  local player = caster:GetPlayerID()
  local spiderok = CreateUnitByName("spidor_walk", caster:GetAbsOrigin() + RandomFloat(20, 40), true, caster, caster, caster:GetTeamNumber())
  keys.ability:ApplyDataDrivenModifier(spiderok, spiderok, "modifier_onAttack", {})
  FindClearSpaceForUnit(spider, spiderok:GetAbsOrigin(), false)
  Timers:CreateTimer(0.1, function()
    spiderok:MoveToTargetToAttack(target)
  end)
end

function Attack(keys)
  local caster = keys.caster
  local target = keys.target
  local owner = caster:GetOwner()
  local ability = owner:FindAbilityByName("spider_walk")
  ability:ApplyDataDrivenModifier(caster, target, "modifier_debuff", {})
  ability:ApplyDataDrivenModifier(owner, caster, "modifier_debuffcaster", {})
  print("MDA")
  caster.walking = 1
  caster:AddNoDraw()
  Timers:CreateTimer(function()
    if caster.walking ~= 1 then return nil end
    caster:SetAbsOrigin(target:GetAbsOrigin())
    FindClearSpaceForUnit(caster, target:GetAbsOrigin(), false)
  return 0.03
  end)
end

function Destroy(keys)
  local caster = keys.caster
  local owner = caster:GetOwner()
  owner.walking = 0
  caster:RemoveSelf()
  print("KEEEK")
end