if modifier_true_strike == nil then modifier_true_strike = class({}) end

function modifier_true_strike:CheckState()
	local states = { [MODIFIER_STATE_CANNOT_MISS] = true }
	return states
end

function modifier_true_strike:IsHidden(  )
	return true
end