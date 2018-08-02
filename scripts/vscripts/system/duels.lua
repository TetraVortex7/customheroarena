function RandomDuel()
local r = #RADIANT_HEROES
local d = #DIRE_HEROES
		if r > 0 and d > 0 and DUEL == false then
			for i=1,50 do
			HERO1 = RADIANT_HEROES[math.random(1,r)]
			HERO2 = DIRE_HEROES[math.random(1,d)]
				if IsValidEntity(HERO1) and HERO1:IsAlive() and IsValidEntity(HERO2) and HERO2:IsAlive() and HERO1.hidden == 0 and HERO2.hidden == 0 then
				break
				end
			end
		print("HERO1.hidden =",HERO1.hidden, "HERO2.hidden=",HERO2.hidden)
				if IsValidEntity(HERO1) and HERO1:IsAlive() and IsValidEntity(HERO2) and HERO2:IsAlive() then
					Duel(HERO1,HERO2) --2 hero found, starting duel
				else 
					Notifications:TopToAll({text="Not enough players for duel!", duration=5.0}) --someone not alive or not valid, show msg
					 Timers:CreateTimer(2.0, --duels after 120 sec
					function()
					  RunTimerAndStartAfter()
					  return nil -- DO NOT RERUN THIS 
					end)
					
				end
		else 
			Notifications:TopToAll({text="Not enough valid players for duel!", duration=5.0})
			RunTimerAndStartAfter()
		end
end

function RunTimerAndStartAfter() --display timer and start duel after it's ends
local count = 10 - GameMode.nHeroCount
if count < 1 then count = 1 end
local timer = 30.0 * count
CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="1x1 Duel", duration=timer, mode=0, endfade=false, position=0, warning=5, paused=false, sound=true} )
 Timers:CreateTimer(timer, 
    function()
	  RandomDuel()
      return nil -- DO NOT RERUN THIS 
    end)
end

function GetPlayersCount()
local count = 0

return count
end

function IsHeroOnDuel()  
    local point = HERO1:GetAbsOrigin() 
	local point2 = HERO2:GetAbsOrigin() 
    local flag = false
	local flag2 = false
	local dueling = HERO1.IsDueling
	local dueling2 = HERO2.IsDueling
		for _,thing in pairs(Entities:FindAllInSphere(point, 10) )  do
			if string.find(thing:GetName(), "trigger_box_duel") then
				flag = true
			end
		end
		
		for _,thing in pairs(Entities:FindAllInSphere(point2, 10) )  do
			if string.find(thing:GetName(), "trigger_box_duel") then
				flag2 = true
			end
		end

		if not flag and dueling then MoveToDuelHero(HERO1) end --если вышел, но дуэлится то вернуть
		if not flag2 and dueling2 then MoveToDuelHero(HERO2) end
end	

function MoveToDuelHero(hero)
	local ARENA_TELEPORT_COORD_LEFT = Entities:FindByName(nil, "RADIANT_DUEL_TELEPORT"):GetAbsOrigin()
	local ARENA_TELEPORT_COORD_RIGHT = Entities:FindByName(nil, "DIRE_DUEL_TELEPORT"):GetAbsOrigin()
	if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then 
    FindClearSpaceForUnit(hero, ARENA_TELEPORT_COORD_LEFT, false) 
	else
	FindClearSpaceForUnit(hero, ARENA_TELEPORT_COORD_RIGHT, false)
	end
end

function CheckFor(event)
local hero = event.activator
if IsValidEntity(hero) and hero:IsRealHero() and hero.IsDueling == false then Report(hero) end
end

function Report(hero)
local PLACE = Entities:FindByName(nil, "rejected"):GetAbsOrigin()
FindClearSpaceForUnit(hero, PLACE, false)
end

