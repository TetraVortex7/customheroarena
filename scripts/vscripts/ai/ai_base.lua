@@ -1,32 +0,0 @@
require( "ai/ai_core" )
require('libraries/isboss')
-- GENERIC AI FOR SIMPLE CHASE ATTACKERS

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThinker", AIThink, 0.25 )
	thisEntity.aura = thisEntity:FindAbilityByName("npc_base_heal")
	thisEntity.vision = thisEntity:FindAbilityByName("necronomicon_warrior_sight")
	thisEntity.immune = thisEntity:FindAbilityByName("neutral_spell_immunity")
	thisEntity:SetHullRadius(190)
	local target = AICore:NearestEnemyHeroInRange( thisEntity, 1150 , false)
	if target then 
		thisEntity:PerformAttack(target,true,true,true,true,true)
	end
end


function AIThink()
	local target = AICore:NearestEnemyHeroInRange( thisEntity, 1150, false)
	
	if target and not IsBoss(target) then 
		thisEntity:PerformAttack(target,true,true,true,true,true,false,true)
		if target:GetLevel() > 30 then
			thisEntity:PerformAttack(target,true,true,true,true,true,false,true)
			thisEntity:PerformAttack(target,true,true,true,true,true,false,true)
			thisEntity:PerformAttack(target,true,true,true,true,true,false,true)
			thisEntity:PerformAttack(target,true,true,true,true,true,false,true)
			thisEntity:PerformAttack(target,true,true,true,true,true,false,true)	
		end
	end
	return 0.25
end