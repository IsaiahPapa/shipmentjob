ENT.Base = "base_ai" 
ENT.Type = "ai" 
ENT.AutomaticFrameAdvance = true 

ENT.PrintName = "Rhuliz The Elf"

ENT.Category        = "CEServers"
ENT.Author			= "Clix"
ENT.Contact			= "Don't"
ENT.Purpose			= "Rhuliz The Elf"
ENT.Instructions	= "Use with care. Always handle with gloves."

ENT.Spawnable = true 

ENT.Type = "anim"
ENT.PhysgunDisable = true
ENT.PhysgunDisabled = true

function ENT:setAnim()
	for k, v in ipairs(self:GetSequenceList()) do
		if (v:lower():find("idle") and v != "idlenoise") then
			return self:ResetSequence(k)
		end
	end

	self:ResetSequence(4)
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Quest")
end