if modifier_cha_mmar == nil then modifier_cha_mmar = class({}) end

require('libraries/timers')
function modifier_cha_mmar:OnCreated(  )
	local caster = self:GetParent()
	self.state_active = false
	local timer = Timers:CreateTimer(0, function()
		if caster:GetAttackRange() > MMAR then 
			self.state_active = true 
		else 
			self.state_active = false 
		end
		return 0.5
	end)
end

function modifier_cha_mmar:RemoveOnDeath(  )
	return false
end

function modifier_cha_mmar:IsHidden(  )
	return true
end

function modifier_cha_mmar:IsPurgable(  )
	return false
end

function modifier_cha_mmar:CheckState(  )
	if self.state_active == true then 
		return { [MODIFIER_STATE_DISARMED ] = true }
	end
	return 
end