if creeps_doom_ability_illusioness == nil then creeps_doom_ability_illusioness = class({}) end

function creeps_doom_ability_illusioness:OnSpellStart(  )    
	local caster = self:GetCaster()
    local id0 = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_illusory_orb_launch.vpcf",PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(id0, 3, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
    Timers:CreateTimer({
        endTime = self:GetSpecialValueFor("duration_invul"),
        callback = function()
        	modifier_invulnerability_on_destroy(caster,self)
            ParticleManager:DestroyParticle(id0, false)
        end
    })    
    
    caster:EmitSound("DOTA_Item.Manta.Activate")
    
    caster:Purge(false, true, false, false, false)
    
    ProjectileManager:ProjectileDodge(caster)
    
    self:CreateVisibilityNode(caster:GetAbsOrigin(), 1000, self:GetSpecialValueFor("duration_invul"))
    caster:AddNoDraw()
    caster:AddNewModifier(caster, self, "modifier_creeps_doom_ability_illusioness_invulnerability", {duration = self:GetSpecialValueFor("duration_invul")})
end

function create_illusion(caster, ability, illusion_origin)
    local caster_team = caster:GetTeam()
    local illusion_incoming_damage = ability:GetSpecialValueFor("income") - 100
    local illusion_outgoing_damage = 100 - ability:GetSpecialValueFor("outcome")
    local illusion_duration = ability:GetSpecialValueFor("duration")
    
    local illusion = CreateUnitByName(caster:GetUnitName(), illusion_origin, true, caster, nil, caster_team)

    local caster_level = caster:GetLevel()
    illusion:CreatureLevelUp(caster_level)

    for ability_slot = 0, 15 do
        local individual_ability = caster:GetAbilityByIndex(ability_slot)
        if individual_ability ~= nil then 
            local illusion_ability = illusion:FindAbilityByName(individual_ability:GetAbilityName())
            if illusion_ability ~= nil then
                illusion_ability:SetLevel(individual_ability:GetLevel())
            end
        end
    end

    for item_slot = 0, 5 do
        local individual_item = caster:GetItemInSlot(item_slot)
        if individual_item ~= nil then
            local illusion_duplicate_item = CreateItem(individual_item:GetName(), illusion, illusion)
            illusion:AddItem(illusion_duplicate_item)
        end
    end
    
    illusion:AddNewModifier(caster, ability, "modifier_illusion", {duration = illusion_duration, outgoing_damage = illusion_outgoing_damage, incoming_damage = illusion_incoming_damage})
    
    illusion:MakeIllusion()

    return illusion
end

function modifier_invulnerability_on_destroy(caster,ability)
    local caster_origin = caster:GetAbsOrigin()
    
    local illusion1_origin = caster:GetAbsOrigin() + Vector(RandomInt(-120,120),RandomInt(-120,120),0)
    local illusion2_origin = caster:GetAbsOrigin() + Vector(RandomInt(-120,120),RandomInt(-120,120),0)
    local illusion3_origin = caster:GetAbsOrigin() + Vector(RandomInt(-120,120),RandomInt(-120,120),0)

    local illusion1 = create_illusion(caster, ability, illusion1_origin)
    local illusion2 = create_illusion(caster, ability, illusion2_origin)
    local illusion3 = create_illusion(caster, ability, illusion3_origin)
    
    --Make it so all of the units are facing the same direction.
    local caster_forward_vector = caster:GetForwardVector()
    illusion1:SetForwardVector(caster_forward_vector)
    illusion2:SetForwardVector(caster_forward_vector)
    illusion3:SetForwardVector(caster_forward_vector)
    
    
    caster:RemoveNoDraw()
    
    --Set the health and mana values to those of the real hero.
    local caster_health = caster:GetHealth()
    local caster_mana = caster:GetMana()
    illusion1:SetMana(caster_mana)
    illusion2:SetMana(caster_mana)
    illusion3:SetMana(caster_mana)
    illusion1:SetHealth(caster_health)
    illusion2:SetHealth(caster_health)
    illusion3:SetHealth(caster_health)
end