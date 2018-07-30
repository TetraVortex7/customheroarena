if winter_wyvern_arctic_burn_custom == nil then winter_wyvern_arctic_burn_custom = class({}) end

LinkLuaModifier("modifier_winter_wyvern_arctic_burn_custom_active","heroes/hero_winter_wyvern/ArcticBurn.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_winter_wyvern_arctic_burn_custom_burn","heroes/hero_winter_wyvern/ArcticBurn.lua",LUA_MODIFIER_MOTION_NONE)

function winter_wyvern_arctic_burn_custom:OnSpellStart(  )
	local caster = self:GetCaster()
	self.toggled = false
	caster:AddNewModifier(caster,self,"modifier_winter_wyvern_arctic_burn_custom_active",{duration = self:GetSpecialValueFor("duration")})
end

function winter_wyvern_arctic_burn_custom:GetBehavior(  )
	if self:GetCaster():HasScepter() then return DOTA_ABILITY_BEHAVIOR_TOGGLE end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function winter_wyvern_arctic_burn_custom:GetCooldown(  )
	if self:GetCaster():HasScepter() then return 2 end
	return self:GetSpecialValueFor("cooldown")
end

function winter_wyvern_arctic_burn_custom:OnToggle(  )
	local caster = self:GetCaster()
	local toggle = self:GetToggleState()
	if toggle == true then 
	self.toggled = true
		caster:AddNewModifier(caster,self,"modifier_winter_wyvern_arctic_burn_custom_active",{})
	else
	self.toggled = false
		caster:RemoveModifierByName("modifier_winter_wyvern_arctic_burn_custom_active")
	end
end

if modifier_winter_wyvern_arctic_burn_custom_active == nil then modifier_winter_wyvern_arctic_burn_custom_active = class({}) end

function modifier_winter_wyvern_arctic_burn_custom_active:IsPurgable(  )
	return false
end

function modifier_winter_wyvern_arctic_burn_custom_active:GetTexture(  )
	return self:GetAbility():GetName()
end

function modifier_winter_wyvern_arctic_burn_custom_active:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,MODIFIER_PROPERTY_BONUS_NIGHT_VISION_UNIQUE}
end

require('libraries/timers')

function modifier_winter_wyvern_arctic_burn_custom_active:OnCreated(  )
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	self.range = ability:GetSpecialValueFor("attack_range_bonus")
	self.speed = ability:GetSpecialValueFor("projectile_speed_bonus")
	self.vision = ability:GetSpecialValueFor("night_vision_bonus")
	self.destr = ability:GetSpecialValueFor("tree_destruction_radius")
	self.duration = ability:GetSpecialValueFor("duration_damage")
	self.id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_buff.vpcf",PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(self.id0, 2, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
	local mps = ability:GetSpecialValueFor("mana_cost_scepter")
	self.timer = Timers:CreateTimer(0,function()
		if ability.toggled == true then 
			caster:SpendMana(mps,ability)
		else
			return
		end
	return 1
	end)
end

function modifier_winter_wyvern_arctic_burn_custom_active:CheckState(  )
	return {[MODIFIER_STATE_FLYING] = true}
end

function modifier_winter_wyvern_arctic_burn_custom_active:OnRefresh(  )
	local ability = self:GetAbility()
	self.range = ability:GetSpecialValueFor("attack_range_bonus")
end

function modifier_winter_wyvern_arctic_burn_custom_active:OnDestroy(  )
	local caster = self:GetCaster()
	Timers:RemoveTimer(self.timer)
	ParticleManager:DestroyParticle(self.id0, false)
	if IsClient() then ClientLoadGridNav() end
	GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), self.destr, true)
end

function modifier_winter_wyvern_arctic_burn_custom_active:GetModifierAttackRangeBonus(  )
	return self.range
end

function modifier_winter_wyvern_arctic_burn_custom_active:GetBonusNightVisionUnique(  )
	return self.vision
end

function modifier_winter_wyvern_arctic_burn_custom_active:GetModifierProjectileSpeedBonus(  )
	return self.speed
end

function modifier_winter_wyvern_arctic_burn_custom_active:OnAttackLanded( params )
	local caster = self:GetCaster()
	if params.attacker == caster then 
		local target = params.target
		local ability = self:GetAbility()
		target:AddNewModifier(caster,ability,"modifier_winter_wyvern_arctic_burn_custom_burn",{duration = self.duration})
	end
end

if modifier_winter_wyvern_arctic_burn_custom_burn == nil then modifier_winter_wyvern_arctic_burn_custom_burn = class({}) end

function modifier_winter_wyvern_arctic_burn_custom_burn:GetTexture(  )
	return self:GetAbility():GetName()
end

function modifier_winter_wyvern_arctic_burn_custom_burn:IsDebuff(  )
	return true
end

function modifier_winter_wyvern_arctic_burn_custom_burn:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_winter_wyvern_arctic_burn_custom_burn:OnCreated(  )
	local ability = self:GetAbility()
	local target = self:GetParent()
	local caster = self:GetCaster()
	local prc = ability:GetSpecialValueFor("percent_damage")
	local delay = ability:GetSpecialValueFor("tick_rate")
	self.speed = ability:GetSpecialValueFor("move_slow")
	self.timer = Timers:CreateTimer(delay-0.1, function()
		if IsServer() then 
			local health = target:GetHealth()
			local damage = health * prc * 0.01
			ApplyDamage({attacker = caster, victim = target, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		end
	return delay-0.1
	end)
	self.id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_slow.vpcf",PATTACH_ABSORIGIN_FOLLOW, target)
end

function modifier_winter_wyvern_arctic_burn_custom_burn:OnDestroy(  )
	Timers:RemoveTimer(self.timer)
	ParticleManager:DestroyParticle(self.id0,false)
end

function modifier_winter_wyvern_arctic_burn_custom_burn:GetModifierMoveSpeedBonus_Percentage(  )
	return -self.speed
end