function check(event)
if event.ability:IsCooldownReady() then
	local caster = event.caster
		if caster:GetHealthPercent() < 35 and caster:HasAbility("templar_assassin_refraction")  then 
			local abc = caster:FindAbilityByName("templar_assassin_refraction")
			caster:Purge(false, true, false, true, true)
			if caster:GetMana() < 100 then caster:SetMana(100) end
			if abc:IsCooldownReady() 
				then 
				caster:CastAbilityNoTarget(abc,-1) 
					else 
					abc:EndCooldown()
					caster:CastAbilityNoTarget(abc,-1) 
			event.ability:StartCooldown(event.ability:GetCooldown(event.ability:GetLevel()))
			end
			
		end
end
end