function wraithking_bleeding_attack(keys)
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local max_stacks = keys.max_stacks
  if target:HasModifier("modifier_wraithking_bleeding") == false then
  	ability:ApplyDataDrivenModifier(caster, target, "modifier_wraithking_bleeding", {})
  	target:SetModifierStackCount("modifier_wraithking_bleeding", ability, 1)
  elseif target:GetModifierStackCount("modifier_wraithking_bleeding", ability) < 5 then
    target:SetModifierStackCount("modifier_wraithking_bleeding", ability, target:GetModifierStackCount("modifier_wraithking_bleeding", ability) + 1)
    target:FindModifierByName("modifier_wraithking_bleeding"):ForceRefresh()
  elseif target:GetModifierStackCount("modifier_wraithking_bleeding", ability) == 5 then
  	target:FindModifierByName("modifier_wraithking_bleeding"):ForceRefresh()
  end
end

function wraithking_bleeding_thinker(keys)
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local damage = keys.damage * target:GetModifierStackCount("modifier_wraithking_bleeding", ability)
  local damage_table = {
          victim = target,
          attacker = caster,
          damage = damage,
          damage_type = DAMAGE_TYPE_MAGICAL
        }
  ApplyDamage(damage_table)
end

function wraith_okowy_start(keys)
  keys.caster:EmitSound("Hero_SkeletonKing.Hellfire_Blast")
  keys.target:EmitSound("Hero_SkeletonKing.Hellfire_Blast")
end