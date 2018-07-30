--================================================================================
--================================================================================
function TowerSplitAttack(keys)
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Targeting variables
	local target_type = ability:GetAbilityTargetType()
	local target_team = ability:GetAbilityTargetTeam()
	local target_flags = ability:GetAbilityTargetFlags()
	local attack_target = caster:GetAttackTarget()

	-- Ability variables
	local radius = 1300
	local max_targets = 999
	local projectile_speed = 1250
	local split_shot_projectile = keys.split_shot_projectile

	local split_shot_targets = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, radius, target_team, target_type, target_flags, FIND_CLOSEST, false)

	-- Create projectiles for units that are not the casters current attack target
	for _,v in pairs(split_shot_targets) do
		if v ~= attack_target then
			local projectile_info = 
			{
				EffectName = split_shot_projectile,
				Ability = ability,
				vSpawnOrigin = caster_location,
				Target = v,
				Source = caster,
				bHasFrontalCone = false,
				iMoveSpeed = projectile_speed,
				bReplaceExisting = false,
				bProvidesVision = true
			}
			ProjectileManager:CreateTrackingProjectile(projectile_info)
			max_targets = max_targets - 1
		end
		if max_targets == 0 then break end
	end
end
-- Apply the auto attack damage to the hit unit
function SplitShotDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local damage_table = {}
	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
	damage_table.damage = caster:GetAttackDamage()
	ApplyDamage(damage_table)
end
--================================================================================
--================================================================================
function HideCaster( event )
	ProjectileManager:ProjectileDodge(event.caster)
	event.caster:AddNoDraw()
end

function ShowCaster( event )
	event.caster:RemoveNoDraw()
end

function StopSound( event )
	StopSoundEvent( event.sound_name, event.target )
end
--================================================================================
--================================================================================
function item_blink_datadriven_on_spell_start(keys)
	ProjectileManager:ProjectileDodge(keys.caster)
	
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, keys.caster)
	keys.caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
	
	local origin_point = keys.caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local difference_vector = target_point - origin_point
	
	if difference_vector:Length2D() > keys.MaxBlinkRange then 
		target_point = origin_point + (target_point - origin_point):Normalized() * keys.BlinkRangeClamp
	end
	
	keys.caster:SetAbsOrigin(target_point)
	FindClearSpaceForUnit(keys.caster, target_point, false)
	
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, keys.caster)
end

function modifier_item_blink_datadriven_damage_cooldown_on_take_damage(keys)
	local attacker_name = keys.attacker:GetName()

	if keys.Damage > 0 and (attacker_name == "npc_dota_roshan" or keys.attacker:IsControllableByAnyPlayer()) then 
		if keys.ability:GetCooldownTimeRemaining() < keys.BlinkDamageCooldown then
			keys.ability:StartCooldown(keys.BlinkDamageCooldown)
		end
	end
end


function attack(event)
local unit = event.caster
local target = event.target

unit:MoveToTargetToAttack(target)
end

function bless(event)
local target = event.target
target:Purge(false, true, true, false, false)
end


