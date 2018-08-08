--[[Give ability to hero via book
	Author: Tetravortex
	Date: 08.08.2018.
	]]

function AbilityCheck( keys )

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	print("SPELLBOOK")
	print(keys)
	if IsValidEntity(caster) and not caster:HasAbility("hero_poison") then
		caster:AddAbility("hero_poison")
		caster:FindAbilityByName("hero_poison"):SetLevel(1)
	end
end