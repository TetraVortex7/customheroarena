if modifier_passives_disabled == nil then modifier_passives_disabled = class({}) end

function modifier_passives_disabled:CheckState(  )
	return {[MODIFIER_STATE_PASSIVES_DISABLED] = true}
end

function modifier_passives_disabled:IsHidden(  )
	return true
end

function modifier_passives_disabled:IsPurgable(  )
	return false
end