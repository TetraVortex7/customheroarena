-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.
-- Do not remove the GameMode:_Function calls in these events as it will mess with the internal barebones systems.

-- Cleanup a player when they leave
_G.Dooms = {
  "npc_doom_creep_e",
  "npc_doom_creep_m",
  "npc_doom_creep_h",
  "npc_doom_creep_vh"
}

require('system/item_drop')

function GameMode:OnDisconnect(event)
  DebugPrint('[BAREBONES] Player Disconnected ' .. tostring(event.userid))
  DebugPrintTable(event)
  
  local player = self.vUserIds[event.userid]

    if not player then
        return 
    end
    
    local playerID = player:GetPlayerID()
    
    for k,v in pairs(self.tPlayers) do 
        if player == v then
            table.remove(self.tPlayers,k)
        end
    end
   
    self.nPlayers = self.nPlayers - 1
    _G.TOTAL_PLAYERS = self.nPlayers
   
    local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
    if hero then
      hero:setRespawnsDisabled(true)
        HideHero(hero) --in utils.lua
    end

    if not hero:isAlive() then
      hero.RespawnTime = hero:GetTimeUntilRespawn()
    end

    if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then 
      table.remove(RADIANT_HEROES[hero])
    else 
      table.remove(DIRE_HEROES[hero])
    end
