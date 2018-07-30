PERCENTAGE_FULL = 0
RERCENTAGE_HALF = 0
H_ABILITY = 0
COOL_DOWN = 0
require('libraries/timers')

function RefreshPidor(keys)
  local Hability = keys.ability
  H_ABILITY = keys.ability
  local Alevel = Hability:GetLevel()
  local coolDown = Hability:GetCooldown(Alevel)
  COOL_DOWN = Hability:GetCooldown(Alevel)
  local Hcaster = keys.caster
  local RabilityName = "devil_refresh"
  if Hcaster:HasAbility(RabilityName) then
    local Rability = Hcaster:FindAbilityByName(RabilityName)
    local RabilityLevel = Rability:GetLevel()
    if RabilityLevel > 0 then
      PERCENTAGE_FULL = Rability:GetLevelSpecialValueFor("percent_full", RabilityLevel)
      PERCENTAGE_HALF = Rability:GetLevelSpecialValueFor("percent_half", RabilityLevel)
      if RollPercentage(PERCENTAGE_FULL) == true then
        Timers:CreateTimer(0.03, function()          
          H_ABILITY:EndCooldown()
          local particle = ParticleManager:CreateParticle("particles/heroes/devil/refresh/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, Hcaster)
          ParticleManager:SetParticleControl(particle, 0, Hcaster:GetAbsOrigin())
          EmitSoundOn("DOTA_Item.Refresher.Activate", Hcaster)
        end)
      elseif RollPercentage(PERCENTAGE_HALF) == true then
        Timers:CreateTimer(0.03, function()  
          local particle = ParticleManager:CreateParticle("particles/heroes/devil/refresh/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, Hcaster)
          ParticleManager:SetParticleControl(particle, 0, Hcaster:GetAbsOrigin())
          EmitSoundOn("DOTA_Item.Refresher.Activate", Hcaster)
          H_ABILITY:EndCooldown()
          H_ABILITY:StartCooldown(COOL_DOWN * 0.5)
        end)
      end
    end
  end          
end