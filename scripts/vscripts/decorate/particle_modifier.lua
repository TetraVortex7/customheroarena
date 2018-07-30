if particle_modifier == nil then
	particle_modifier = class({})
end

function particle_modifier:GetAttributes(  )
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function particle_modifier:IsHidden(  )
	return true
end

function particle_modifier:GetEffectName()
	local caster = self:GetParent()
	if caster:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
		PrecacheResource(particle, "particles/econ/items/ember_spirit/ember_spirit_ashes/ember_spirit_ashes_ambient_trail.vpcf", nil)
		return "particles/econ/items/ember_spirit/ember_spirit_ashes/ember_spirit_ashes_ambient_trail.vpcf"
	else
		return nil
	end
end