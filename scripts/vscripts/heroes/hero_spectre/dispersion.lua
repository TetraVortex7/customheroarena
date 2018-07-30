if spectre_dispersion_custom == nil then spectre_dispersion_custom = class({}) end

LinkLuaModifier("modifier_spectre_dispersion_custom_passive","heroes/hero_spectre/dispersion.lua",LUA_MODIFIER_MOTION_NONE)

function spectre_dispersion_custom:GetIntrinsicModifierName(  )
	return "modifier_spectre_dispersion_custom_passive"
end

if modifier_spectre_dispersion_custom_passive == nil then modifier_spectre_dispersion_custom_passive = class({}) end

function modifier_spectre_dispersion_custom_passive:IsHidden(  )
	return true
end

function modifier_spectre_dispersion_custom_passive:IsPurgable(  )
	return false
end

function modifier_spectre_dispersion_custom_passive:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_spectre_dispersion_custom_passive:GetModifierIncomingPhysicalDamage_Percentage(  )
	return -self:GetAbility():GetSpecialValueFor("reduce")
end

function modifier_spectre_dispersion_custom_passive:OnTakeDamage( params )
	local caster = self:GetCaster()
	if params.unit == caster and params.attacker ~= caster then
		local ability = self:GetAbility()
		local disp = self.disp
		local dis = ability:GetSpecialValueFor("prc")
		local dis_c = ability:GetSpecialValueFor("c_prc")	
		if IsBoss(params.attacker) then disp = dis_c else disp = dis end
		local damage = params.damage * disp * 0.01
		local Units = FindUnitsInRadius(caster:GetTeamNumber(),
                              caster:GetAbsOrigin(),
                              nil,
                              ability:GetSpecialValueFor("max_range"),
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
		for _,unit in pairs(Units) do
			local dist = (caster:GetAbsOrigin()-unit:GetAbsOrigin()):Length2D()
			if dist > ability:GetSpecialValueFor("min_range") then 
				damage = damage * ((1300 - dist) / 1000)
				print("Damage = "..damage.."\nDist = "..dist.."\nDamage * distance = "..(params.damage * disp * 0.01) * dist * 0.001)
				local id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_dispersion.vpcf",PATTACH_POINT_FOLLOW, unit)
				ParticleManager:SetParticleControlEnt(id0, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
				ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL,ability = ability})
			end
		end
	end
end