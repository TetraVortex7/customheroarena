function item_blink_datadriven_on_spell_start(keys)
	ProjectileManager:ProjectileDodge(keys.caster)
	
	ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_toss_impact.vpcf", PATTACH_ABSORIGIN, keys.caster)
	keys.caster:EmitSound("Hero_Tiny.CraggyExterior")
	
	local origin_point = keys.caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local difference_vector = target_point - origin_point
	
	if difference_vector:Length2D() > keys.MaxBlinkRange then 
		target_point = origin_point + (target_point - origin_point):Normalized() * keys.BlinkRangeClamp
	end
	
	keys.caster:SetAbsOrigin(target_point)
	FindClearSpaceForUnit(keys.caster, target_point, false)
end