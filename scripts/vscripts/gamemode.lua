BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

require('libraries/timers')
require('libraries/physics')
require('libraries/projectiles')
require('libraries/notifications')
require('libraries/animations')
require('libraries/attachments')
require('libraries/abilities_cost')
require('libraries/orb_effect')
require('libraries/constants')
require('libraries/StatsFinder')
require("statcollection/init")

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')
require('settings')
require('events')

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
	PrecacheUnitByNameAsync("npc_creature_dire_boss_loh", function(...) end)
	PrecacheUnitByNameAsync("npc_creature_radiant_boss_loh", function(...) end)
	PrecacheUnitByNameAsync("npc_creature_radiant_boss_normal", function(...) end)
	PrecacheUnitByNameAsync("npc_creature_dire_boss_normal", function(...) end)
	PrecacheUnitByNameAsync("npc_creature_top_boss", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())
  hero:SetGold(1000, false)
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")
  Timers:CreateTimer(5.0, -- Start after game begun
    function()
      DebugPrint("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
	  Spawn()
      return 45.0 -- Rerun 30 sec because of spawn creeps
    end)
	  
	  Timers:CreateTimer(360.0,
    function()
      DebugPrint("Boss Spawned")
	  BossSpawns()
      return 360.0 -- Boss spawn 6 min 
    end)
	
		  Timers:CreateTimer(1.0,
    function()
	SpawnOnce()
      return nil -- 
    end)
		
	  Timers:CreateTimer(300.0, --duel draw counter
    function()
		if DUEL == true 
			then 
				DUEL_TIMER = DUEL_TIMER + 1 
				IsHeroOnDuel() 
		end
		
		if DUEL_TIMER > 60 and DUEL == true 
			then 
				EndDuel(HERO1,HERO2) 
				Notifications:TopToAll({text="Duel draw!", duration=5.0})
		end
		
      return 1.0 -- Rerun this timer every 1 game-time seconds 
    end)
	
		  Timers:CreateTimer(300.0, 
    function()
		RunTimerAndStartAfter()
      return nil  
    end)
	
		Timers:CreateTimer(1.0, 
		function()
		_G.TIME = math.floor(GameRules:GetDOTATime(false,false))
      return 1.0  
    end)	

    Timers:CreateTimer({endTime = 180, callback = function()
      CreateUnitByName(npc_creature_woodchopper_king_boss, Vector(220,620,421), true, nil, nil, DOTA_TEAM_NEUTRALS)
     return
    end})


  RadBase = CreateUnitByName("npc_base", Entities:FindByName(nil,"npc_base1"):GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
  DireBase = CreateUnitByName("npc_base", Entities:FindByName(nil,"npc_base2"):GetAbsOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS)
  RadBase:AddNoDraw()
  DireBase:AddNoDraw()
end



-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self

  self.vUserIds = {}
  self.tPlayers = {}
  self.nPlayers = 0
  self.nHeroCount = 0

  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')
  ListenToGameEvent('player_chat', Dynamic_Wrap(GameMode, 'OnPlayerChat'), self)
  GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
  GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode, "GoldFilter"), self)
  GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "ExecuteFilter"), self)
  CustomGameEventManager:RegisterListener("glyph_clicked", Dynamic_Wrap(GameMode, "GlyphClick"))
  GameMode:_InitGameMode()
  	
	self.HeroesKV = LoadKeyValues("scripts/kv/spell_shop_ui_herolist.txt")
    self.AbilitiesKV = LoadKeyValues("scripts/kv/spell_shop_ui_abilities.txt")
    self.AbilitiesCostKV = LoadKeyValues("scripts/kv/spell_shop_ui_abilities_cost.txt")
	self:CreateNetTablesSettings()
    self:HeroListRefill()
    CustomGameEventManager:RegisterListener("AddAbility", Dynamic_Wrap(GameMode, 'AddAbility'))
    CustomGameEventManager:RegisterListener("RemoveAbility", Dynamic_Wrap(GameMode, 'RemoveAbility'))	
  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

function GameMode:CreateNetTablesSettings()
	print("CreatedNetTableSettings")
    -- Hero pool
    for group, heroes in pairs( self.HeroesKV ) do
        CustomNetTables:SetTableValue( "heroes", group, heroes )
    end
    -- Abilities 
    for heroName, abilityKV in pairs( self.AbilitiesKV ) do
        CustomNetTables:SetTableValue( "abilities", heroName, abilityKV )
    end
    for abilityName, abilityCost in pairs(self.AbilitiesCostKV) do
        CustomNetTables:SetTableValue ("abilitiesCost", abilityName, {tonumber(abilityCost)})
    end
end