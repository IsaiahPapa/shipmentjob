AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	
	self:SetModel("models/sligwolf/forklift_truck/forklift_truck_pallet.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

    local tree = ents.Create( "prop_dynamic" )
    tree:SetModel( "models/unconid/xmas/xmas_tree.mdl" )
    tree:SetPos( self:GetPos() + Vector(0,0,5) )
    tree:SetAngles( self:GetAngles())
    tree:SetParent( self )
    self:DeleteOnRemove( tree )
    tree:Spawn( )

	local phys =  self:GetPhysicsObject()

	if (phys:IsValid()) then
	
		phys:Wake()
	
	end
	//self:NetworkVar("Entity", 0, "owning_ent")
	self.palletPrice = 6000
end