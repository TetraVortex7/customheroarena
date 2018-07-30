function mana(event)
local caster = event.caster
local ability = event.ability
local target = event.target
local GG = ability:GetLevelSpecialValueFor("mana", ability:GetLevel()-1)
local particle = "particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf"
target:SetMana(target:GetMana() - GG)
caster:SetMana(caster:GetMana() + GG)
ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target )
caster:EmitSound("Hero_Antimage.ManaBreak")
end