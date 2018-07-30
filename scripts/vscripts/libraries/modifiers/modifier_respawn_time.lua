if modifier_respawn_time == nil then modifier_respawn_time = class({}) end

function modifier_respawn_time:IsHidden(  )
	return true
end

function modifier_respawn_time:IsPurgable(  )
	return false
end

function modifier_respawn_time:RemoveOnDeath(  )
	return false
end

function modifier_respawn_time:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_RESPAWNTIME}
end

function modifier_respawn_time:GetModifierConstantRespawnTime(  )
	local lvl = self:GetParent():GetLevel()
	local time = lvl * 0.1
	return -(lvl - time)
end