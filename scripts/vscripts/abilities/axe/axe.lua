function axe_regen(keys)
  local caster = keys.caster
  local ability = keys.ability
  local target = keys.target
  local heal = (caster:GetStrength() * keys.coff)/100
  caster:Heal(heal, caster)
  ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath_heal.vpcf", PATTACH_POINT, caster)
  ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin() + Vector(0, 0, 0))
end