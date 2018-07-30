if medusa_mana_shield_custom == nil then medusa_mana_shield_custom = class({}) end

LinkLuaModifier("modifier_medusa_mana_shield_custom_absorb","heroes/hero_medusa/medusa_mana_shield_custom.lua",LUA_MODIFIER_MOTION_NONE)

function medusa_mana_shield_custom:OnToggle(  )
	local toggle = self:GetToggleState()
	local caster = self:GetCaster()
	local ability = self
	if ability == nil then return end
	if toggle then
		if not caster:HasModifier("modifier_medusa_mana_shield_custom_absorb") then
			caster:AddNewModifier(caster,ability,"modifier_medusa_mana_shield_custom_absorb",{})
		end
	else
		caster:RemoveModifierByName("modifier_medusa_mana_shield_custom_absorb")
	end
end

if modifier_medusa_mana_shield_custom_absorb == nil then modifier_medusa_mana_shield_custom_absorb = class({}) end

function modifier_medusa_mana_shield_custom_absorb:GetTexture(  )
	return "medusa_mana_shield"
end

function modifier_medusa_mana_shield_custom_absorb:IsPurgable(  )
	return false
end

function modifier_medusa_mana_shield_custom_absorb:OnCreated(  )
	self.ID0 = ParticleManager:CreateParticle("particles/econ/items/medusa/medusa_daughters/medusa_daughters_mana_shield.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetCaster())
	EmitSoundOn("Hero_Medusa.ManaShield.On",self:GetCaster())
end

function modifier_medusa_mana_shield_custom_absorb:OnDestroy(  )
	EmitSoundOn("Hero_Medusa.ManaShield.Off",self:GetCaster())
	ParticleManager:DestroyParticle(self.ID0, false)
end

function modifier_medusa_mana_shield_custom_absorb:DeclareFunctions(  )
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_medusa_mana_shield_custom_absorb:OnTakeDamage( params )
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	EmitSoundOn("Hero_Medusa.ManaShield.Proc",self:GetCaster())

	if ability == nil then caster:RemoveModifierByName("modifier_medusa_mana_shield_custom_absorb") end

	local absorb = ability:GetSpecialValueFor("absorb") / 100
	local int = caster:GetIntellect() / 100 / 12

	if IsBoss(params.attacker) then absorb = ability:GetSpecialValueFor("b_absorb") / 100 else absorb = ability:GetSpecialValueFor("absorb") / 100 end

	
	if params.unit == caster then

	local prev_hp = prev_hp or caster:GetHealth()
	local mpd = ability:GetSpecialValueFor("mpd")
	absorb = absorb + 1 * int * 0.01
	if absorb >= 0.9 then absorb = 0.9 end
	local damage = params.damage - params.damage * absorb
	print("DAMAGE ".. damage.." | ABSORB "..absorb.." | INCREASE ".. int)

		local mana = caster:GetMana() - (damage * mpd)
		local heal = math.floor(damage)
		mana = math.floor(mana)
		if prev_hp - (params.damage - damage) >= 1 then

			if caster:GetMana() >= (damage * mpd) * 1.17 then
				
				print("MANA "..mana.." | HEAL "..heal)
				caster:Heal(heal, caster)
				caster:SetMana(mana)
			else
				ability:ToggleAbility()
				ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
			end
		end
		prev_hp = caster:GetHealth()
	end
end