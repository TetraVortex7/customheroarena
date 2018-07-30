if axe_counter_helix_custom == nil then axe_counter_helix_custom = class({}) end

LinkLuaModifier("axe_counter_helix_custom_passive","heroes/hero_axe/axe_counter_helix_custom.lua",LUA_MODIFIER_MOTION_NONE)

function axe_counter_helix_custom:GetIntrinsicModifierName(  )
	return "axe_counter_helix_custom_passive"
end


if axe_counter_helix_custom_passive == nil then axe_counter_helix_custom_passive = class({}) end

function axe_counter_helix_custom_passive:IsPurgable(  )
	return false
end

function axe_counter_helix_custom_passive:IsHidden(  )
	return true
end

function axe_counter_helix_custom_passive:RemoveOnDeath(  )
	return false
end

function axe_counter_helix_custom_passive:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function axe_counter_helix_custom_passive:OnTakeDamage( params )
	local caster = self:GetCaster()
	if params.unit == caster then
		local ability = self:GetAbility()
  		self.particle_spin_1 = "particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf"
		self.particle_spin_2 = "particles/units/heroes/hero_axe/axe_counterhelix.vpcf"

		if params.damage >= 5 and RollPercentage(ability:GetSpecialValueFor("trigger_chance")) and ability:IsCooldownReady() and params.damage and params.damage_type == DAMAGE_TYPE_PHYSICAL then

		self.helix_pfx_1 = ParticleManager:CreateParticle(self.particle_spin_1, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(self.helix_pfx_1, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.helix_pfx_1)

		self.helix_pfx_2 = ParticleManager:CreateParticle(self.particle_spin_2, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(self.helix_pfx_2, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.helix_pfx_2)

		caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
		caster:EmitSound("Hero_Axe.CounterHelix")

		caster:SetHealth(caster:GetHealth()+params.damage*ability:GetSpecialValueFor("damage_block")*0.01)
		local damage = 0;
		if caster:HasScepter() then
			damage = caster:GetAttackDamage() * ability:GetSpecialValueFor("scepter_damage") * 0.01 
		else
			damage = caster:GetAttackDamage() * ability:GetSpecialValueFor("damage") * 0.01
		end
		
		damage = damage + (damage * caster:GetIntellect() / 14) * 0.01
		
			local Units = FindUnitsInRadius(caster:GetTeamNumber(),
	                              caster:GetAbsOrigin(),
	                              nil,
	                              ability:GetSpecialValueFor("radius"),
	                              DOTA_UNIT_TARGET_TEAM_ENEMY,
	                              DOTA_UNIT_TARGET_ALL,
	                              DOTA_UNIT_TARGET_FLAG_NONE,
	                              FIND_ANY_ORDER,
	                              false)
			for _, target in pairs(Units) do
				ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability})
			end

			ability:StartCooldown(ability:GetSpecialValueFor("cooldown"))
		end
	end
end