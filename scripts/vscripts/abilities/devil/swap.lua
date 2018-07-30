require('libraries/timers')
function SwapStart(keys)
  Timers:CreateTimer(0.07, function()
  print("swapStart")
  local caster = keys.caster
  local target = keys.target
  local casterPos = caster:GetAbsOrigin()
  local targetPos = target:GetAbsOrigin()
  caster:SetAbsOrigin(targetPos)
  target:SetAbsOrigin(casterPos)
  return nil
  end)
end