function died(keys)
  local caster = keys.caster
  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny04_death.vpcf", PATTACH_POINT, caster)
  ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin() + Vector(0, 0, 0))

end