require('libraries/timers')

function swap( keys )
	local caster = keys.caster

	-- Swap sub_ability
	local main_ability_name = keys.ability:GetAbilityName()
	local sub_ability_name = nil
	if main_ability_name == "troll_warlord_berserkers_rage_active_c" then
		sub_ability_name = "troll_warlord_berserkers_rage_c"
	else
		sub_ability_name = "troll_warlord_berserkers_rage_active_c"
	end
	
	caster:SwapAbilities(main_ability_name, sub_ability_name, false, false)
end

---------------------------

if troll_warlord_berserkers_rage_active_c == nil then
	troll_warlord_berserkers_rage_active_c = class({})
end

LinkLuaModifier("modifier_berserkers_rage_passive","heroes/hero_troll_warlord/berserkers_rage_c.lua",LUA_MODIFIER_MOTION_NONE)

function troll_warlord_berserkers_rage_active_c:GetIntrinsicModifierName(  )
	return "modifier_berserkers_rage_passive"
end

----------------------

if modifier_berserkers_rage_passive == nil then
	modifier_berserkers_rage_passive = class({})
end

function modifier_berserkers_rage_passive:IsPurgable(  )
	return false
end

function modifier_berserkers_rage_passive:GetTexture(  )
	return	"troll_warlord_berserkers_rage_active_c"
end

function modifier_berserkers_rage_passive:DeclareFunctions(  )
	local hFuncs = { MODIFIER_EVENT_ON_TAKEDAMAGE,MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
	return hFuncs
end

function modifier_berserkers_rage_passive:OnCreated(  )
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local abilityLevel = ability:GetLevel()
	local bat_bonus = ability:GetLevelSpecialValueFor("bat",abilityLevel)

	
	local caster_bat = caster:GetBaseAttackTime()
	self.BAT = caster_bat - bat_bonus
	self.BAT_2 = caster_bat + bat_bonus
	caster:SetBaseAttackTime(self.BAT)
	self.damage = ability:GetLevelSpecialValueFor("damage",abilityLevel)
	self.hp = ability:GetLevelSpecialValueFor("hp",abilityLevel)
	self.speed = ability:GetLevelSpecialValueFor("speed",abilityLevel)
	self.atk = ability:GetLevelSpecialValueFor("atk",abilityLevel)
	self.armor = ability:GetLevelSpecialValueFor("armor",abilityLevel)
	self.chance = ability:GetLevelSpecialValueFor("chance",abilityLevel)
	self.chance_t = ability:GetLevelSpecialValueFor("chance_t",abilityLevel)

	ability:ToggleAbility()

	self.cheker = Timers:CreateTimer({0, function()
		if ability:GetToggleState() == false then
			local main_ability_name = keys.ability:GetAbilityName()
			local sub_ability_name = nil
			if main_ability_name == "troll_warlord_berserkers_rage_active_c" then
				sub_ability_name = "troll_warlord_berserkers_rage_c"
			else
				sub_ability_name = "troll_warlord_berserkers_rage_active_c"
			end
			
			caster:SwapAbilities(main_ability_name, sub_ability_name, false, true)
		end

	return 0.1
	end})
end

function modifier_berserkers_rage_passive:OnTakeDamage( event )
	if IsServer() and event.attacker ~= self:GetParent() then
		local count_damage = self.chance

		if RandomPercentage(count_damage) then
			count_damage = self.chance
			self:GetAbility():ToggleAbility()
			Timers:RemoveTimer(self.cheker)
			self:GetCaster():SetBaseAttackTime(self.BAT_2)
		else
			count_damage = count_damage + self.chance_t
		end
	end
end

function modifier_berserkers_rage_passive:GetModifierPreAttack_BonusDamage(  )
	return self.damage
end

function modifier_berserkers_rage_passive:GetModifierMoveSpeedBonus_Constant(  )
	return self.speed
end

function modifier_berserkers_rage_passive:GetModifierAttackSpeedBonus_Constant(  )
	return self.atk
end

function modifier_berserkers_rage_passive:GetModifierPhysicalArmorBonus(  )
	return self.armor
end

function modifier_berserkers_rage_passive:GetModifierHealthBonus(  )
	return self.hp
end