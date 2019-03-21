if ( CLIENT ) then return end
util.AddNetworkString( "Nofi.Msg" )
util.AddNetworkString( "Nofi.MsgErr" )
function spawnNPCs()
    if(game.GetMap() == "rp_downtown_winter") then
    	local rhuliznpc = ents.Create( "rhuliz_npc" )
    	rhuliznpc:SetPos( Vector(-4276.017578, 3935.230957, -2569.968750) ) --Do not TOUCH
        rhuliznpc:SetAngles( Angle(-2.169203, -91.346283, 0.00000) ) --Do not TOUCH, just don't mess with none of this acutally. 
        rhuliznpc:Spawn()
        rhuliznpc:DropToFloor()
        
        local seller_npc = ents.Create( "seller_npc" )
    	seller_npc:SetPos( Vector(-7042.790039, 12400.635742, -2589.968750) ) --Do not TOUCH
        seller_npc:SetAngles( Angle(-0, -130, 0.00000) ) --Do not TOUCH, just don't mess with none of this acutally. 
        seller_npc:Spawn()
        seller_npc:DropToFloor()
    end
    if(game.GetMap() == "rp_littletown") then
        local rhuliznpc = ents.Create( "rhuliz_npc" )
        rhuliznpc:SetPos( Vector(432.045013, -865.478699, 64.031250) ) --Do not TOUCH
        rhuliznpc:SetAngles( Angle(0.000000, -90, 0.00000) ) --Do not TOUCH, just don't mess with none of this acutally. 
        rhuliznpc:Spawn()
        rhuliznpc:DropToFloor()
        
        local seller_npc = ents.Create( "seller_npc" )
        seller_npc:SetPos( Vector(-2700.904541, -2539.139404, 64.031250) ) --Do not TOUCH
        seller_npc:SetAngles( Angle(0.000000, 45, 0.00000) ) --Do not TOUCH, just don't mess with none of this acutally. 
        seller_npc:Spawn()
        seller_npc:DropToFloor()
    end
end
timer.Simple(2,spawnNPCs)