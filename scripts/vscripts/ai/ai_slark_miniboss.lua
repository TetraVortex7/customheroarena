--[[WoodChopper AI]]--

require( "ai/ai_core" )
function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThinker", AIThink, 0.25 )
	thisEntity.shield = thisEntity:FindAbilityByName("creeps_slark_ability_shield")
	local target = AICore:HighestThreatHeroInRange( thisEntity, 900 , 15, false)
	if not target then target = AICore:WeakestEnemyHeroInRange( thisEntity, 900, false ) end
	if target then
		ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = target:entindex()
			})
	end
	thisEntity.prevHP = thisEntity:GetHealth()
end


function AIThink()
	local target = AICore:HighestThreatHeroInRange( thisEntity, 900 , 15, false)
	local caster = thisEntity
	if not target then target = AICore:WeakestEnemyHeroInRange( thisEntity, 900, false ) end
	if not thisEntity.prevHP then thisEntity.prevHP = thisEntity:GetHealth() end

	if caster:GetHealth() < caster:GetMaxHealth() * 0.75 and AICore:WeakestEnemyHeroInRange( thisEntity, 900, false ) then
		ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = thisEntity.shield:entindex()
				})
	end
	if target then
		ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = target:entindex()
			})
	end
	return 0.25
end