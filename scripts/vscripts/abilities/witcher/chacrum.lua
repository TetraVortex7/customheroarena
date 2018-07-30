function OnSpellStart(keys)
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local firstDamage = ability:GetLevelSpecialValueFor("damager", ALevel - 1)
  local intelligence = caster:GetIntellect()
  local damage = firstDamage + intelligence*2
  local damage_table = {
    victim = target,
    attacker = caster,
    damage = damage,
    damage_type = DAMAGE_TYPE_MAGICAL
  }
  ApplyDamage(damage_table)
  print(firstDamage, damage)
end