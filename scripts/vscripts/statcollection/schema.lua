customSchema = class({})

function customSchema:init()

    -- Check the schema_examples folder for different implementations

    -- Flag Example
    statCollection:setFlags({version = CHA_VERSION})

    -- Listen for changes in the current state
    ListenToGameEvent('game_rules_state_change', function(keys)
        local state = GameRules:State_Get()

        -- Send custom stats when the game ends
        if state == DOTA_GAMERULES_STATE_POST_GAME then

            -- Build game array
            local game = BuildGameArray()

            -- Build players array
            local players = BuildPlayersArray()

            -- Print the schema data to the console
            if statCollection.TESTING then
                PrintSchema(game, players)
            end

            -- Send custom stats
            if statCollection.HAS_SCHEMA then
                statCollection:sendCustom({ game = game, players = players })
            end
        end
    end, nil)
    if Convars:GetBool('developer') then
        Convars:RegisterCommand("test_schema", function() PrintSchema(BuildGameArray(), BuildPlayersArray()) end, "Test the custom schema arrays", 0)
        Convars:RegisterCommand("test_end_game", function() GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS) end, "Test the end game", 0)
    end
end

-------------------------------------

-- In the statcollection/lib/utilities.lua, you'll find many useful functions to build your schema.
-- You are also encouraged to call your custom mod-specific functions

-- Returns a table with our custom game tracking.
function BuildGameArray()
    local game = {}

    -- Add game values here as game.someValue = GetSomeGameValue()
    --game.winner = GAME_WINNER
    game.time = TIME
    return game
end

-- Returns a table containing data for every player in the game
function BuildPlayersArray()
    local players = {}
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            if not PlayerResource:IsBroadcaster(playerID) then

                local hero = PlayerResource:GetSelectedHeroEntity(playerID)
                local pl_team = hero:GetTeam()
                local hero_team = ""
                local playerboss_kills = hero.bosskills
                if not playerboss_kills then playerboss_kills = 0 end
                local hero_name = string.gsub(hero:GetName(),"npc_dota_hero_","")
                hero_name = string.gsub(hero_name,"_"," ")

                if pl_team == DOTA_TEAM_GOODGUYS then hero_team = "GoodGuys" else hero_team = "BadGuys" end
                table.insert(players, {
                    -- steamID32 required in here
                    steamID32 = PlayerResource:GetSteamAccountID(playerID),

                    -- Example functions for generic stats are defined in statcollection/lib/utilities.lua
                    -- Add player values here as someValue = GetSomePlayerValue(),
                    hn = hero_name,
                    hl = hero:GetLevel(),
                    ht = hero_team,
                    ha = hero:GetAssists(),
                    hk = hero:GetKills(),
                    hd = hero:GetDeaths(),
                    hbk = playerboss_kills,
                    hnw = GetNetworth(hero),
                    hag = math.floor(hero:GetAgility()),
                    hst = math.floor(hero:GetStrength()),
                    hin = math.floor(hero:GetIntellect()),
                    hab = hero:GetAbilityCount(),
                    hasc = hero:GetModifierStackCount("modifier_ascention_scroll_ascention",hero),
                    hgpm = math.floor(PlayerResource:GetGoldPerMin(hero:GetPlayerOwnerID())),
                    is1 = GetItemSlot(hero,0),
                    is2 = GetItemSlot(hero,1),
                    is3 = GetItemSlot(hero,2),
                    is4 = GetItemSlot(hero,3),
                    is5 = GetItemSlot(hero,4),
                    is6 = GetItemSlot(hero,5),
                    as1 = hero:GetAbilityNameInSlot(0),
                    al1 = hero:GetAbilityLevelInSlot(0),
                    as2 = hero:GetAbilityNameInSlot(1),
                    al2 = hero:GetAbilityLevelInSlot(1),
                    as3 = hero:GetAbilityNameInSlot(2),
                    al3 = hero:GetAbilityLevelInSlot(2),
                    as4 = hero:GetAbilityNameInSlot(3),
                    al4 = hero:GetAbilityLevelInSlot(3),
                    as5 = hero:GetAbilityNameInSlot(4),
                    al5 = hero:GetAbilityLevelInSlot(4),
                    as6 = hero:GetAbilityNameInSlot(5),
                    al6 = hero:GetAbilityLevelInSlot(5),
                })
            end
        end
    end

    return players
end

-- Prints the custom schema, required to get an schemaID
function PrintSchema(gameArray, playerArray)
    print("-------- GAME DATA --------")
    DeepPrintTable(gameArray)
    print("\n-------- PLAYER DATA --------")
    DeepPrintTable(playerArray)
    print("-------------------------------------")
end

-------------------------------------

-- If your gamemode is round-based, you can use statCollection:submitRound(bLastRound) at any point of your main game logic code to send a round
-- If you intend to send rounds, make sure your settings.kv has the 'HAS_ROUNDS' set to true. Each round will send the game and player arrays defined earlier
-- The round number is incremented internally, lastRound can be marked to notify that the game ended properly
function customSchema:submitRound()

    local winners = BuildRoundWinnerArray()
    local game = BuildGameArray()
    local players = BuildPlayersArray()

    statCollection:sendCustom({ game = game, players = players })
end

-- A list of players marking who won this round
function BuildRoundWinnerArray()
    local winners = {}
    local current_winner_team = GameRules.Winner or 0 --You'll need to provide your own way of determining which team won the round
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            if not PlayerResource:IsBroadcaster(playerID) then
                winners[PlayerResource:GetSteamAccountID(playerID)] = (PlayerResource:GetTeam(playerID) == current_winner_team) and 1 or 0
            end
        end
    end
    if not GameRules:IsCheatMode() then 
        return winners
    end
end

-------------------------------------
---------Custom Functions------------
-------------------------------------

function CDOTA_BaseNPC:GetAbilityNameInSlot( slot )
    local hero = self
    local ability = hero:GetAbilityByIndex(slot)
    local abilityname = ""
    if not ability then 
        abilityname = "-1"
    else
        abilityname = string.gsub(ability:GetName(),"_"," ")
    end
    return abilityname
end

function CDOTA_BaseNPC:GetAbilityLevelInSlot( slot )
    local hero = self
    local ability = hero:GetAbilityByIndex(slot)
    local abilitylevel = 0
    if not ability then 
        abilitylevel = "-1"
    else
        abilitylevel = ability:GetLevel()
    end
    return abilitylevel
end

function CDOTA_BaseNPC:GetBossKills(  )
  return self.bosskills
end

function GetItemSlot(hero, slot)
    local item = hero:GetItemInSlot(slot)
    local itemName = ""

    if item then
        itemName = string.gsub(string.gsub(item:GetAbilityName(), "item_", ""), "_", " ")
    else
        itemName = "-1"
    end

    return itemName
end