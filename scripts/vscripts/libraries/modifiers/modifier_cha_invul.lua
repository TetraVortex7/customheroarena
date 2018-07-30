if modifier_cha_invul == nil then modifier_cha_invul = class({}) end

function modifier_cha_invul:GetTexture()
	return "item_doom_upgrade_scroll"
end

function modifier_cha_invul:IsPurgable(  )
	return false
end

function modifier_cha_invul:RemoveOnDeath(  )
	return false
end

function modifier_cha_invul:GetAttributes(  )
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if modifier_cha_invul_duel == nil then modifier_cha_invul_duel = class({}) end

function modifier_cha_invul_duel:GetTexture()
	return "item_doom_upgrade_scroll"
end

function modifier_cha_invul_duel:IsPurgable(  )
	return false
end

function modifier_cha_invul_duel:RemoveOnDeath(  )
	return false
end

function modifier_cha_invul_duel:GetAttributes(  )
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end