function Duel(hero1,hero2)
CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="Draw in:", duration=60, mode=0, endfade=false, position=0, warning=3, paused=false, sound=true} )
			DUEL_TIMER = 0
			DUEL = true
			SaveAbout(hero1)
			SaveAbout(hero2)
			hero1.IsDueling = true
			hero2.IsDueling = true
			--place for buffs
			--place for buffs
			local ARENA_TELEPORT_COORD_LEFT = Entities:FindByName(nil, "RADIANT_DUEL_TELEPORT"):GetAbsOrigin()
			local ARENA_TELEPORT_COORD_RIGHT = Entities:FindByName(nil, "DIRE_DUEL_TELEPORT"):GetAbsOrigin()
            hero1:Interrupt()
			hero2:Interrupt()
			AddRandomAttribute(hero1)
			AddRandomAttribute(hero2)
			hero1:Purge(false, true, false, true, false)
			hero2:Purge(false, true, false, true, false)
            FindClearSpaceForUnit(hero1, ARENA_TELEPORT_COORD_LEFT, false) 
			FindClearSpaceForUnit(hero2, ARENA_TELEPORT_COORD_RIGHT, false)
            hero1:Heal(19000,hero1)
			hero2:Heal(19000,hero2)
            hero1:GiveMana(19000)
			hero2:GiveMana(19000)
            ResetAllAbilitiesCooldown(hero1)
			ResetAllAbilitiesCooldown(hero2)
			PlayerResource:SetCameraTarget(hero1:GetPlayerID(),hero1)
			Timers:CreateTimer(0.5,function()
			PlayerResource:SetCameraTarget(hero1:GetPlayerID(),nil) end)
			
			PlayerResource:SetCameraTarget(hero2:GetPlayerID(),hero2)
			Timers:CreateTimer(0.5,function()
			PlayerResource:SetCameraTarget(hero2:GetPlayerID(),nil) end)
end

function EndDuel(hero1,hero2)
DUEL_TIMER = 0
DUEL = false
ProjectileManager:ProjectileDodge( hero1 )
ProjectileManager:ProjectileDodge( hero2 )
hero1.IsDueling = false
hero2.IsDueling = false
hero1:Interrupt()
hero2:Interrupt()
RestorePos(hero1)
RestorePos(hero2)
HERO1 = ""
HERO2 = ""
RunTimerAndStartAfter()
end

function SaveAbout(hero) --сохранить позицию, хп, ману, кдшки героя до дуэли, чтобы потом вернуть
hero.position = hero:GetAbsOrigin()
hero.mana = hero:GetMana()
hero.hp = hero:GetHealth()
hero.saved = true
local count = hero:GetAbilityCount() - 1
--GetCooldownTimeRemaining()
		for i = 0, count do
		 local ability = hero:GetAbilityByIndex(i)
		 if ability ~= nil and ability:GetLevel() == 0 then hero.ability[i] = nil 
			else
				if ability ~= nil and ability:GetLevel() > 0 and not ability:IsCooldownReady() then
					hero.ability[i] = ability:GetCooldownTimeRemaining()
		 end
		end
	end
end

function RestorePos(hero) --восстановить кдшки, хп, ману и позиция героя после дуэли
	if hero.saved and hero:IsAlive() then
		local position = hero.position
		local hp = hero.hp
		local mana = hero.mana
		hero.saved = false
		hero:SetHealth(hp)
		local count = hero:GetAbilityCount()
		hero:RemoveModifierByName("out_of_duel")
		FindClearSpaceForUnit(hero, position, false)
			for i = 0, count do
				 if hero.ability[i] ~= nil and hero.ability[i] > 0 then 
					hero:GetAbilityByIndex(i):StartCooldown(hero.ability[i])
				 end
			end
		PlayerResource:SetCameraTarget(hero:GetPlayerID(),hero)
		Timers:CreateTimer(0.2,function()
		PlayerResource:SetCameraTarget(hero:GetPlayerID(),nil) end)	
		hero:Purge(false, true, false, true, false)
		hero.position = nil
		hero.hp = nil
		hero.mana = nil
			for i = 0,5 do
				hero.ability[i] = nil
			end
	end
end

function AddRandomAttribute(hero)
local atr = 0
local rnd = math.random(1,3)
	if rnd == 1 
		then 
			atr = hero:GetStrength()
			hero:ModifyStrength(2)
		end
			
	if rnd == 2 
		then 
			atr = hero:GetAgility()
			hero:ModifyAgility(2)
		end
	
	if rnd == 3
		then
			atr = hero:GetIntellect()
			hero:ModifyIntellect(2)
	end
	hero:CalculateStatBonus()
end

function ResetAllAbilitiesCooldown(unit)
	local abilities = unit:GetAbilityCount()
	for i = 0, abilities-1 do
		local ability = unit:GetAbilityByIndex(i)
		if ability and not ability:IsCooldownReady() then
			ability:EndCooldown()
		end
	end
	for i = 0, 5 do
		local item = unit:GetItemInSlot(i)
		if item and not item:IsCooldownReady() then
			item:EndCooldown()
		end
	end
end