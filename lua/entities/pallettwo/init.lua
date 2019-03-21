AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/sligwolf/forklift_truck/forklift_truck_pallet_half.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

    local tree = ents.Create( "prop_dynamic" )
    tree:SetModel( "models/christmas_gift_boxes/christmas_gift_box_1.mdl" )
    tree:SetPos( self:GetPos() + Vector(math.Rand(0,3), math.Rand(0,2), 4.4) )
    tree:SetAngles( self:GetAngles() + Angle(0,math.Rand(360,-360),0))
    tree:SetParent( self )
    self:DeleteOnRemove( tree )
    tree:Spawn()

	local phys =  self:GetPhysicsObject()

	if (phys:IsValid()) then
	
		phys:Wake()
	
	end

	self.palletPrice = 1500

end