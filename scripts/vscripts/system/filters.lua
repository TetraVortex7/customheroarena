function GameMode:DamageFilter(event)
local damagetype = event.damagetype_const
local attackerIndex = event["entindex_attacker_const"]
local attacker = EntIndexToHScript(attackerIndex)
local victim = EntIndexToHScript(event.entindex_victim_const)
local entindex_inflictor_const = event.entindex_inflictor_const
local ability = nil
local boosted = false --boosted by any damage sources (Now sanctum regnum)

if entindex_inflictor_const then ability = EntIndexToHScript(entindex_inflictor_const) end
	if victim:HasModifier("modifier_cha_invul") then
		if attacker == victim or attacker:GetName() == "ent_dota_fountain" then return true; end
		if GetTeamName(attacker:GetTeamNumber()) ~= "Neutrals" then return end
	end
	if not attacker:HasModifier("modifier_cha_invul_duel") and victim:HasModifier("modifier_cha_invul_duel") then return end

	if victim:IsAlive() and victim:IsRealHero() and (victim:HasItemInInventory("item_stalker_coat") or victim:HasItemInInventory("item_manteau_invis")) and damagetype == "DAMAGE_TYPE_MAGICAL" then
		event.damage = event.damage / 4
	end
	if victim ~= attacker and victim:IsAlive() and not victim:IsRealHero() and not IsBoss(victim) and damagetype == 2 then 
		
		if attacker:HasItemInInventory("item_solomon_book") then
			event.damage = event.damage * 2
			boosted = true
		end
		if attacker:HasItemInInventory("item_solomon_book_2") and not boosted then
			event.damage = event.damage * 3
			boosted = true
		end
		if attacker:HasItemInInventory("item_solomon_book_3") and not boosted then
			event.damage = event.damage * 4
			boosted = true
		end
	end
	


	if victim ~= attacker and victim:IsAlive() and attacker:IsRealHero() and attacker:HasItemInInventory("item_aether_lens_5") and ability and not ability:IsItem() then
		local count = StatsFinder:GetItemsCount("item_aether_lens_5", attacker)
		if count <= 0 then return end
		local chance = 15 * count
		if chance > 45 then chance = 45 end
		local mult = 165 * 0.01
		if RollPercentage(chance) then
			event.damage = event.damage * mult
			local numbers = string.len(tostring(math.floor(event.damage))) + 1
			victim:EmitSound("Hero_Ancient_Apparition.ColdFeetFreeze")
			local visual = math.floor(event.damage)
			
			local id0 = ParticleManager:CreateParticle("particles/msg_damage.vpcf",PATTACH_ABSORIGIN, victim)
			ParticleManager:SetParticleControl(id0, 1, Vector(10,visual,4))
			ParticleManager:SetParticleControl(id0, 2, Vector(1,numbers,0))
			ParticleManager:SetParticleControl(id0, 3, Vector(160,60,255))
		end
	end

	if victim ~= attacker and victim:IsAlive() and attacker:IsRealHero() and ability and 
		(attacker:HasItemInInventory("item_aghanim_core") or attacker:HasItemInInventory("item_grand_magus_core")) then
		for i=0,5,1 do
			local item = attacker:GetItemInSlot(i)
			if item then
				if item:GetName() == "item_aghanim_core" or "item_grand_magus_core" then
					local heal = 0
					local prc_hero = 30
					local prc_creep = 10
					if not victim:IsHero() then 
						heal = event.damage * prc_creep * 0.01 
					else 
						heal = event.damage * prc_hero * 0.01 
					end
					attacker:HealCustom(heal,attacker,false,false)
					break
				end
			end
		end
	end
	return true
end

function GameMode:GoldFilter(event)
	--print("gold filter")
	--print(event.player_id_const)
	--print(PlayerResource:GetConnectionState(event.player_id_const))
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.player_id_const),"UpdatePlayerAbilityList", {playerId=event.player_id_const})
	return true
end


function GameMode:ExecuteFilter(event)
	return true
end