function CheckAndDestroy()
local item_table = Entities:FindAllByClassname("dota_item_drop")
--print("total items found",#item_table)
	for k,v in pairs(item_table) do
		TimerThing(v)
	end
end

function TimerThing(newItem)
  	Timers:CreateTimer({
             	endTime = 30,
                callback = function()
                	if newItem and IsValidEntity(newItem) then
                		if not newItem:GetOwnerEntity() then 
                			UTIL_Remove(newItem)

                		end

                   	end
                    return nil
                end})

end

