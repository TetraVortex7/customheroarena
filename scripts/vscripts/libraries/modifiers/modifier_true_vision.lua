if modifier_true_vision == nil then modifier_true_vision = class({}) end

function modifier_true_vision:CheckState()
	local states = { [MODIFIER_STATE_INVISIBLE] = false}
	return states 
end

function modifier_true_vision:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION}
end

function modifier_true_vision:GetModifierProvidesFOWVision(  )
	return 50
end

function modifier_true_vision:IsHidden(  )
	return true
end

function modifier_true_vision:IsPurgable(  )
	return false
end

function modifier_true_vision:GetPriority(  )
	return MODIFIER_PRIORITY_ULTRA
end