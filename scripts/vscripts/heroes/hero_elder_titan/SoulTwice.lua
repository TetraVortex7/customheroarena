if elder_titan_soul_twice == nil then elder_titan_soul_twice = class({}) end

LinkLuaModifier("modifier_elder_titan_soul_twice_hero","heroes/hero_elder_titan/SoulTwice.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elder_titan_soul_twice_illusion","heroes/hero_elder_titan/SoulTwice.lua",LUA_MODIFIER_MOTION_NONE)

function elder_titan_soul_twice:OnSpellStart(  )
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster,self,"modifier_elder_titan_soul_twice_hero",{duration = duration})
	local unit = CreateUnitByName(caster:GetName(), caster:GetAbsOrigin()+Vector(RandomInt(-120,120),RandomInt(-120,120),0), true, caster, nil, caster:GetTeam())
	local caster_level = caster:GetLevel()
		    for i = 1, caster_level - 1 do
		        unit:HeroLevelUp(false)
		    end
	unit:SetPlayerID(player_id)
    		unit:SetControllableByPlayer(player_id, true)

    		unit:SetAbilityPoints(0)
		    for ability_slot = 0, 5 do
		        local individual_ability = caster:GetAbilityByIndex(ability_slot)
		        if individual_ability then 
		            local illusion_ability = unit:SetAbilityByIndex(individual_ability,ability_slot)
		            if illusion_ability then
		                illusion_ability:SetLevel(individual_ability:GetLevel())
		            end
		        end
		    end

		    for item_slot = 0, 5 do
		        local individual_item = caster:GetItemInSlot(item_slot)
		        if individual_item then
		            local illusion_duplicate_item = CreateItem(individual_item:GetName(), unit, unit)
		            unit:AddItem(illusion_duplicate_item)
		        end
		    end

			unit:SetBaseAgility(caster_agi)
			unit:SetBaseIntellect(caster_int)
			unit:SetBaseStrength(caster_str)
			unit:SetHealth(unit:GetMaxHealth() * caster_health * 0.01)
			unit:SetMana(unit:GetMaxMana() * caster_mana * 0.01)

		    unit:AddNewModifier(caster, self, "modifier_illusion", {duration = duration + 0.6, outgoing_damage = -100, incoming_damage = self:GetSpecialValueFor("illusion_damage") - 100})
    
    		unit:MakeIllusion()
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(RandomInt(-120,120),RandomInt(-120,120),0))
	unit:AddNewModifier(caster,self,"modifier_elder_titan_soul_twice_illusion",{duration = duration})
	unit:SetModelScale(caster:GetModelScale() * 0.70)
end

if modifier_elder_titan_soul_twice_hero == nil then modifier_elder_titan_soul_twice_hero = class({}) end

function modifier_elder_titan_soul_twice_hero:GetTexture(  )
	return self:GetAbility():GetName()
end

function modifier_elder_titan_soul_twice_hero:IsPurgable(  )
	return false
end

function modifier_elder_titan_soul_twice_hero:OnCreated(  )
	local caster = self:GetCaster()
	self.prev_scale = caster:GetModelScale()
	caster:SetModelScale(caster:GetModelScale() * 1.70)
	self.id0 = ParticleManager:CreateParticle("particles/elder_titan_soul_twice_strength.vpcf",PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(self.id0, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
	self.id0 = ParticleManager:CreateParticle("particles/elder_titan_soul_twice_strength.vpcf",PATTACH_ABSORIGIN_FOLLOW, caster)
	local ability = self:GetAbility()
	local units = FindUnitsInRadius(caster:GetTeamNumber(),
                              Vector(0,0,0),
                              nil,
                              FIND_UNITS_EVERYWHERE,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	for _,unit in pairs(units) do 
		if unit:GetName() == caster:GetName() and unit:GetTeam() == caster:GetTeam() then 
			self.connected_unit = unit
		end
	end
	self.damage = ability:GetSpecialValueFor("hero_damage") - 100
end

function modifier_elder_titan_soul_twice_hero:OnDestroy(  )
	ParticleManager:DestroyParticle(self.id0,false)
end

function modifier_elder_titan_soul_twice_hero:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE}
end

function modifier_elder_titan_soul_twice_hero:CheckState(  )
	return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_ATTACK_IMMUNE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_SILENCED] = true}
end

function modifier_elder_titan_soul_twice_hero:GetModifierTotalDamageOutgoing_Percentage(  )
	return self.damage
end