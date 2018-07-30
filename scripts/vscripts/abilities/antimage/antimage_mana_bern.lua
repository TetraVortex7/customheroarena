function ManaBern( keys)
  local attacker = keys.attacker
  local target = keys.target
  local particleName = "particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_basher_manaburn_impact_lightning_gold.vpcf"
  local ability = keys.ability
  local ability_level = ability:GetLevel()
  local SpendMana = ability:GetLevelSpecialValueFor("SpendMana", ability_level)
  local damage_table = {}
	damage_table.attacker = attacker
	damage_table.victim = target
	damage_table.damage_type = DAMAGE_TYPE_MAGICAL
	damage_table.damage = SpendMana
  target:SpendMana(SpendMana, nil)
  ApplyDamage(damage_table)
  ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
end