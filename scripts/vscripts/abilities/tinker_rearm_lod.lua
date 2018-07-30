function rearm_start(keys)
    local caster = keys.caster
    local ability = keys.ability
    local abilityLevel = ability:GetLevel()
    ability:ApplyDataDrivenModifier(caster, caster, 'modifier_rearm_level_' .. abilityLevel .. '_datadriven', {})
end

function rearm_refresh_cooldown(keys)
    local caster = keys.caster
    
    local black_list_abilities = {
        razor_eye_of_the_storm = true,
        zuus_thundergods_wrath = true
    }

    -- Reset cooldown for abilities that is not rearm
    for i = 0, caster:GetAbilityCount() - 1 do
        local ability = caster:GetAbilityByIndex(i)
        if ability and ability ~= keys.ability and not black_list_abilities[ability] then
            local timeLeft = ability:GetCooldownTimeRemaining()
            ability:EndCooldown()
            if timeLeft > 20 then 
                ability:StartCooldown(timeLeft - 20) 
            end
        end
    end
	
    -- Put item exemption in here
    local exempt_table = {
        item_black_king_bar = true,
        item_arcane_boots = true,
        item_dominator = true,
        item_refresher = true,
        item_sphere = true,
        item_grand_magus_core = true,
        item_bottle = true,
        item_hand_of_midas_custom = true,
        item_hand_of_midas_custom_two = true,
        item_power_band = true,
		item_midas_sword = true
    }
	
    -- Reset cooldown for items
    for i = 0, 5 do
        local item = caster:GetItemInSlot(i)
        if item and not exempt_table[item:GetAbilityName()] then
            item:EndCooldown()
        end
    end
end
