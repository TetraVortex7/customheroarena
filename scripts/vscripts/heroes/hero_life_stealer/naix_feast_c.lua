if naix_feast_c == nil then naix_feast_c = class({})end

LinkLuaModifier("modifier_naix_feast_c_passive","heroes/hero_life_stealer/naix_feast_c.lua",LUA_MODIFIER_MOTION_NONE)

function naix_feast_c:GetIntrinsicModifierName(  )
  return "modifier_naix_feast_c_passive"
end

if modifier_naix_feast_c_passive == nil then modifier_naix_feast_c_passive = class({})end

function modifier_naix_feast_c_passive:DeclareFunctions(  )
  return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_naix_feast_c_passive:IsHidden(  )
  return true
end

function modifier_naix_feast_c_passive:OnAttackLanded( params )
  local caster = self:GetCaster()
  local target = params.target
  local ability = self:GetAbility()
  local attacker = params.attacker
  if attacker == caster and not target:IsMagicImmune() then
    local int = caster:GetIntellect() / 12 / 100
    local health = target:GetMaxHealth()
    local prc = ability:GetSpecialValueFor("steal_scepter")
    local c_prc = ability:GetSpecialValueFor("c_steal_scepter")
    local damage = 0
    local heal = 0
    if caster:HasScepter() then
      if IsBoss(target) then
        heal = health * c_prc * 0.01
        damage = health * c_prc * 0.01
        damage = damage * 0.5
      else
        damage = health * prc * 0.01
        heal = damage
      end
      damage = damage * 0.75
      damage = math.floor(damage)
      damage = damage + damage * int
      caster:HealCustom(heal,caster,false,false)
      ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
    end
    local lifesteal = ability:GetSpecialValueFor("lifesteal_static")
    caster:HealCustom(lifesteal,caster,false,false)
  end
end