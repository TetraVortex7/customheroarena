--[[WoodChopper AI]]--

require( "ai/ai_core" )
function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThinker", AIThink, 0.25 )
	thisEntity.mana_steal = thisEntity:FindAbilityByName("creeps_doom_ability_mana_steal")
	thisEntity.illusioness = thisEntity:FindAbilityByName("creeps_doom_ability_illusioness")
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
	local hp = thisEntity:GetHealth()
	local caster = thisEntity
	if not target then target = AICore:WeakestEnemyHeroInRange( thisEntity, 900, false ) end
	if not thisEntity.prevHP then thisEntity.prevHP = thisEntity:GetHealth() end

	if target and thisEntity.illusioness:IsCooldownReady() and thisEntity:GetMana() <= thisEntity.illusioness:GetManaCost(thisEntity.illusioness:GetLevel()) then
		ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = thisEntity.mana_steal:entindex()
				})
	end

	if target and thisEntity.illusioness:IsCooldownReady() and thisEntity:GetMana() > thisEntity.illusioness:GetManaCost(thisEntity.illusioness:GetLevel()) then 
		ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = thisEntity.illusioness:entindex()
				})
	end
	return 0.25
end