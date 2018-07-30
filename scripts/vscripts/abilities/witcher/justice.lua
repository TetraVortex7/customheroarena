function OnSpellStart(keys)
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local damage = ability:GetLevelSpecialValueFor("damage", ALevel - 1)
  local intelligence = caster:GetIntellect()
  if target:IsSilenced() then
    print("AZAZ")
    damage = damage + intelligence*4
    print(damage, "1")
  end
  local damage_table = {
    victim = target,
    attacker = caster,
    damage = damage,
    damage_type = DAMAGE_TYPE_MAGICAL
  }
  ApplyDamage(damage_table)
  print(damage)
end