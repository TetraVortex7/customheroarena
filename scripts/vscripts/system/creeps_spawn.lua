--===================SETTINGS=================================
MAX_MED_PER_STACK = 11 --skolko maks v odnom spawne creepov
MAX_EASY_CREEP_STACK = 16
MAX_HARD_CREEP_STACK = 11
ADD_MIN = 3  --2skolko mojet poyavitsya minimum
ADD_MAX = 4  --4skolko za raz mojet poyavistya maximum
MAX_EZ_SPAWN_RAD = 8 --ostorojno, redaktirovat mojno tolko esli dobavit entity a to sistema na budet rabotat
MAX_HARD_SPAWN_RAD = 14
MAX_HYPA_SPAWNS = 10
MAX_MID_SPAWN_RAD = 7
MAX_MID_SPAWN_DIR = 8
MAX_BOSSES = 4
SUPA_SPAWNS = 2
RADIUS_CHECK = 500  --radius v kotorom proveryaetsya kol-vo mobov
BOSS_RADIUS_CHECK = 500
--===================SETTINGS=====================================
--[[
"BoundsHullName"            "DOTA_HULL_SIZE_SMALL"
]]
--==================TABLES WITH CREEPS============================
--EZ RADIANT SPOTS
_G.RADIANT_EZ = {
"npc_dota_neutral_giant_wolf",
"npc_dota_neutral_wildkin",
"npc_dota_neutral_satyr_soulstealer",
"npc_dota_neutral_kobold",
"npc_dota_neutral_kobold_tunneler",
"npc_dota_neutral_kobold_taskmaster",
"npc_dota_neutral_centaur_outrunner",
"npc_dota_neutral_fel_beast",
"npc_dota_neutral_mud_golem",
"npc_dota_neutral_mud_golem_split",
"npc_dota_neutral_ogre_mauler",
"npc_dota_neutral_ogre_magi",
"npc_slark_creep_e"
}

_G.RADIANT_HARD = {
"npc_slark_creep_h",
"npc_slark_creep_vh"
}

_G.RADIANT_MID = {
"Ursa_level_1",
"Ursa_level_5",
"Ursa_level_10"
}

_G.DIRE_MID = {
"Wildwing_level_1",
"Wildwing_level_5",
"Wildwing_level_10"
}

_G.DIRE_HARD = {
"npc_doom_creep_e",
"npc_doom_creep_m"
}

_G.DIRE_HARD2 = {
"npc_doom_creep_h",
"npc_doom_creep_vh"
}
--==================TABLES WITH CREEPS============================

--==================FUNCTIONS DO NOT CHANGE=====================================
function GetRandomMonsterFromTable(TABLE)
local d = #TABLE
return TABLE[math.random(d)]
end

function CheckMobCount(point)
local b = Entities:FindAllByClassnameWithin("npc_dota_creep_neutral", point,RADIUS_CHECK)
return #b
end

function CheckBossCount(point)
local b = Entities:FindAllByClassnameWithin("npc_dota_creature", point,BOSS_RADIUS_CHECK)
return #b
end

function CheckSlarksCount(point)
local b = Entities:FindAllByClassnameWithin("npc_dota_creature", point,RADIUS_CHECK)
return #b
end

function EzSpawns()
  for i=1,MAX_EZ_SPAWN_RAD do
	  local gg = "easy_spawn"..i
	  local point = Entities:FindByName(nil, gg):GetAbsOrigin()
	  if CheckMobCount(point) < MAX_EASY_CREEP_STACK then 
		  for i=1,math.random(ADD_MIN,ADD_MAX) do
			local dd = CreateUnitByName(GetRandomMonsterFromTable(RADIANT_EZ), point, true, nil, nil, DOTA_TEAM_NEUTRALS)
			--AddGrow(dd)
		  end
	  end
  end
end
function MidSpawnRad()
  for i=1,MAX_MID_SPAWN_RAD do
	  local gg = "mid_spawn"..i
	  local point = Entities:FindByName(nil, gg):GetAbsOrigin()
	  if CheckMobCount(point) < MAX_MED_PER_STACK then 
		  for i=1,math.random(ADD_MIN,ADD_MAX) do
			local dd = CreateUnitByName(GetRandomMonsterFromTable(RADIANT_MID), point, true, nil, nil, DOTA_TEAM_NEUTRALS)
			--AddGrow(dd)
		  end
	  end
  end
end

function MidSpawnDir()
  for i=1,MAX_MID_SPAWN_DIR do
	  local gg = "mid_spawn_dir"..i
	  local point = Entities:FindByName(nil, gg):GetAbsOrigin()
	  if CheckMobCount(point) < MAX_MED_PER_STACK then 
		  for i=1,math.random(ADD_MIN,ADD_MAX) do
			local dd = CreateUnitByName(GetRandomMonsterFromTable(DIRE_MID), point, true, nil, nil, DOTA_TEAM_NEUTRALS)
			--AddGrow(dd)
		  end
	  end
  end
