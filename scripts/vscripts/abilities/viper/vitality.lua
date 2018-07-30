function check(event)
local caster = event.caster
local ability = event.ability
local hp = ability:GetLevelSpecialValueFor("hp", ability:GetLevel())
local stacks = math.ceil((100 - caster:GetHealthPercent())/7)

if caster:HasModifier("modifier_vital_bonuses") then
	caster:RemoveModifierByName("modifier_vital_bonuses")
end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_vital_bonuses", {})
	caster:SetModifierStackCount("modifier_vital_bonuses", caster, stacks)
end

function atk(event)
	if event.ability:IsCooldownReady() and not event.caster:HasModifier("modifier_shoo_bonuses") then
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shoo_bonuses", {})
	ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
	end
end