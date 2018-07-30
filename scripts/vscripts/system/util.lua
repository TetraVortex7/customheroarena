function HideHero(hero)
	if hero.hidden then 
		return
	end
	
		if hero.IsDueling == false then
				hero:Interrupt()
				hero:AddNoDraw()
				hero:AddNewModifier(hero, nil, "modifier_hide_lua", nil)
				hero.hidden = 1
				hero.abs = hero:GetAbsOrigin()
				hero:SetAbsOrigin(Vector(0,0,0))
				self.nHeroCount = self.nHeroCount - 1
			else
			hero.WillBeHidden = true
		end
	
end

function UnhideHero(hero)
	if hero.hidden == 1 then
		if not hero:IsAlive() 
			then
				hero:RespawnHero(false, false, false)
			end
		hero.WillBeHidden = false
		hero:RemoveModifierByName("modifier_hide_lua")
		hero:SetAbsOrigin(hero.abs)
		hero.hidden = 0
		FindClearSpaceForUnit(hero, hero.abs, false)
		ResolveNPCPositions(hero.abs, 64)
		hero:RemoveNoDraw()
	end

end

function GetNonLeftHeroesCountInTeam(team)
local count = 0
	if team == DOTA_TEAM_GOODGUYS then 
		for _,v in pairs(RADIANT_HEROES) do
			if v and v.hidden == 0 then count = count + 1 end
		end
	end
	
	if team == DOTA_TEAM_BADGUYS then 
		for _,v in pairs(DIRE_HEROES) do
			if v and v.hidden == 0 then count = count + 1 end
		end
	end
	
	return count
end