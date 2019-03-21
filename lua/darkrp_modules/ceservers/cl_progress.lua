function xpBar(ply, oldteam, newteam)
	if (newteam == TEAM_SHIPMENT) then
		local drawn = true

		local blur = Material("pp/blurscreen")
		local function DrawBlur(panel, amount)
			local x, y = panel:LocalToScreen(0, 0)
			local scrW, scrH = ScrW(), ScrH()
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(blur)
			for i = 1, 3 do
				blur:SetFloat("$blur", (i / 3) * (amount or 6))
				blur:Recompute()
				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
			end
		end
		surface.CreateFont( "ProgText", {
			font = "Fredoka One", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
			antialias = true,
			size = 30,
			weight = 0,
			shadow = true,
		} )
		local getXP = LocalPlayer():GetNWFloat("xp_value") * 100

		timer.Create("refreshXP",5,0,function()
			getXP = LocalPlayer():GetNWFloat("xp_value") * 100
		end)

		local w = ScrW() / 2
		local h = ScrH() / 2

		Back = vgui.Create( "DPanel" )
		Back.Paint = function( self, w, h )
			DrawBlur(self, 6)
			draw.RoundedBox( 0, 0, 0, 400, 45, Color( 0, 0, 0, 105) )
		end
		Back:SetSize( 400, 45 )
		Back:SetPos(w-210, 10)
		Back:IsDraggable(false)


		Text = vgui.Create( "DPanel" )
		Text.Paint = function( self, w, h )
			draw.SimpleText( "XP: ", "ProgText", w-377, 19, {r=255,g=255,b=255,a=255}, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		Text:SetSize( 575, 45 )
		Text:SetPos(w-430, 10)
		Text:IsDraggable(false)

		Bar = vgui.Create( "DPanel" )
		Bar.Paint = function( self, w, h )
			draw.RoundedBox(0, w-200, 20, (getXP/400)*400, 25, {r=0,g=128,b=0,a=150})
		end
		Bar:SetSize( 300, 45 )
		Bar:SetPos(w-310, 0)
		Bar:IsDraggable(false)

		Prog1 = vgui.Create( "DPanel" )	
		Prog1.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, 2.5, 45, Color(0, 172, 238, 255))
		end
		Prog1:SetSize( 5, 45 )
		Prog1:SetPos(w-110, 10)
		Prog1:IsDraggable(false)

		Prog2 = vgui.Create( "DPanel" )	
		Prog2.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, 2.5, 45, Color(0, 172, 238, 255))
		end
		Prog2:SetSize( 5, 45 )
		Prog2:SetPos(w-10, 10)
		Prog2:IsDraggable(false)

		Prog3 = vgui.Create( "DPanel" )	
		Prog3.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, 2.5, 45, Color(0, 172, 238, 255))
		end
		Prog3:SetSize( 5, 45 )
		Prog3:SetPos(w+90, 10)
		Prog3:IsDraggable(false)
		-- Before trying new stuff
		--[[
		if(LocalPlayer():Team() ~= TEAM_SHIPMENT) then
			Back:Remove()
			Text:Remove()
			Bar:Remove()
			Prog1:Remove()
			Prog2:Remove()
			Prog3:Remove()
			print("WOWWOWOWOWOWOWOOWOWOATOWETNOAIWNTOIAWNTOIAWNTOANWTONOAWTNOAWNTOAWNTOINW")
		end
		--]]
	elseif (oldteam == TEAM_SHIPMENT) then
		if (Back == nil) then
			return
		else
			Back:Remove()
			Text:Remove()
			Bar:Remove()
			Prog1:Remove()
			Prog2:Remove()
			Prog3:Remove()
		end
	end
end
hook.Add("OnPlayerChangedTeam", "toggleHud", xpBar)