end

function HardSpawnsRad()
  for i=1,MAX_HARD_SPAWN_RAD do
	  local gg = "hard_spawn"..i
	  local point = Entities:FindByName(nil, gg):GetAbsOrigin()
	  if CheckSlarksCount(point) < MAX_HARD_CREEP_STACK then 
		  for i=1,math.random(ADD_MIN,ADD_MAX) do
			local dd = CreateUnitByName(GetRandomMonsterFromTable(RADIANT_HARD), point, true, nil, nil, DOTA_TEAM_NEUTRALS)
			--AddGrow(dd)
		  end
	  end
  end
end

function HypaSpawns()
  for i=1,MAX_HYPA_SPAWNS do
   local gg = "hypa_spawn"..i
   local point = Entities:FindByName(nil, gg):GetAbsOrigin()
   if CheckSlarksCount(point) < MAX_HARD_CREEP_STACK then 
    for i=1,math.random(ADD_MIN,ADD_MAX) do
		local dd = CreateUnitByName(GetRandomMonsterFromTable(DIRE_HARD), point, true, nil, nil, DOTA_TEAM_NEUTRALS)
		--AddGrow(dd)
    end
   end
  end
end

function HypaSpawns2()
  for i=7,10 do
   local gg = "hypa_spawn"..i
   local point = Entities:FindByName(nil, gg):GetAbsOrigin()
   if CheckSlarksCount(point) < MAX_HARD_CREEP_STACK then 
    for i=1,math.random(ADD_MIN,ADD_MAX) do
		local dd = CreateUnitByName(GetRandomMonsterFromTable(DIRE_HARD2), point, true, nil, nil, DOTA_TEAM_NEUTRALS)
		--AddGrow(dd)
    end
   end
  end
end

function BossSpawns()
	  local gg = "easy_boss_spawn_dir"
	  local point = Entities:FindByName(nil, gg):GetAbsOrigin()
	  if CheckBossCount(point) < 1 then 
		local loh =	CreateUnitByName("npc_creature_radiant_boss_loh", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
	  end
	  
	  local dd = "mid_boss_spawn_dir"
	  local poent = Entities:FindByName(nil, dd):GetAbsOrigin()
	  if CheckBossCount(poent) < 1 then 
		local loh =	CreateUnitByName("npc_creature_radiant_boss_normal", poent, true, nil, nil, DOTA_TEAM_NEUTRALS)
	  end
	  
	  local ss = "easy_boss_spawn_rad"
	  local pnt = Entities:FindByName(nil, ss):GetAbsOrigin()
	  if CheckBossCount(pnt) < 1 then 
		local loh =	CreateUnitByName("npc_creature_dire_boss_loh", pnt, true, nil, nil, DOTA_TEAM_NEUTRALS)
	  end
	  
	  local vv = "mid_boss_spawn_rad" 
	  local BB = Entities:FindByName(nil, vv):GetAbsOrigin()
	  if CheckBossCount(BB) < 1 then 
		local loh =	CreateUnitByName("npc_creature_dire_boss_normal", BB, true, nil, nil, DOTA_TEAM_NEUTRALS)
	  end
	  
	  local VV = "top_boss_spawn" 
	  local NN = Entities:FindByName(nil, VV):GetAbsOrigin()
	  if CheckBossCount(NN) < 1 then 
		local loh =	CreateUnitByName("npc_creature_top_boss", NN, true, nil, nil, DOTA_TEAM_NEUTRALS)
	  end
	  
	  local VV = "hard_spawn_boss" 
	  local NN = Entities:FindByName(nil, VV):GetAbsOrigin()
	  if CheckBossCount(NN) < 1 then 
		local loh =	CreateUnitByName("npc_slark_creep_mb", NN, true, nil, nil, DOTA_TEAM_NEUTRALS)
	  end
	  
	  local VV = "npc_doom_boss_spawn" 
	  local NN = Entities:FindByName(nil, VV):GetAbsOrigin()
	  if CheckBossCount(NN) < 1 then 
		local loh =	CreateUnitByName("npc_doom_creep_mb", NN, true, nil, nil, DOTA_TEAM_NEUTRALS)
	  end
end

function Spawn()
EzSpawns()
MidSpawnRad()
MidSpawnDir()
HardSpawnsRad()
HypaSpawns()
HypaSpawns2()
end

function SpawnOnce()
	--CreateUnitByName("npc_base", CORD_RAD, false, nil, nil, DOTA_TEAM_GOODGUYS)
	--CreateUnitByName("npc_base", CORD_DIRE, false, nil, nil, DOTA_TEAM_BADGUYS)
end

--[[function AddGrow(unit)
unit:AddNewModifier(unit, nil, "modifier_creep_grow", nil)
local modifier_stack_count = math.floor(TIME / 60)
unit:SetModifierStackCount("modifier_creep_grow", nil, modifier_stack_count)
end]]