if chen_holy_persuasion_custom == nil then chen_holy_persuasion_custom = class({}) end
LinkLuaModifier("modifier_chen_holy_persuasion_custom_health","heroes/hero_chen/chen_holy_persuasion_custom.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chen_holy_persuasion_custom_count","heroes/hero_chen/chen_holy_persuasion_custom.lua",LUA_MODIFIER_MOTION_NONE)

if modifier_chen_holy_persuasion_custom_count == nil then modifier_chen_holy_persuasion_custom_count = class({}) end
function modifier_chen_holy_persuasion_custom_count:IsHidden(  )
	return false
end
function modifier_chen_holy_persuasion_custom_count:IsPurgable(  )
	return false
end

function chen_holy_persuasion_custom:OnSpellStart(  )
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local stacks = caster:GetModifierStackCount("modifier_chen_holy_persuasion_custom_count",caster)
	if stacks <= 0 then stacks = 0 end
	print("Units dominated "..stacks)
	if stacks < self:GetSpecialValueFor("units") then
	    if target:IsAncient() then
	    	for i=0, 5 do
		        local current_item = keys.caster:GetItemInSlot(i)
		        if current_item:GetName() == "item_ultimate_scepter" and caster:FindAbilityByName("chen_hand_of_god") then
		        	print("Ancient Dominated")
		        	target:AddNewModifier(caster,self,"modifier_chen_holy_persuasion_custom_health",{duration = self:GetSpecialValueFor("duration")})
		        	target:SetTeam(caster:GetTeamNumber())
		        	target:SetControllableByPlayer(caster:GetEntityIndex() ,true)
		        end
		    end
		elseif IsBoss(target) or target:IsMagicImmune() then return
		else
			print("Dominated")
			target:AddNewModifier(caster,self,"modifier_chen_holy_persuasion_custom_health",{duration = self:GetSpecialValueFor("duration")})
			target:SetTeam(caster:GetTeamNumber())
			target:SetControllableByPlayer(caster:GetEntityIndex() ,true)
		end
	end
end

if modifier_chen_holy_persuasion_custom_health == nil then modifier_chen_holy_persuasion_custom_health = class({}) end

function modifier_chen_holy_persuasion_custom_health:GetTexture(  )
	return "chen_holy_persuasion"
end

function modifier_chen_holy_persuasion_custom_health:DeclareFunctions(  )
	return {MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS}
end

function modifier_chen_holy_persuasion_custom_health:OnCreated(  )
	local ability = self:GetAbility()
	self.hp = ability:GetSpecialValueFor("hp")
	local caster = self:GetCaster()
	local count = caster:GetModifierStackCount("modifier_chen_holy_persuasion_custom_count",caster)
	caster:SetModifierStackCount("modifier_chen_holy_persuasion_custom_count",caster,count + 1)
	print("Stacks Upd "..count)
end

function modifier_chen_holy_persuasion_custom_health:OnDestroy(  )
	self:GetParent():ForceKill(false)
	local caster = self:GetCaster()
	local count = caster:GetModifierStackCount("modifier_chen_holy_persuasion_custom_count",caster)
	caster:SetModifierStackCount("modifier_chen_holy_persuasion_custom_count",caster,count - 1)
end

function modifier_chen_holy_persuasion_custom_health:CheckState(  )
	return {[MODIFIER_STATE_DOMINATED] = true}
end

function modifier_chen_holy_persuasion_custom_health:GetModifierExtraHealthBonus(  )
	return self.hp
end

 