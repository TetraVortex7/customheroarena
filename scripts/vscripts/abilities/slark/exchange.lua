function exchange(event)
local caster = event.caster
local ability = event.ability
local amount = ability:GetLevelSpecialValueFor("amount", ability:GetLevel())
local hp = caster:GetHealth()

	if hp > amount 
		then 
			caster:SetHealth(hp - amount) 
			caster:SetMana(caster:GetMana() + amount)
		else 
			casterSetHealth(1)
	end
end