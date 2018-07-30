_G.BOSSES = {
"npc_creature_dire_boss_loh",
"npc_creature_radiant_boss_loh",
"npc_creature_radiant_boss_normal",
"npc_creature_dire_boss_normal",
"npc_creature_top_boss",
"npc_slark_creep_mb",
"npc_doom_creep_mb"

}

function IsBoss(unit)
local name = unit:GetUnitName()
	for k,v in pairs(BOSSES) do
		if name == v then return true end
	end
	return false
end