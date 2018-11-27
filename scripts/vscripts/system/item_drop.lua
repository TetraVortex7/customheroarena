--==================SETTINGS=============================
ITEM_PER_MOB_MIN = 1
ITEM_PER_MOB_MAX = 1
ITEM_CHANCE = 20
ITEM_BOSS_CHANCE = 100
ITEM_BOSS_MIN = 2
ITEM_BOSS_MAX = 4
--==================SETTINGS=============================

--==================TABLES=================================
_G.easy_drop = { --1-10 min
	"item_slippers",
	"item_mantle",
	"item_gauntlets",
	"item_circlet",
	"item_wraith_band",
	"item_bracer",
	"item_null_talisman",
	"item_enchanted_mango",
	"item_boots",
	"item_belt_of_strength",
	"item_boots_of_elves",
	"item_robe",
	"item_gloves",
	"item_bottle",
	"item_ring_of_protection",
	"item_quelling_blade",
	"item_infused_raindrop",
	"item_blight_stone_custom",
	"item_stout_shield",
    "item_blades_of_attack",
    "item_chainmail",
	"item_wind_lace",
	"item_magic_stick",
	"item_cloak",
	"item_sobi_mask",
	"item_ring_of_regen",
	"item_ring_of_basilius",
	"item_gold_bag"
	
}

_G.middle_drop = { --10-15 min
	"item_ward_observer",
	"item_slippers",
	"item_mantle",
	"item_gauntlets",
	"item_circlet",
	"item_wraith_band",
	"item_bracer",
	"item_null_talisman",
	"item_enchanted_mango",
	"item_boots",
	"item_belt_of_strength",
	"item_boots_of_elves",
	"item_robe",
	"item_gloves",
	"item_bottle",
	"item_ring_of_protection",
	"item_quelling_blade",
	"item_infused_raindrop",
	"item_blight_stone",
	"item_stout_shield",
    "item_blades_of_attack",
    "item_chainmail",
	"item_wind_lace",
	"item_magic_stick",
	"item_cloak",
	"item_sobi_mask",
	"item_ring_of_regen",
	"item_ring_of_basilius",
	
    "item_boots",
    "item_gloves",
    "item_cloak",
    "item_lifesteal",
    "item_ghost",
    "item_blink",
    "item_shadow_amulet",
    "item_ring_of_health",
    "item_void_stone",
	"item_blades_of_attack",
	"item_chainmail",
	"item_quarterstaff",
	"item_soul_ring",
	"item_headdress",
	"item_buckler",
	"item_urn_of_shadows",
	"item_tranquil_boots"
}

_G.only_middle = {  --15-25 min
    "item_boots",
    "item_gloves",
    "item_cloak",
    "item_lifesteal",
    "item_ghost",
    "item_blink",
    "item_shadow_amulet",
    "item_ring_of_health",
    "item_void_stone",
	"item_blades_of_attack",
	"item_chainmail",
	"item_quarterstaff",
	"item_soul_ring",
	"item_ring_of_basilius",
	"item_headdress",
	"item_buckler",
	"item_urn_of_shadows",
	"item_tranquil_boots",
	"item_energy_booster",
	"item_vitality_booster",
	"item_point_booster",
	"item_platemail",
	"item_mana_stone",
	"item_stone_of_decay"
}

_G.hard_drop = {  --25-to end game
    "item_phase_boots",
    "item_hyper_glove",
    "item_cloak",
    "item_lifesteal",
    "item_ghost",
    "item_blink",
    "item_shadow_amulet",
    "item_ring_of_health",
    "item_void_stone",
	"item_blades_of_attack",
	"item_chainmail",
	"item_quarterstaff",
	"item_soul_ring",
	"item_ring_of_basilius",
    "item_headdress",
	"item_buckler",
	"item_urn_of_shadows",
	"item_tranquil_boots",
	"item_energy_booster",
	"item_vitality_booster",
	"item_point_booster",
	"item_platemail",
	
	"item_force_staff",
	"item_cyclone",
	"item_lens_c",
	"item_glimmer_cape",
	"item_blade_mail",
	"item_vanguard_c",
	"item_dragon_lance",
	"item_mask_of_madness",
	"item_sange",
	"item_yasha",
	"item_echo_sabre",
	"item_lesser_lightning",
	"item_talisman_of_evasion",
	"item_hyperstone",
	"item_ultimate_orb",
	"item_reaver",
	"item_tranquil_boots_two_active"
}

