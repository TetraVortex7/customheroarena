function OnSpellStart(keys)
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local duration = ability:GetLevelSpecialValueFor("duration", ALevel)
  local resistanceStart = target:GetBaseMagicalResistanceValue()
  print(resistanceStart)
end