AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/player/breen.mdl")
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
		umsg.Start("sellmenu", Caller) 
		umsg.End() 
	end
end

if SERVER then 

-- RP_LITTLETOWN Vector(-2949.568604, -2074.177490, 0),
-- RP_LITTLETOWN Vector(-2604.468994, -2251.681885, 75.250000)
-- RP_DOWNTOWN_WINTER	Vector(-8041.542480, 11202.790039, -1978.967773),
-- RP_DOWNTOWN_WINTER	Vector(-7397.666992, 11852.084961, -2701.169434),
local region = {
	Vector(-2949.568604, -2074.177490, 0),
	Vector(-2604.468994, -2251.681885, 75.250000)
}


util.AddNetworkString( "Sell.Pallet" )
util.AddNetworkString( "pallet_sold" )

function setSold(ply)
    ply.Sold = false
end
hook.Add( "PlayerInitialSpawn", "set_sold", setSold )

function setWithin(ply)
    ply.Within = false
end
hook.Add( "PlayerInitialSpawn", "set_within", setWithin )

IdRemove = nil

net.Receive( "Sell.Pallet",function( len, ply ) 
	OrderVectors(region[1],region[2])
	local pallet = {}
	pallet = ents.FindInBox(region[1],region[2])
	if (!ply.sold && ply.hasPallet) then
		for i = 1, #pallet do
		    if (pallet[i]:GetClass() == "pallettwo") then
		    	IdRemove = pallet[i]
		    	palletPrice = IdRemove.palletPrice
		    	ply.Within = true
		    end
		    if (pallet[i]:GetClass() == "palletthree") then
		    	IdRemove = pallet[i]
		    	palletPrice = IdRemove.palletPrice
		    	ply.Within = true
		    else
		end
	    --else false... make sure to

	end
-- if getclass is == palletone then ply.xp = ply.xp + .25
-- if getclass is == pallettwo then ply.xp = ply.xp + .3
		if(ply.Within) then

			if(IdRemove:CPPIGetOwner() == ply) then
			
			ply:addMoney(palletPrice)

			xp = ply:GetNWFloat("xp_value")
			xp = xp + math.Rand(0.05, 0.3)
			ply:SetNWFloat("xp_value", xp)
			local userDataFile = "ceservers/shipment/" .. ply:SteamID64() .. ".txt"
			file.Write(userDataFile, xp)
			ply.Within = false
			ply.hasPallet = false
			ply.Sold = true

			IdRemove:Remove()

			net.Start("Nofi.Msg")
			net.WriteString("Pallet sold for: $".. palletPrice .."")
	        net.Send(ply)

			elseif(IdRemove:CPPIGetOwner() != ply) then
				net.Start("Nofi.MsgErr")
	        	net.WriteString("You can't sell someone else's pallet!")
	        	net.Send(ply)
			end
		else
			net.Start("Nofi.MsgErr")
	        net.WriteString("No pallet in region!")
	        net.Send(ply)
		end
	else
		net.Start("Nofi.MsgErr")
	    net.WriteString("You need to go get a pallet!")
	    net.Send(ply)
	end 


end)

end
  