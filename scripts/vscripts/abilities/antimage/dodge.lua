function is_spell_blocked_by_linkens_sphere(target)
	print("AZAZAZ")
	if target:HasModifier("modifier_item_sphere_target") then
		target:RemoveModifierByName("modifier_item_sphere_target")
		target:EmitSound("DOTA_Item.LinkensSphere.Activate")
		return true
	end
	return false
end

function item_sphere_datadriven_on_spell_start(keys)
		local kek = keys.caster
		local lel = keys.unit
		print("1:", keys.unit, "2:", keys.caster, "3:", keys.ability)
		keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_item_sphere_target", {duration = keys.Duration})
end