end
-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
  DebugPrint("[BAREBONES] GameRules State Changed")
  DebugPrintTable(keys)

  -- This internal handling is used to set up main barebones functions
  GameMode:_OnGameRulesStateChange(keys)

  local newState = GameRules:State_Get()
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
  --DebugPrint("[BAREBONES] NPC Spawned")

  -- This internal handling is used to set up main barebones functions
  GameMode:_OnNPCSpawned(keys)

  local npc = EntIndexToHScript(keys.entindex)
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
  --DebugPrint("[BAREBONES] Entity Hurt")
  --DebugPrintTable(keys)

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
    end
  end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
  DebugPrint( '[BAREBONES] OnItemPickedUp' )
  DebugPrintTable(keys)

  local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(event)
  DebugPrint( '[BAREBONES] OnPlayerReconnect' )
  DebugPrintTable(keys) 

  local player = self.vUserIds[event.userid]

    if not player then
        return 
    end
    
    local playerID = player:GetPlayerID()

    local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
    if hero then
      hero:setRespawnsDisabled(false)

        --HideHero(hero) --in utils.lua
    end

    if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
      if not RADIANT_HEROES[hero] then 
        table.insert(RADIANT_HEROES[hero])
      end
    else 
      if not DIRE_HEROES[hero] then 
        table.insert(DIRE_HEROES[hero])
      end
    end

    if not hero:IsAlive() then Timers:CreateTimer(hero.RespawnTime, function() hero:RespawnUnit() end) end
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
  DebugPrint( '[BAREBONES] OnItemPurchased' )
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
  DebugPrint('[BAREBONES] AbilityUsed')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
  DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
  DebugPrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
  DebugPrint('[BAREBONES] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
  DebugPrint('[BAREBONES] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
  DebugPrint('[BAREBONES] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
  DebugPrint('[BAREBONES] OnPlayerLevelUp')
  DebugPrintTable(keys)
  local player = PlayerInstanceFromIndex( keys.player )
  local hero = player:GetAssignedHero()
  local level = hero:GetLevel()
  local _playerId=hero:GetPlayerID()  
  CustomGameEventManager:Send_ServerToPlayer(player,"UpdateAbilityList", {heroName=false,playerId=_playerId})
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
  DebugPrint('[BAREBONES] OnLastHit')
  DebugPrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
  DebugPrint('[BAREBONES] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
  DebugPrint('[BAREBONES] OnRuneActivated')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune
  local hero = player:GetAssignedHero()

  if rune == DOTA_RUNE_BOUNTY then
    if PlayerResource:GetSteamAccountID(player:GetPlayerID()) == 96670086 then
      print("Developer Pickuped Bounty Rune")
      PrecacheResource( "particle_folder", "particles/gold_developers.vpcf", context )
    local id0 = ParticleManager:CreateParticle("particles/gold_developers.vpcf",
      PATTACH_ABSORIGIN_FOLLOW, hero)

    ParticleManager:SetParticleControlEnt(id0, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), false)
    end
    
    local mult = 1
      if hero:HasAbility("alchemist_goblins_greed") then mult = hero:GetNameAbility("alchemist_goblins_greed"):GetSpecialValueFor("bounty_multiplier_tooltip") else mult = mult end

      local gpm = 0.25  -- *per second
      local gold = 0

      if hero:HasItemInInventory("item_hand_of_midas_custom_two") and hero:HasItemInInventory("item_hand_of_midas_custom") then 
        local item = hero:GetItem("item_hand_of_midas_custom_two")
        local midas = item:GetSpecialValueFor("rune")
        gold = midas*mult + gpm*GameRules:GetGameTime()

        if gold >= 4200 then gold = 4200 end

        hero:ModifyGold(gold, false, 0) 
        SendOverheadEventMessage( hero,  OVERHEAD_ALERT_GOLD , hero, gold, nil )

        elseif hero:HasItemInInventory("item_hand_of_midas_custom") then  
          local item = hero:GetItem("item_hand_of_midas_custom")
          local midas = item:GetSpecialValueFor("rune")
        gold = midas*mult + gpm*GameRules:GetGameTime()

        if gold >= 3500 then gold = 3500 end

        hero:ModifyGold(gold, false, 0)
        SendOverheadEventMessage( hero,  OVERHEAD_ALERT_GOLD , hero, gold, nil )

      elseif hero:HasItemInInventory("item_hand_of_midas_custom_two") then
        local item = hero:GetItem("item_hand_of_midas_custom_two")
        local midas = item:GetSpecialValueFor("rune")
        gold = midas*mult + gpm*GameRules:GetGameTime()

        if gold >= 4200 then gold = 4200 end

        hero:ModifyGold(gold, false, 0) 
        SendOverheadEventMessage( hero,  OVERHEAD_ALERT_GOLD , hero, gold, nil )
      else
        gold = 100 * mult
        hero:ModifyGold(gold, false, 0) 
        SendOverheadEventMessage( hero,  OVERHEAD_ALERT_GOLD , hero, gold, nil )
      end
  end
  --[[ Rune Can be one of the following types
    DOTA_RUNE_DOUBLEDAMAGE
    DOTA_RUNE_HASTE
    DOTA_RUNE_HAUNTED
    DOTA_RUNE_ILLUSION
    DOTA_RUNE_INVISIBILITY
    DOTA_RUNE_BOUNTY
    DOTA_RUNE_MYSTERY
    DOTA_RUNE_RAPIER
    DOTA_RUNE_REGENERATION
    DOTA_RUNE_SPOOKY
    DOTA_RUNE_TURBO ]]
end

function GameMode:OnPlayerChat(event)
  local player = self.vUserIds[event.userid]
  local hero = player:GetAssignedHero()
  local userid = PlayerResource:GetSteamAccountID(player:GetPlayerID())
  local text = event.text

  if userid == 339110098 then
		if text == "-gold" then
		  hero:SetGold(99999,true)
		end
  

		if text == "-exp" then
		  hero:AddExperience(700000,0,false,false)
		end
	
		if text == "-safa" then
		  if hero.safa ~= true then 
			hero.ID0 = ParticleManager:CreateParticle("particles/safa_bitch.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
			hero:EmitSound("CustomHeroArena.SafaBitch")
			hero.safa_timer = Timers:CreateTimer(96, function() hero.safa = false ParticleManager:DestroyParticle(hero.ID0,false) end)
			hero.safa = true
		  end
		end

		if text == "-mute" then
		  if hero.safa == true then
			hero.safa = false
			Timers:RemoveTimer(hero.safa_timer)
			ParticleManager:DestroyParticle(hero.ID0,false)
			hero:StopSound("CustomHeroArena.SafaBitch")
		  end
		end

		if text == "-am" then
		  LinkLuaModifier("modifier_creep_grow","libraries/modifiers/modifier_creep_grow.lua",LUA_MODIFIER_MOTION_NONE)
		  hero:AddNewModifier(hero,nil,"modifier_tombstone_hp",{duration = 30})
		  hero:SetModifierStackCount("modifier_creep_grow",hero, hero:GetModifierStackCount("modifier_creep_grow",hero)+1)
		end

		if text == "-rm" then
		  print("Finding hero")
		  LinkLuaModifier("modifier_cha_invul","libraries/modifiers/modifier_cha_invul.lua",LUA_MODIFIER_MOTION_NONE)
		  for _, pl in pairs(self.vUserIds) do
			print("Attempt to remove invulnerable")
			local pl_hero = pl:GetAssignedHero()
			if pl_hero:HasModifier("modifier_cha_invul") then 
			  pl_hero:RemoveModifierByName("modifier_cha_invul") 
			  print("invulnerable removed") 
			end
		  end
		end
	end
end
-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[BAREBONES] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

function CDOTA_BaseNPC:HealCustom( heal, healer, bool_show_numbers, bool_show_illusions )
  local target = self 
      target:Heal(heal, healer)
    if bool_show_numbers and target:IsRealHero()  then
      SendOverheadEventMessage( target, OVERHEAD_ALERT_HEAL , healer, heal, nil )
    elseif not target:IsRealHero() and bool_show_illusions then 
      SendOverheadEventMessage( target, OVERHEAD_ALERT_HEAL , healer, heal, nil )
    end

    local id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
end

function CDOTA_BaseNPC:AddLevels( levels )
  if self then 
    self:AddExperience(XP_PER_LEVEL_TABLE[self:GetLevel()]-XP_PER_LEVEL_TABLE[self:GetLevel()-1-levels]+60,false,false)
  end
end

function CDOTA_BaseNPC:SplashDamage(damage, pct, damage_type, enable_illusions, attacker, radius, ability)
  local target = self
  local caster = attacker
    if caster:IsRealHero() or enable_illusions == true then
      local units = FindUnitsInRadius(caster:GetTeamNumber(),
                              target:GetAbsOrigin(),
                              nil,
                              radius,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
      for _,enemy in pairs(units) do
        if enemy == old_target then break end
        local int = caster:GetIntellect() / 12
        damage = damage + damage * int * 0.01
        if not caster:IsRealHero() and enable_illusions == false then damage = damage * 0.2 end
        ApplyDamage({victim = enemy, attacker = caster, damage = damage * pct*0.01, damage_type = damage_type,ability = ability})
        old_target = enemy
      end
    end
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
  DebugPrint('[BAREBONES] OnPlayerPickHero')
  DebugPrintTable(keys)
  self.nHeroCount = self.nHeroCount + 1
  local heroClass = keys.hero
  local hero = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
  local remaining_time = 300 - GameRules:GetGameTime()
  LinkLuaModifier("modifier_cha_invul","libraries/modifiers/modifier_cha_invul.lua",LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_cha_mmar","libraries/modifiers/modifier_cha_mmar.lua",LUA_MODIFIER_MOTION_NONE)

  if hero and player then
    if remaining_time > 0 then
      remaining_time = math.floor(remaining_time)
      hero:AddNewModifier(hero,modifier_cha_invul,"modifier_cha_invul",{duration = remaining_time}) 
    end
    if hero:GetAttackCapability() == 1 then 
      hero:AddNewModifier(hero,modifier_cha_mmar,"modifier_cha_mmar",{}) --Melee max attack range cap
    end
		
        if PlayerResource:GetSteamAccountID(player:GetPlayerID()) == 59874861 then --Aqua
          local green = 0
          local blue = 0
          local red = 0
          Timers:CreateTimer(0,function() 
              green = RandomInt(0,255)
              blue = RandomInt(0,255)
              red = RandomInt(0,255) 
               hero:SetCustomHealthLabel("ℙℝO██ǤȺᛖĖ℟", red, green, blue)
            return 0.2 
            end)  
              PrecacheResource( "particle_folder", "particles/se7en_time_h_c.vpcf", context )
              local S01 = ParticleManager:CreateParticle("particles/se7en_time_h_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
              ParticleManager:SetParticleControlEnt(S01, 1, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), false)
        end
        
    hero.ability = {} --cooldowns for duels
    hero.IsDueling = false
    hero.hidden = 0
    hero.WillBeHidden = false
    if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then 
      table.insert(RADIANT_HEROES, hero)
    end

    if hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then 
      table.insert(DIRE_HEROES, hero)     
    end

    --Talents.OnUnitCreate(hero) --Add a talents to hero
    LinkLuaModifier("modifier_respawn_time","libraries/modifiers/modifier_respawn_time.lua",LUA_MODIFIER_MOTION_NONE)
    hero:AddNewModifier(hero,nil,"modifier_respawn_time",{})

    hero:AddExperience(100,0,false,false)
  end
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
  DebugPrint('[BAREBONES] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled( keys )
  DebugPrint( '[BAREBONES] OnEntityKilled Called' )
  DebugPrintTable( keys )

    local killedUnit = EntIndexToHScript( keys.entindex_killed )
    local killer = EntIndexToHScript( keys.entindex_attacker )
  
  if killedUnit:IsNeutralUnitType() and not IsBoss(killedUnit) then ItemDrop(killedUnit) end
  if IsDoom(killedUnit) then DropDooms(killedUnit) end
  if IsBoss(killedUnit) then DropBoss(killedUnit) if not killer.bosskills then killer.bosskills = 1 else killer.bosskills = killer.bosskills + 1 end end
  if IsDemonic(killedUnit) then DropDemonic(killedUnit) end
  if IsMiniBoss(killedUnit) then DropSlark(killedUnit) end
  if IsDoomMiniBoss(killedUnit) then DropDoom(killedUnit) end
  if IsSkorpion(killedUnit) then DropSkorpion(killedUnit) end

  
  if not killedUnit:IsNeutralUnitType() and not IsBoss(killedUnit) then
    if killedUnit:IsRealHero() and not killedUnit:IsReincarnating() and killedUnit:IsHero() then  
      local hero_level = math.min(killedUnit:GetLevel(), 100)
      local respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[hero_level]
      killedUnit:SetTimeUntilRespawn(respawn_time)
    end
  end
  
  if killedUnit == HERO1 or killedUnit == HERO2 then
    if (not HERO1:IsReincarnating()) and (not HERO2:IsReincarnating()) then
      EndDuel(HERO1,HERO2)
    end
  end

  
  local killerAbility = nil
  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end
  
  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  GameMode:_OnEntityKilled( keys )
  -- Put code here to handle when an entity gets killed
end


-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function GameMode:PlayerConnect(keys)
  DebugPrint('[BAREBONES] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(event)
  DebugPrint('[BAREBONES] OnConnectFull')
  DebugPrintTable(event)
  
    local entIndex = event.index+1
    local player = EntIndexToHScript(entIndex)
    local playerID = player:GetPlayerID()
    print("playerID ",playerID)
    self.vUserIds[event.userid] = player
    player.userid = event.userid
    
    table.insert(self.tPlayers,player)
    self.nPlayers = self.nPlayers + 1 
    _G.TOTAL_PLAYERS = self.nPlayers
  
  local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())
    if hero then
        UnhideHero(hero) --in utils.lua
    end

  GameMode:_OnConnectFull(event)
  
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function GameMode:OnIllusionsCreated(keys)
  DebugPrint('[BAREBONES] OnIllusionsCreated')
  DeepPrintTable(keys)

end

-- This function is called whenever an item is combined to create a new item
function GameMode:OnItemCombined(keys)
  DebugPrint('[BAREBONES] OnItemCombined')
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local player = PlayerResource:GetPlayer(plyID)

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function GameMode:OnAbilityCastBegins(keys)
  DebugPrint('[BAREBONES] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
  DebugPrint('[BAREBONES] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function GameMode:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[BAREBONES] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function GameMode:OnNPCGoalReached(keys)
  DebugPrint('[BAREBONES] OnNPCGoalReached')
  DebugPrintTable(keys)

  local goalEntity = EntIndexToHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

function CDOTA_BaseNPC:DamageQuell( caster, ability, damage, damage_type, exclude, damage_prc ) -- exclude - table of unit names
  local target = self
  if exclude then 
    local name = target:GetUnitName()
    for _,v in pairs(exclude) do
      if name == v then print("Break") return nil; end
    end
  end
  if target:IsHero() then return end 
  if IsBoss(target) then return end
    
    damage = damage * damage_prc * 0.01 - damage
    if not caster:IsRealHero() then damage = damage * 0.75 else
      print("Damage = "..damage.." | Target: "..target:GetUnitName().." | Attacker: "..caster:GetUnitName().." | Ability: "..ability:GetName())
    end
    ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = damage_type, ability = ability})
end

function CDOTA_BaseNPC:SwapItem( item_name, upgraded_item_name, full_sell_time )
  local caster = self
  if not caster:HasItemInInventory(item_name) then return false; end
  for i=0,5 do
    local item = caster:GetItemInSlot(i)
    if item:GetName() == item_name then
      caster:RemoveItem(item)
      local item = caster:AddItem(CreateItem(upgraded_item_name,caster,caster))
      if full_sell_time then 
        item:SetPurchaseTime(full_sell_time)
      end
      break
    end
  end
end

function CDOTA_BaseNPC:ManaBurn( mana_to_burn, particle, bool_int_bonus, mana_burn_damage, mana_burn_damage_prc, ability, caster )
  local target = self
  if target:HasModifier("modifier_cha_invul") then return nil end
  local burn = mana_to_burn
  local percentage = 0 or percentage
  local int
  if bool_int_bonus then int = caster:GetIntellect() / 12 / 100 else int = 1 end
  if not caster:IsRealHero() then 
    burn = burn * 0.20 
  else
    burn = burn
  end
  
  percentage = mana_burn_damage_prc * 0.01

  local damage = burn * (percentage + int) + mana_burn_damage
  if particle and caster:IsRealHero() then
    local D01 = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(D01, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
  end
  
  if caster:IsRealHero() then 
    print("Damage "..math.floor(damage).." | Percentage bonus "..int.." | Percentage Pure "..mana_burn_damage_prc.." | Total Percentage "..percentage+int) 
  end

  target:SpendMana(burn, ability)
  ApplyDamage({victim = target,attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function GetDamageTypeFromNumber( number )
  if number == 1 then 
    return DAMAGE_TYPE_PHYSICAL
  elseif number == 2 then
    return DAMAGE_TYPE_MAGICAL
  elseif number == 4 then
    return DAMAGE_TYPE_PURE
  elseif number == 7 then
    return DAMAGE_TYPE_ALL
  elseif number == 8 then
    return DAMAGE_TYPE_HP_REMOVAL
  end
  return nil
end

function CDOTA_Modifier_Lua:GetAbilityValue( name )
  self:GetAbility():GetSpecialValueFor(name)
end

function CDOTA_BaseNPC:SwapToItem(ItemName)
    for i=0, 5, 1 do  --Fill all empty slots in the player's inventory with "dummy" items.
        local current_item = keys.caster:GetItemInSlot(i)
        if current_item == nil then
            keys.caster:AddItem(CreateItem("item_dummy", keys.caster, keys.caster))
        end
    end
    
    keys.caster:RemoveItem(keys.ability)
    keys.caster:AddItem(CreateItem(ItemName, keys.caster, keys.caster))  --This should be put into the same slot that the removed item was in.
    
    for i=0, 5, 1 do  --Remove all dummy items from the player's inventory.
        local current_item = keys.caster:GetItemInSlot(i)
        if current_item ~= nil then
            if current_item:GetName() == "item_dummy_datadriven" then
                keys.caster:RemoveItem(current_item)
            end
        end
    end
end

function CDOTA_BaseNPC:RemoveCurrentModifier( modifier )
  local caster = self
  local mod_list = caster:FindAllModifiersByName(modifier:GetName())
  for _,mod in pairs(mod_list) do 
    if mod == modifier then 
      mod:Destroy()
    end
  end
end

function CDOTA_BaseNPC:GetItem( name )
  for i = 0,5 do 
    local item = self:GetItemInSlot(i)
    if item then 
      if item:GetName() == name then
        return item;
      end
    end
  end
  return nil
end

function CDOTA_BaseNPC:GetNameAbility( name )
  for i = 0,5 do 
    local item = self:GetAbilityByIndex(i)
    if item then 
      if item:GetName() == name then
        return item;
      end
    end
  end
  return nil
end