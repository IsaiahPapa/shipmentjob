AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/sligwolf/forklift_truck/forklift_truck_pallet_half.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

    local tree = ents.Create( "prop_physics" )
    tree:SetModel( "models/gingerbread/gingerbread.mdl" )
    tree:SetPos( self:GetPos() + Vector(0, 0, 5) )
    tree:SetAngles( self:GetAngles() + Angle(-90,0,0))
    tree:SetParent( self )
    tree:SetModelScale(.45)
    self:DeleteOnRemove( tree )
    tree:Spawn( )

	local phys =  self:GetPhysicsObject()

	if (phys:IsValid()) then
	
		phys:Wake()
	
	end

end