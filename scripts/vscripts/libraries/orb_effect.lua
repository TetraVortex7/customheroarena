if orb_effect == nil then 
	print("[Orb Effects Library] Creating OEL")
	orb_effect = {} 
end

--[[function my_modifier:GetModifierOrbPriority()
	return DOTA_ORB_PRIORITY_ABILITY
end

function my_modifier:OnAttackLanded(event)
	if self:IsActiveOrb() then

	end
end]]

-- Все что дальше вставляем в отдельный файл и подключаем его к моду с помощью require
_G.DOTA_ORB_BLOCK = 0
_G.DOTA_ORB_PRIORITY_UNIQUE = 1
_G.DOTA_ORB_PRIORITY_ABILITY = 2
_G.DOTA_ORB_PRIORITY_ITEM_UNIQUE = 3
_G.DOTA_ORB_PRIORITY_ITEM = 4
_G.DOTA_ORB_PRIORITY_FALSE = 5
_G.DOTA_ORB_CUSTOM = 7

function CDOTA_Modifier_Lua:IsActiveOrb()
	local combinable_modifiers = {
	["modifier_skadi_custom_passive"] = {
		["modifier_demon_lifesteal_aura"] = true,
		["modifier_demonic_axe_passive"] = true,
		["modifier_lifesteal_custom_passive"] = true,
		["modifier_dominator_passive"] = true,
		["modifier_satanic_custom_passive"] = true,
		["modifier_mask_of_madness_custom_passive"] = true,
		["modifier_gauntlet_of_madness_passive"] = true,
		["modifier_gauntlet_of_madness_active"] = true
	}
}
	local uncombinable_modifiers = {
	["modifier_omnipresent_eye_passive"] = {["modifier_cursed_eye_passive"] = true},
	["modifier_doebalus_passive"] = {["modifier_big_crit_passive"] = true, ["modifier_doebalus_passive"] = true},
	["modifier_big_crit_passive"] = {["modifier_big_crit_passive"] = true, ["modifier_doebalus_passive"] = true},
	["modifier_midas_sword_gold"] = {["modifier_midas_sword_gold"] = true, ["modifier_fireblend_fire"] = true},
	["modifier_fireblend_fire"] = {["modifier_midas_sword_gold"] = true, ["modifier_fireblend_fire"] = true},
	["modifier_mana_burn_first_passive"] = {["modifier_mana_burn_first_passive"] = true, ["modifier_mana_burn_two_passive"] = true, ["modifier_suzzwke_passive"] = true},
	["modifier_mana_burn_two_passive"] = {["modifier_mana_burn_two_passive"] = true, ["modifier_suzzwke_passive"] = true, ["modifier_mana_burn_first_passive"] = true},
	["modifier_suzzwke_passive"] = {["modifier_mana_burn_two_passive"] = true, ["modifier_suzzwke_passive"] = true, ["modifier_mana_burn_first_passive"] = true}
}

	if not self:GetModifierOrbPriority() ~= 5 then
		local modifierList = self:GetParent():FindAllModifiers()
		local selfPriority = self:GetModifierOrbPriority()
		for _,modifier in pairs(modifierList) do
			if modifier.GetModifierOrbPriority then --проверяем содержит ли модификатор орб
				if modifier.GetModifierOrbPriority == DOTA_ORB_CUSTOM then 
					if uncombinable_modifiers[self[modifier]] then return false; end
					return true
				end

				if selfPriority > modifier:GetModifierOrbPriority() then --если приоритет self модификатора ниже то возвращаем false и он не сработает
					if combinable_modifiers[self[modifier]] then
						print("Combine")
						return true;
					end

					return false;
				elseif selfPriority == modifier:GetModifierOrbPriority() then --если приоритеты равны, то определяем рабочий орб по времени создания модификатора
					if self:GetCreationTime() < modifier:GetCreationTime() then
						return false;
					elseif self:GetCreationTime() == modifier:GetCreationTime() and self ~= modifier then 
						return false;
					end
				end
			end
		end
		return true;
	end
	return false;
end

print("[Orb Effects Library] OEL Loaded")