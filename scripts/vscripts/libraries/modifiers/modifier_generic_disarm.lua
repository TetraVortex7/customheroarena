if modifier_generic_disarm == nil then modifier_generic_disarm = class({}) end

function modifier_generic_disarm:IsPurgable(  )
	return false
end

function modifier_generic_disarm:GetTexture(  )
	return self:GetAbility():GetName()
end

function modifier_generic_disarm:CheckState(  )
	return {[MODIFIER_STATE_DISARMED] = true}
end

function modifier_generic_disarm:OnCreated(  )
	local target = self:GetParent()
	self.id0 = ParticleManager:CreateParticle("particles/generic_gameplay/generic_disarm.vpcf",PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(self.id0, 0, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
end

function modifier_generic_disarm:OnDestroy(  )
	ParticleManager:DestroyParticle(self.id0,false)
end