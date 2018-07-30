--[[WoodChopper AI]]--

require( "ai/ai_core" )
function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThinker", AIThink, 0.25 )
	--[[thisEntity.summon = thisEntity:FindAbilityByName("woodchopper_king_perfect_summon_choppers")
	local target = AICore:HighestThreatHeroInRange( thisEntity, 900 , 15, false)
	if not target then target = AICore:WeakestEnemyHeroInRange( thisEntity, 900, false ) end
	if target then
		ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = target:entindex()
			})
	end]]
	thisEntity.prevHP = thisEntity:GetHealth()
end


function AIThink()
	local target = AICore:HighestThreatHeroInRange( thisEntity, 900 , 15, false)
	local hp = thisEntity:GetHealth()
	if not target then target = AICore:WeakestEnemyHeroInRange( thisEntity, 900, false ) end
	if not thisEntity.prevHP then thisEntity.prevHP = thisEntity:GetHealth() end
	return 0.25
end