function holybolt(event)
  local unit = event.caster
  local target = event.target
  local ability = event.ability
  local int = ability:GetLevelSpecialValueFor("int", ability:GetLevel()-1)
  local dmg = int * unit:GetIntellect() + event.coff
  local damage_table = {
    victim = target,
	attacker = unit,
	damage = dmg,
	damage_type = DAMAGE_TYPE_MAGICAL
  }
  if (unit:GetTeamNumber() == target:GetTeamNumber()) then
	local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(effect, 0, Vector(0, 0, 0))
	ParticleManager:SetParticleControl(effect, 1, Vector(180, 180, 180))
	target:Heal(dmg, unit) 
  else
	ApplyDamage(damage_table)
	local effect2 = ParticleManager:CreateParticle("particles/heroes/omni/omniknight_purification_red.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(effect2, 0, Vector(0, 0, 0))
	ParticleManager:SetParticleControl(effect2, 1, Vector(180, 180, 180))
  end
end

--=====================================================Illusionist's==========================================================
--============================================================================================================================

function invis(event)
local unit = event.caster
local target = event.target
local targets = event.target_entities
local ability = event.ability
local buff_duration = ability:GetSpecialValueFor("duration")

	for _,v in pairs(targets) do
		if v:IsIllusion() then
			ability:ApplyDataDrivenModifier(unit, v, "modifier_invis", {duration = buff_duration} )
			ability:ApplyDataDrivenModifier(unit, v, "modifier_invisible", {duration = buff_duration} )
		end
end
end

function create_illusion(keys, illusion_origin, illusion_incoming_damage, illusion_outgoing_damage, illusion_duration)	
	local player_id = keys.caster:GetPlayerID()
	local caster_team = keys.caster:GetTeam()
	
	local illusion = CreateUnitByName(keys.caster:GetUnitName(), illusion_origin, true, keys.caster, nil, caster_team)  --handle_UnitOwner needs to be nil, or else it will crash the game.
	illusion:SetPlayerID(player_id)
	illusion:SetControllableByPlayer(player_id, true)

	--Level up the illusion to the caster's level.
	local caster_level = keys.caster:GetLevel()
	for i = 1, caster_level - 1 do
		illusion:HeroLevelUp(false)
	end

	--Set the illusion's available skill points to 0 and teach it the abilities the caster has.
	illusion:SetAbilityPoints(0)
	for ability_slot = 0, 15 do
		local individual_ability = keys.caster:GetAbilityByIndex(ability_slot)
		if individual_ability ~= nil then 
			local illusion_ability = illusion:FindAbilityByName(individual_ability:GetAbilityName())
			if illusion_ability ~= nil then
				illusion_ability:SetLevel(individual_ability:GetLevel())
			end
		end
	end

	--Recreate the caster's items for the illusion.
	for item_slot = 0, 5 do
		local individual_item = keys.caster:GetItemInSlot(item_slot)
		if individual_item ~= nil then
			local illusion_duplicate_item = CreateItem(individual_item:GetName(), illusion, illusion)
			illusion:AddItem(illusion_duplicate_item)
		end
	end
	
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle 
	illusion:AddNewModifier(keys.caster, keys.ability, "modifier_illusion", {duration = 60, outgoing_damage = illusion_outgoing_damage, incoming_damage = illusion_incoming_damage})
	
	illusion:MakeIllusion()  --Without MakeIllusion(), the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.  Without it, IsIllusion() returns false and IsRealHero() returns true.

	return illusion
end

function illusionary_clone_start(keys)
	local manta_particle = ParticleManager:CreateParticle("particles/items2_fx/manta_phase.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	Timers:CreateTimer({  --Start a timer that stops the particle after a short time.
		endTime = keys.InvulnerabilityDuration, --When this timer will first execute
		callback = function()
			ParticleManager:DestroyParticle(manta_particle, false)
		end
	})
	
	keys.caster:EmitSound("DOTA_Item.Manta.Activate")
	
	--Purge(bool RemovePositiveBuffs, bool RemoveDebuffs, bool BuffsCreatedThisFrameOnly, bool RemoveStuns, bool RemoveExceptions) 
	keys.caster:Purge(false, true, false, false, false)
	
	ProjectileManager:ProjectileDodge(keys.caster)  --Disjoints disjointable incoming projectiles.
	
	--The caster is briefly made invulnerable and disappears, while ground vision is supplied nearby.
-- 	keys.ability:CreateVisibilityNode(keys.caster:GetAbsOrigin(), keys.VisionRadius, keys.InvulnerabilityDuration)
	keys.caster:AddNoDraw()
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_inv", nil)
end

