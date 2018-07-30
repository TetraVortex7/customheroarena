function OnSpellStart(keys)
  local caster = keys.caster
  local casterPos1 = caster:GetAbsOrigin()
  local casterPos = casterPos1 + Vector(150, 150, 350)
  local particle = ParticleManager:CreateParticle("particles/heroes/witcher/witcher_calm_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
  ParticleManager:SetParticleControl(particle, 1, casterPos1)
  ParticleManager:SetParticleControl(particle, 0, casterPos1)
  print(casterPos1, casterPos)
end