EASY_MAX_POINTS_PER_STACK = 40
SPAWN_PER_CALL_MIN = 4
SPAWN_PER_CALL_MAX = 5
RADIUS_CHECK = 500

TOTAL_EASY_SPAWN = 8
TOTAL_MED_DIR_SPAWN = 8
TOTAL_MED_RAD_SPAWN = 7

EasySpawnPos = {}
EasySpawnPoints = {}
EasySpawnTable = {EasySpawnPos,EasySpawnPoints}

MedDirSpawnPos = {}
MedDirSpawnPoints = {}
MedDirSpawnTable = {MedDirSpawnPos,MedDirSpawnPoints}

MedRadSpawnPos = {}
MedRadSpawnPoints = {}
MedRadSpawnTable = {MedRadSpawnPos,MedRadSpawnPoints}

for i = 1, TOTAL_EASY_SPAWN do 
	EasySpawnPos[i] = Entities:FindByName(nil, "easy_spawn"..i):GetAbsOrigin()
end

for i = 1, TOTAL_MED_DIR_SPAWN do 
	MedDirSpawnPos[i] = Entities:FindByName(nil, "mid_spawn_dir"..i):GetAbsOrigin()
end

for i = 1, TOTAL_MED_RAD_SPAWN do 
	MedRadSpawnPos[i] = Entities:FindByName(nil, "mid_spawn"..i):GetAbsOrigin()
end

--Creeps for easy spawn
_G.EASY_CREEPS_1 = {
	"npc_dota_neutral_giant_wolf" = 6,
	"npc_dota_neutral_wildkin" = 4,
	"npc_dota_neutral_satyr_soulstealer" = 5,
	"npc_dota_neutral_kobold" = 3,
	"npc_dota_neutral_kobold_tunneler" = 3,
	"npc_dota_neutral_kobold_taskmaster" = 5,
	"npc_dota_neutral_centaur_outrunner" = 7,
	"npc_dota_neutral_fel_beast" = 2 ,
	"npc_dota_neutral_mud_golem_split" = 2,
	"npc_dota_neutral_ogre_mauler" = 6,
	"npc_dota_neutral_ogre_magi" = 6,	
}

--Creeps for 15-end game
_G.EASY_CREEPS_2 = {
	"npc_dota_neutral_prowler_acolyte",
	"npc_dota_neutral_big_thunder_lizard",
	"npc_dota_neutral_satyr_soulstealer",
	"npc_dota_neutral_big_thunder_lizard",
	"npc_dota_neutral_black_drake",
	"npc_dota_neutral_black_dragon",
	"npc_dota_neutral_centaur_khan",
	"npc_dota_neutral_jungle_stalker",
	"npc_dota_neutral_granite_golem",
	"npc_dota_neutral_ogre_mauler",
	"npc_dota_neutral_ogre_magi",	
}

function SpawnEasyCreeps()
	for i = 1, TOTAL_EASY_SPAWN do
		if EasySpawnTable.EasySpawnPoints < EASY_MAX_POINTS_PER_STACK then
			unpack(EASY_CREEPS_1)
		end
	end
end