_G.boss_drop = {
"item_katana",
"item_handed_sword",
"item_heart_shard",
"item_war_axe_piece",
"item_armor_plate",
"item_power_core",
"item_stalker_coat",
"item_spell_rune"
}

_G.demonic_drop = {
	"item_demonic_rod"
}

_G.miniboss_doom_drop = {
	"item_doom_upgrade_scroll"
}

_G.miniboss_slark_drop = {
	"item_reflect_shield"
}
 
--==================TABLES================================
function ItemDrop(DeathUnit)
	if DeathUnit.disable_drop then return end
local point = DeathUnit:GetAbsOrigin()
local tm = math.floor(GameRules:GetDOTATime(false, true))
local tbl
if tm <= 600 then DropMob(point,easy_drop)  
	elseif tm > 600 and tm <= 1200 then DropMob(point,middle_drop)
	elseif tm > 1200 and tm <= 1800 then DropMob(point,only_middle)
	elseif tm > 1800 then tbl = DropMob(point,hard_drop) 
end
Timers:CreateTimer(1.0,function()
UTIL_Remove(DeathUnit) end)
end

function DropMob(point,tbl)
local d = math.random(ITEM_PER_MOB_MIN,ITEM_PER_MOB_MAX)
		for i = 1,d do
			if RollPercentage(ITEM_CHANCE) then
				LaunchItem(RollItemFromTable(tbl),point)
			end
		end
end

function DropBoss(unit)
	if unit.disable_drop then return end
local point = unit:GetAbsOrigin()
local d = math.random(ITEM_BOSS_MIN,ITEM_BOSS_MAX)
		for i = 1,d do
			if RollPercentage(ITEM_BOSS_CHANCE) then
				local item = RollItemFromTable(boss_drop)
				if item == "item_war_axe_piece" then
				LaunchItem(item,point)
				LaunchItem(item,point)
			end
			LaunchItem(item,point)
		end
	end
end

function DropDoom(unit)
	if unit.disable_drop then return end
	local point = unit:GetAbsOrigin()

	LaunchItem("item_doom_upgrade_scroll",point)
end

function DropDooms(unit)
	if unit.disable_drop then return end
	local point = unit:GetAbsOrigin()
	if RollPercentage(5) then 
		LaunchItem("item_time_scale_shard",point)
	end
end

function DropSlark(unit)
	if unit.disable_drop then return end
	local point = unit:GetAbsOrigin()

	LaunchItem("item_reflect_shield",point)
end

function DropSkorpion(unit)
	if unit.disable_drop then return end
	local point = unit:GetAbsOrigin()
			LaunchItem("item_spellbook_hero_poison",point)

		if RollPercentage(45) then
			LaunchItem("item_venom_liquid_3",point)
		end
end

function DropDemonic(unit)
	if unit.disable_drop then return end
local point = unit:GetAbsOrigin()
--local d = math.random(1,1)
	local item = ""
	item = RollItemFromTable(demonic_drop)
	LaunchItem(item,point)

	--for i = 1,1 do
		if RollPercentage(60) then
			item = "item_magic_shield"
			LaunchItem(item,point)
		end
	--end
end

function RollItemFromTable(tbl)
local item = tbl[math.random(1,#tbl)]
return item
end

function LaunchItem(itemName,point)
   	local newItem = CreateItem(itemName, nil, nil)
   	newItem:SetPurchaseTime(0)
   	local drop = CreateItemOnPositionSync( point, newItem )
   	newItem:LaunchLoot(false, 300, 0.75, point + RandomVector(RandomFloat(20, 80)))
	--newItem:SetStacksWithOtherOwners(true)
   	TimerThing(drop)
end
