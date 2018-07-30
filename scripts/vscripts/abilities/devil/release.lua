function OnSpellStart(keys)
	EmitSoundOn("Hero_Nevermore.RequiemOfSouls", keys.caster)
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local target_table = keys.target_entities
	local ability = keys.ability
	local Alevel = ability:GetLevel()
	local damage = ability:GetLevelSpecialValueFor("damage", Alevel)
	for k, unit in pairs(target_table) do
		local damage_table = {
          victim = unit,
          attacker = keys.caster,
          damage = damage,
          damage_type = DAMAGE_TYPE_MAGICAL
        }
		local Podkop = ParticleManager:CreateParticle("particles/heroes/devil/devil_release.vpcf", PATTACH_ABSORIGIN, keys.caster)
		local unitPos = unit:GetAbsOrigin()
		ParticleManager:SetParticleControl(Podkop, 1, unitPos)
		ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_ABSORIGIN, unit)
		ApplyDamage(damage_table)
	end
	ParticleManager:CreateParticle("particles/heroes/devil/test_6.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:CreateParticle("particles/heroes/devil/nevermore__blink.vpcf", PATTACH_ABSORIGIN, keys.caster)
	
	caster:Stop()
end

function OnSpellPhaseStart(keys)
  EmitSoundOn("Hero_Nevermore.RequiemOfSoulsCast", keys.caster)
  ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_wings_soul_channel.vpcf", PATTACH_ABSORIGIN, keys.caster)
end