function modifier_inv_on_d(keys)
	local caster_origin = keys.caster:GetAbsOrigin()
	
	--Illusions are created to the North, South, East, or West of the hero (obviously, both cannot be created in the same direction).
	local illusion1_direction = RandomInt(1, 4)	
	
	local illusion1_origin = nil

	if illusion1_direction == 1 then  --North
		illusion1_origin = caster_origin + Vector(0, 100, 0)
	elseif illusion1_direction == 2 then  --South
		illusion1_origin = caster_origin + Vector(0, -100, 0)
	elseif illusion1_direction == 3 then  --East
		illusion1_origin = caster_origin + Vector(100, 0, 0)
	else  --West
		illusion1_origin = caster_origin + Vector(-100, 0, 0)
	end
	
	
	--Create the illusions.
	local illusion1 = nil
		illusion1 = create_illusion(keys, illusion1_origin, keys.IllusionIncomingDamageMelee, keys.IllusionOutgoingDamageMelee, keys.IllusionDuration)

	
	--Reset our illusion origin variables because CreateUnitByName might have slightly changed the origin so that the unit won't be stuck.
	illusion1_origin = illusion1:GetAbsOrigin()
	
	--Make it so all of the units are facing the same direction.
	local caster_forward_vector = keys.caster:GetForwardVector()
	illusion1:SetForwardVector(caster_forward_vector)
	
	keys.caster:RemoveNoDraw()
	
	--Set the health and mana values to those of the real hero.
	local caster_health = keys.caster:GetHealth()
	local caster_mana = keys.caster:GetMana()
	illusion1:SetHealth(caster_health)
	illusion1:SetMana(caster_mana)
end

function blinke(event)
local unit = event.caster
local target = event.target
local targets = event.target_entities
local ability = event.ability
local dmg = ability:GetLevelSpecialValueFor("dmg", ability:GetLevel())
local place = target:GetAbsOrigin()

unit:MoveToTargetToAttack(target)
FindClearSpaceForUnit(event.caster, place, false)

	for _,v in pairs(targets) do
		if v:IsIllusion() then
			v:SetAbsOrigin(place)
			FindClearSpaceForUnit(v, place, false)
			v:MoveToTargetToAttack(target)
			ApplyDamage(
		{
			victim = target,
			attacker = unit,
			damage = dmg,
			damage_type = DAMAGE_TYPE_PHYSICAL
		})
		end
end
end

function pl_2(keys)
local caster_origin = keys.caster:GetAbsOrigin()
local caster = keys.caster
local ability = keys.ability
local level = ability:GetLevel() - 1
local ill_dmg = ability:GetLevelSpecialValueFor("ill_dmg", level)
local ill_take_dmg = ability:GetLevelSpecialValueFor("ill_take_dmg", level)
local duration = ability:GetLevelSpecialValueFor("ill_duration", level)

	--Illusions are created to the North, South, East, or West of the hero (obviously, both cannot be created in the same direction).
	local illusion1_direction = RandomInt(1, 2)	
	local illusion2_direction = RandomInt(3, 4)
	
	local illusion1_origin = nil
	local illusion2_origin = nil

	if illusion1_direction == 1 then  --North
		illusion1_origin = caster_origin + Vector(0, 100, 0)
	elseif illusion1_direction == 2 then  --South
		illusion1_origin = caster_origin + Vector(0, -100, 0)
		end
		
	if illusion2_direction == 3 then  --East
		illusion2_origin = caster_origin + Vector(100, 0, 0)
	else  --West
		illusion2_origin = caster_origin + Vector(-100, 0, 0)
	end
illusion1 = create_illusion(keys, illusion1_origin, nil, nil, duration)
illusion2 = create_illusion(keys, illusion2_origin, nil, nil, duration)
ability:ApplyDataDrivenModifier(caster, illusion1, "modifier_ill_buff", {})
ability:ApplyDataDrivenModifier(caster, illusion2, "modifier_ill_buff", {})
end

