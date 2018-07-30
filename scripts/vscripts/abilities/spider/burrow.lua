function SpellStart(keys)
  local caster = keys.caster
  local ability = keys.ability
  local ALevel = ability:GetLevel()
  local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
  local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
  local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
  local find_radius = 150
  if caster.burrowen == 1 then return end
  caster.burrow = true
  caster:AddNoDraw()
  caster:EmitSound("Ability.SandKing_Epicenter")
  Timers:CreateTimer(function()
    if caster.burrow == true then
      caster.particle_burrow = ParticleManager:CreateParticle("particles/heroes/spider/spider_burrow.vpcf", PATTACH_ABSORIGIN, caster)
      local point = caster:GetAbsOrigin()
      ParticleManager:SetParticleControl(caster.particle_burrow, 0, point)
      caster.burrowen = 1
      local units_table = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, find_radius, target_team, target_types, target_flags, FIND_CLOSEST, false)
      for k, v in pairs(units_table) do
      	local damage_table = {
          victim = v,
          attacker = caster,
          damage = ability:GetLevelSpecialValueFor("damage", ALevel),
          damage_type = DAMAGE_TYPE_PURE
        }
        if not(v:HasModifier("modifier_bhidden")) then
          ApplyDamage(damage_table)
          ability:ApplyDataDrivenModifier(caster, v, "modifier_bhidden", {})
        end
      end
      return 0.15
    else
      return nil
    end
  end)
end

function SpellEnd(keys)
	local caster = keys.caster
	caster.burrow = false
	caster:RemoveNoDraw()
	caster.burrowen = 0
  ParticleManager:DestroyParticle(caster.particle_burrow, true)
end

function Attack(keys)
  local caster = keys.caster
  caster.burrow = false
  caster:RemoveNoDraw()
  caster.burrowen = 0
  caster:RemoveModifierByName("modifier_bhidden")
  ParticleManager:DestroyParticle(caster.particle_burrow, true)
end

