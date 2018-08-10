function IsBoss(unit)

	if unit:GetUnitLabel() == "boss" then 
		return true 
	end
return false
end

function IsDoomMiniBoss(unit)
local name = unit:GetUnitName()
  if name == "npc_doom_creep_mb" then return true end
end

function IsDoom(unit)
local name = unit:GetUnitName()
  for k,v in pairs(Dooms) do 
    if name == v then return true end
  end
  return false
end

function IsMiniBoss(unit)
  local MiniBosses = { "npc_slark_creep_mb" }
  local name = unit:GetUnitName()
  for k,v in pairs(MiniBosses) do
    if name == v then return true end
  end
  return false
end

function IsDemonic(unit)
local name = unit:GetUnitName()
  if name == "npc_creature_top_boss" then return true end
end

function IsSkorpion(unit)
local name = unit:GetUnitName()
  if name == "npc_creature_dire_boss_normal" then return true end
end