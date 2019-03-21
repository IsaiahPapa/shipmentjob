if SERVER then

function Initialize()
	if not file.IsDir("ceservers/shipment", "DATA") then
		file.CreateDir("ceservers/shipment", "DATA")
	end
end
hook.Add("Initialize", "InitializeShipData", Initialize)

function LoadPlayer( ply )
	local userDataFile = "ceservers/shipment/" .. ply:SteamID64() .. ".txt"
	if file.Exists( userDataFile, "DATA") then
		local playerData = file.Read(userDataFile, "DATA")
		ply.xp = tonumber( playerData )
	else
		file.Write(userDataFile, 0)
		ply.xp = 0
	end

	for k,v in pairs(player.GetAll()) do
		v:SetNWFloat("xp_value", v.xp)
	end

end
hook.Add("PlayerInitialSpawn", "LoadPlayerShipData", LoadPlayer)



end
