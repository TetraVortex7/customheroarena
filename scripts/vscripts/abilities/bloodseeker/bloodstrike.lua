function bloodstrike(event)
local heroez = HeroList:GetAllHeroes()
DebugPrintTable(heroez)
local caster = event.caster
local ability = event.ability
local lvl = ability:GetLevel() - 1
print("lvl after -1", lvl)
local particle = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf"
local HpCap = ability:GetLevelSpecialValueFor("health", ability:GetLevel())
local strikes = ability:GetLevelSpecialValueFor("strikes", ability:GetLevel())

ability:ApplyDataDrivenModifier(caster, caster, "modifier_blood_unmiss", {})

	for k,v in pairs(heroez) do
		if IsValidEntity(v) and caster:GetTeam() ~= v:GetTeam() then 
		print(v:GetUnitName())
		caster:PerformAttack(v, true, true, true, false, false) 
		ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, v )
		end
	end
	
caster:RemoveModifierByName("modifier_blood_unmiss")
end
