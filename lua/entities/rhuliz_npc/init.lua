AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/player/gman_high.mdl")
	self:SetUseType(SIMPLE_USE)
	self:SetMoveType(MOVETYPE_NONE)
	self:DrawShadow(true)
	self:SetSolid(SOLID_BBOX)
	self:PhysicsInit(SOLID_BBOX)

	self.receivers = {}

	local physObj = self:GetPhysicsObject()

	if (IsValid(physObj)) then
		physObj:EnableMotion(false)
		physObj:Sleep()
	end
end
function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
		umsg.Start("elfmenu", Caller) 
		umsg.End() 
	end
end

if SERVER then 
	util.AddNetworkString( "Rhuliz.Location" )
	util.AddNetworkString( "Rhuliz.Pallet" )
	util.AddNetworkString( "Rhuliz.Fork" )
	util.AddNetworkString( "Rhuliz.Return")
	function setPallet(ply)
	    ply.hasPallet = false
	end
	hook.Add( "PlayerInitialSpawn", "set_pallet_value", setPallet )

	function setFork(ply)
	    ply.hasFork = false
	end
	hook.Add( "PlayerInitialSpawn", "set_fork_value", setFork )

	function setView(ply)
	    ply.hasView = false
	end
	hook.Add( "PlayerInitialSpawn", "set_if_view", setView )

	hook.Add( "PlayerSay", "callTest", function( ply, text, public )
		if ( string.lower( text ) == "!test" ) then
			net.Start( "Rhuliz.Location" )
			net.Send( ply )
		end
	end )

	if(game.GetMap() == "rp_downtown_winter") then
		palletSpawn = Vector(-4022.023193, 3730.810059, -2569.968750)
		vehSpawnPos = Vector(-4350.990234, 3594.931152, -2575.968750)
		vehSpawnAng = Angle(0,0,0)
	end
	if(game.GetMap() == "rp_littletown") then
		palletSpawn = Vector(585.111572, -966.327393, 64.031250)
		vehSpawnPos = Vector(338.321045, -1077.433838, 60.031250)
		vehSpawnAng = Angle(0,-180,0)
	end



	net.Receive( "Rhuliz.Pallet",function( len, ply ) 
--[[
	
	-- THIS IS FOR TRYING TO PREVENT PLAYERS GRAVGUNNING IT TO THE DELEVERY LOCATION

	local outReg = {
		Vector(-5171.968750, 1924.160034, -2569.968750),
		Vector(-9389.769531, 7630.996582, -1906.913818)
	}
	OrderVectors(outReg[1],outReg[2])
	local entOut = {}
	entOut = ents.FindInBox(outReg[1],outReg[2])
	if (!ply.sold && ply.hasPallet) then
		for i = 1, #entOut do
		    if (entOut[i]:GetClass() == "pallettwo") then
		    	outside = entOut[i]
		    	ply.outside = true
		    end
		    if (entOut[i]:GetClass() == "palletthree") then
		    	outside = entOut[i]
		    	ply.outside = true
		    end
		end
	end

	if (ply.outside == true) then
		DropEntityIfHeld(entOut)
	end
--]]
		local pallet1 = ents.Create("pallettwo")
		local pallet2 = ents.Create("palletthree")
		local pallet3 = ents.Create("palletfour")
		local pallet4 = ents.Create("palletone")


		if (!ply.hasPallet) then
			--[[
			pallet1:SetPos(Vector(-4022.023193, 3730.810059, -2569.968750))
		    pallet1:SetAngles( Angle(0,90,0))
		    pallet1:CPPISetOwner(ply)
		    pallet1:Spawn()
		    --creationID = ent:GetCreationID()
		    ply.hasPallet = true
	        net.Start("Nofi.Msg")
	        net.WriteString("Please look to your right".. data.level)
	        net.Send(ply)
			--]]
			if(ply:GetNWFloat("xp_value") <= .99) then 
				pallet1:SetPos(palletSpawn)
			    pallet1:SetAngles( Angle(0,90,0))
			    pallet1:CPPISetOwner(ply)
			    pallet1:Spawn()
			    --creationID = ent:GetCreationID()
			    ply.hasPallet = true
		        net.Start("Nofi.Msg")
		        net.WriteString("Please look to your right")
		        net.Send(ply)
		    elseif(ply:GetNWFloat("xp_value") >= 1 and ply:GetNWFloat("xp_value") <= 1.99) then
				pallet2:SetPos(palletSpawn)
			    pallet2:SetAngles( Angle(0,90,0))
			    pallet2:CPPISetOwner(ply)
			    pallet2:Spawn()
			    --creationID = ent:GetCreationID()
			    ply.hasPallet = true
		        net.Start("Nofi.Msg")
		        net.WriteString("Please look to your right")
		        net.Send(ply)
		    elseif(ply:GetNWFloat("xp_value") >= 2 and ply:GetNWFloat("xp_value") <= 2.99) then
				pallet3:SetPos(palletSpawn)
			    pallet3:SetAngles( Angle(0,90,0))
			    pallet3:CPPISetOwner(ply)
			    pallet3:Spawn()
			    --creationID = ent:GetCreationID()
			    ply.hasPallet = true
		        net.Start("Nofi.Msg")
		        net.WriteString("Please look to your right")
		        net.Send(ply)
		    elseif(ply:GetNWFloat("xp_value") >= 3) then
				pallet4:SetPos(palletSpawn)
			    pallet4:SetAngles( Angle(0,90,0))
			    pallet4:CPPISetOwner(ply)
			    pallet4:Spawn()
			    --creationID = ent:GetCreationID()
			    ply.hasPallet = true
		        net.Start("Nofi.Msg")
		        net.WriteString("Please look to your right")
		        net.Send(ply)
		    end
		    --]]
		else
			net.Start("Nofi.MsgErr")
		    net.WriteString("You already have a pallet out! Go find it!")
		    net.Send(ply)
		end  

		if(ply.hasPallet and ply.hasFork and ply.hasView == false) then
			net.Start("Rhuliz.Location")
			net.Send(ply)
			ply.hasView = true
			org = ply:GetPos()
			timer.Simple(1, function()
				ply:SetPos(Vector(-2560.435303, -2681.050049, 64.031250))
				ply:SetNoDraw(true)
				timer.Simple(4,
					function()
						ply:SetPos(org)
						ply:SetNoDraw(false)
					end)
			end)
		end
	end)

	net.Receive( "Rhuliz.Fork",function( len, ply ) 

	    if(!ply.hasFork) then
	    	local vehicle
			for class, vehi in pairs(list.Get("Vehicles")) do if class == "sw_forklift_truck" then vehicle = vehi break end end
			if not vehicle then return end
			local model = vehicle.Model
			local script = vehicle.KeyValues.vehiclescript
			local fork = ents.Create("prop_vehicle_jeep")
			fork:SetModel(model)
			fork:SetKeyValue("vehiclescript", script)
			fork:SetPos( vehSpawnPos )
			fork:SetRenderMode( RENDERMODE_TRANSALPHA )
			fork:SetAngles(vehSpawnAng)
			fork:SetCollisionGroup(COLLISION_GROUP_VEHICLE)
			fork:addKeysDoorOwner(ply)
			fork:Spawn()
			fork:Activate()
			fork.VehicleTable = vehicle -- Retrieve the infos of the vehicle and put it into the correct table before running the hook.
			hook.Run("PlayerSpawnedVehicle", ply, fork) -- Run the hook.
		    ply.hasFork = true
		    ply.spawnedB4 = true
	        net.Start("Nofi.Msg")
	        net.WriteString("Spawn Successful.")
	        net.WriteString("Please look to your left.")
	        net.Send(ply)
		else
			net.Start("Nofi.MsgErr")
		    net.WriteString("You already have a Forklift out! Return it!")
		    net.Send(ply)
		end  
		if(ply.hasPallet and ply.hasFork and ply.hasView == false) then
			--net.Start("Rhuliz.Location")
			--net.Send(ply)
			ply.hasView = true
			org = plyGetPos()
			timer.Simple(1, function()
				ply:SetPos(Vector(-2560.435303, -2681.050049, 64.031250))
				ply:SetNoDraw(true)
				timer.Simple(4,
					function()
						ply:SetPos(org)
						ply:SetNoDraw(false)
					end)
			end)
			
		end
	end)

--RP_LITTLETOWN setpos -140.281830 -922.718018 207.655472
--RP_LITTELTOWN setpos 1040.107788 -1222.532959 36.396545
--RP_DOWNTOWN_WINTER		Vector(-4819.025879, 3399.979736, -2841.562988),
--RP_DOWNTOWN_WINTER		Vector(-3744.839111, 4147.657715, -2182.107178)

	local regionReturn = {
		Vector(1316.572266, -2391.662598, -136.841537),
		Vector(-502.165405, -888.448425, 550.938354)
	}

	net.Receive( "Rhuliz.Return", function( len, ply )

		OrderVectors(regionReturn[1],regionReturn[2])
		local returns = {}
		returns = ents.FindInBox(regionReturn[1],regionReturn[2])
		for i = 1, #returns do
		    if (returns[i]:GetClass() == "prop_vehicle_jeep") then
		    	print(returns[i])
		    	RemoveThing = returns[i]
		    	Within = true
		    end
		end

		if(Within) then
			ply.hasFork = false
			RemoveThing:Remove()
			net.Start("Nofi.Msg")
			net.WriteString("Vehicle Successfuly Returned")
	        net.Send(ply)
		end

	end)

end