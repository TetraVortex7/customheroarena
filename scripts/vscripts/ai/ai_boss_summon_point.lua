require( "ai/ai_core" )

-- GENERIC AI FOR SIMPLE CHASE ATTACKERS

function Spawn( entityKeyValues )
	thisEntity:SetHullRadius(0)

    LinkLuaModifier("modifier_cha_invul","libraries/modifiers/modifier_cha_invul.lua",LUA_MODIFIER_MOTION_NONE)
    thisEntity:AddNewModifier(thisEntity,modifier_cha_invul,"modifier_cha_invul",{}) 
    thisEntity:AddNoDraw()
end