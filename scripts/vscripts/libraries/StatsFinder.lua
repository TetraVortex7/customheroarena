if StatsFinder == nil then
	print("[StatsFinder] Creating StatsFinder")
	StatsFinder = {}
end

function CDOTA_BaseNPC:GetIntellect(  )
	return self:GetIntellect()
end

function CDOTA_BaseNPC:GetAgility(  )
	return self:GetAgility()
end

function CDOTA_BaseNPC:GetStrength(  )
	return self:GetStrength()
end

function CDOTA_BaseNPC:GetAll(  )
	return self:GetStrength() + self:GetAgility() + self:GetIntellect()
end

function CDOTA_BaseNPC:GetMainAttribute(  )
  local hero = self
  if hero:GetPrimaryAttribute() == 0 then return hero:GetStrength() end
  if hero:GetPrimaryAttribute() == 1 then return hero:GetAgility() end
  if hero:GetPrimaryAttribute() == 2 then return hero:GetIntellect() end

  return
end

function StatsFinder:GetItemsCount( item_name, target )
  if IsServer() then
    local count = 0
    for i=0, 5 do
    if target:GetItemInSlot(i) ~= nil then
      local current_item = target:GetItemInSlot(i)
      if current_item:GetName() == item_name then
        count = count + 1
      end
      end
    end

    print(item_name.." in inventory "..count)
    return count
  end
end

function CDOTA_BaseNPC:FindItemByName(item_name)
  local target = self
  if IsServer() then
    for i=0, 5, 1 do
      if target:GetItemInSlot(i) ~= nil then
        local current_item = target:GetItemInSlot(i)
        if current_item:GetName() == item_name then
          return current_item
          --break
        end
      end
    end
  return nil
  end
end

print("[StatsFinder] StatsFinder Loaded")