function summon( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local origin = caster:GetAbsOrigin() + RandomVector(100)

	-- Set the unit name, concatenated with the level number
	local unit_name = event.unit_name
	unit_name = ("kok"..level)
	--
	-- Check if the bear is alive, heals and spawns them near the caster if it is
	if caster.pet and IsValidEntity(caster.pet) and caster.pet:IsAlive() then
	    caster.pet:SetHealth(caster.pet:GetMaxHealth())
		FindClearSpaceForUnit(caster.pet,origin,false)
		ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, pet)
	else
		caster.pet = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber()) 
		if caster.pet.items == nil then caster.pet.items = {} end
		caster.pet:SetControllableByPlayer(player, true)
		EmitSoundOn("Hero_LoneDruid.SpiritBear.Cast", caster.pet)
		for i = 0, 5 do
		print("cycle")
		if caster.pet.items and caster.pet.items[i] ~= nil then caster.pet:AddItem(caster.pet.items[i]) end
		end
	end
		-- Create the unit and make it controllable

end

function savez(event)
local pet = event.caster
local player = caster:GetPlayerID()
print("items_saved")
	for i = 0, 5 do
	--if pet and pet.items then
		pet.items[i] = event.caster:GetItemInSlot(i)
	end
end

function upgrade( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local origin = caster:GetAbsOrigin() + RandomVector(100)

	-- Set the unit name, concatenated with the level number
	local unit_name
	unit_name = ("kok"..level)
	
local hp
	-- Check if the bear is alive, heals and spawns them near the caster if it is
	if caster.pet and IsValidEntity(caster.pet) and caster.pet:IsAlive() then
		hp = caster.pet:GetHealth()
	    caster.pet:RemoveSelf()
		caster.pet = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.pet:SetHealth(hp)
		caster.pet:SetControllableByPlayer(player, true)
		EmitSoundOn("Hero_LoneDruid.SpiritBear.Cast", caster.pet)
		for i = 0, 5 do
		if caster.pet.items[i] ~= nil then caster.pet:AddItem(caster.pet.items[i]) end
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.pet)
		end
	end
end

function natravit(event)
local caster = event.caster
local target = event.target
local point = target:GetAbsOrigin()

if pet and IsValidEntity(pet) and pet:IsAlive()
		then
		local part2 = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/jade_base_statue_destruction_radiant.vpcf", PATTACH_ABSORIGIN, pet)
		pet:SetAbsOrigin(point)
		FindClearSpaceForUnit(pet, point, false)
		pet:MoveToTargetToAttack(target)
		local part1 = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/jade_base_statue_destruction_radiant.vpcf", PATTACH_ABSORIGIN, target)
		
end

end

function sliyanie(event)

GER = event.caster
local target = event.target
local name = target:GetUnitName()
local ability = event.ability



if (name == "kok1") or (name == "kok2") or (name == "kok3") or (name == "kok4") then
EmitSoundOn("Hero_Beastmaster.Primal_Roar", pet)
GER:AddNoDraw()
ability:ApplyDataDrivenModifier(GER, target, "pet_pro", {duration = 30} )
ability:ApplyDataDrivenModifier(GER, GER, "untouch", {duration = 30} )
end

end

function modoff(event)
  local loc = pet:GetAbsOrigin()
  local modifierName = "untouch"
  if pet:IsAlive() then
    loc = pet:GetAbsOrigin()
  else 
    loc = GER:GetAbsOrigin()
  end
  if IsValidEntity(GER) and GER:IsAlive() then
   GER:SetAbsOrigin(loc)
   FindClearSpaceForUnit(GER, loc, false)
   GER:RemoveNoDraw()
   GER:RemoveModifierByName(modifierName)
  end
end

function pet_pro_died(keys)
  print("LOOOOH")
end

function think_intervalshadow(keys)
  keys.caster:SetAbsOrigin(pet:GetAbsOrigin())
  FindClearSpaceForUnit(keys.caster, pet:GetAbsOrigin(), false)
end

--================================================================================
--================================================================================