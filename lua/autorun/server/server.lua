local function PlayerBlockup( ply, ent )
	if (ply.Within == false and ent:GetClass() == "palletthree") then
		return false
	else
		return true
	end
end
