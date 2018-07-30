function huskar_projectile(keys)
  local caster = keys.caster
  local target = keys.target
  local damage = caster:GetHealthDeficit() * (keys.procent/100)
  local damage_table = {
          victim = target,
          attacker = caster,
          damage = damage,
          damage_type = DAMAGE_TYPE_MAGICAL
        }
  ApplyDamage(damage_table)
  target:EmitSound("Hero_Nightstalker.Void")
end