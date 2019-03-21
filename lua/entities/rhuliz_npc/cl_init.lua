include('shared.lua')
if CLIENT then
resource.AddFile("resource/fonts/fredoka.ttf")
resource.AddFile("resource/fonts/modernsanslight.ttf")
function TopText()
	for _, ent in pairs (ents.FindByClass("rhuliz_npc")) do
		local Ang = ent:GetAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 90)
		Ang:RotateAroundAxis( Ang:Right(), -90)
		
		cam.Start3D2D(ent:GetPos()+ent:GetUp()*85, Ang, 0.35)
			draw.SimpleText( 'Rhuliz The Elf', "Free3D", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		cam.End3D2D()
			
		Ang:RotateAroundAxis( Ang:Right(), -180)
		
		cam.Start3D2D(ent:GetPos()+ent:GetUp()*85, Ang, 0.35)
			draw.SimpleText( 'Rhuliz The Elf', "Free3D", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		cam.End3D2D()
	end
end
hook.Add("PostDrawOpaqueRenderables", "NPC_TEXT", TopText)

ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	timer.Simple(IsValid(LocalPlayer()) and 1 or 5, function()
		if (IsValid(self)) then
			self:setAnim()
		end
	end)
end
function ENT:createBubble()
	self.bubble = ClientsideModel("models/extras/info_speech.mdl", RENDERGROUP_OPAQUE)
	self.bubble:SetPos(self:GetPos() + Vector(0, 0, 84))
	self.bubble:SetModelScale(0.6, 0)
end

function ENT:Draw()
	local realTime = RealTime()

	self:FrameAdvance(realTime - (self.lastTick or realTime))
	self.lastTick = realTime
	
	local bubble = self.bubble
	
	if (IsValid(bubble)) then
		local realTime = RealTime()

		bubble:SetRenderOrigin(self:GetPos() + Vector(0, 0, 94 + math.sin(realTime * 3) * 2.75))
		bubble:SetRenderAngles(Angle(0, realTime * 100, 0))
	end

	self:DrawModel()
end
function ENT:Think()
	if (!IsValid(self.bubble)) then
		self:createBubble()
	end

	if ((self.nextAnimCheck or 0) < CurTime()) then
		self:setAnim()
		self.nextAnimCheck = CurTime() + 60
	end

	self:SetNextClientThink(CurTime() + 0.25)

	return true
end

function ENT:OnRemove()
	if (IsValid(self.bubble)) then
		self.bubble:Remove()
	end
end


surface.CreateFont( "FreePara", {
	font = "Fredoka One", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	antialias = true,
	size = 25,
	weight = 0,
	shadow = true,
} )
surface.CreateFont( "FreeButton", {
	font = "Fredoka One", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	antialias = true,
	size = 19,
	weight = 0,
	shadow = true,
} )
surface.CreateFont( "FreeButtonx2", {
	font = "Fredoka One", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	antialias = true,
	size = 19*2,
	weight = 0,
	shadow = true,
} )
surface.CreateFont( "Free3D", {
	font = "Fredoka One", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	antialias = true,
	size = 30,
	weight = 0,
	shadow = true,
} )
surface.CreateFont("locationFont", {
	font = "Fredoka One",
	antialias = true,
	size = 75,
	weight = 100,
	shadow = false,

} )

local function drawLocation()

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

	local w = ScrW() / 2
	local h = ScrH() / 2

	local location = vgui.Create( "DFrame" )
	location:SetSize( ScrW(), ScrH() )
	location:Center()
	location:SetDraggable( false ) 
	location:SetTitle("")
	location:ShowCloseButton(false)
	location:MakePopup(false)
	
	local blurBack = vgui.Create( "DFrame")
	blurBack.Paint = function( self, w, h )
		DrawBlur(self, 6)
		draw.RoundedBox( 0, 0, 0, 545, 100, Color( 0, 0, 0, 100 ) )
	end

	blurBack:SetPos(w-285, 100)
	blurBack:SetSize( 545, 100 )
	blurBack:SetTitle( "" )
	blurBack:ShowCloseButton(false)
	blurBack:SetBackgroundBlur( true ) 
	blurBack:SetDraggable( false ) 
	blurBack:MakePopup(false) 

	local locationText = vgui.Create(  "DLabel", location ) 
	locationText:SetFont("locationFont")
	locationText:SetTextColor(Color(255,255,255,255))
	locationText:SetText( "Delivery Location" )   

	locationText:SetPos(w-280, 50)
	locationText:SetSize(800,200)
	locationText:MakePopup(false)

	local locationClose = vgui.Create( "Button", location ) 
	locationClose:SetTextColor( Color( 255, 255, 255, 255 ) )
	locationClose:SetFont("FreeButtonx2")
	locationClose:SetText( "OK")
	locationClose:SetSize( 169*2, 45*2 ) 
	locationClose:SetPos ( w-190, 500 ) 
	locationClose.DoClick = function( self ) 
		timer.Remove("closeLocation")
		location:Remove()
		blurBack:Remove()
		locationText:Remove()
	end
	locationClose.Paint = function(self, w, h) -- The paint function
	DrawBlur(self, 6)
	draw.RoundedBox( 0, 0, 0, 545, 100, Color( 0, 0, 0, 100 ) )
	end


	location.Paint = function( self, w, h )



		local x, y = self:GetPos()

		render.RenderView( {
			-- RP_DOWNTOWN_WINTER origin = Vector( -6219.214844, 12533.875000, -2626.324219 ),
			origin = Vector( -2361.739502, -1869.531372, 73.806259 ),

			-- RP_DOWNTOWN_WINTER angles = Angle( 0.810157, -128.034546, 0.000000 ),
			angles = Angle( 4.729965, -130.726593, 0.000000 ),
			x = x, y = y,
			w = w, h = h
		} )

	end


	timer.Create("closeLocation", 4, 1, function() locationClose:Remove() location:Remove() blurBack:Remove() locationText:Remove() end)
end



local function RhulizM()
	
	local blur = Material("pp/blurscreen")
	local function DrawBlur(panel, amount)
		local x, y = panel:LocalToScreen(0, 0)
		local scrW, scrH = ScrW(), ScrH()
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(blur)
		for i = 1, 3 do
			blur:SetFloat("$blur", (i / 5) * (amount or 10))
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		end
	end



	local menuI = vgui.Create( "DFrame" )
	menuI.Paint = function( self, w, h )
		DrawBlur(self, 3)
		draw.RoundedBox( 0, 0, 0, 335, 180, Color( 0, 0, 0, 145 ) )
	end

	menuI:SetPos( 5, 5 )
	menuI:SetSize( 335, 205 )
	menuI:SetTitle( "" )

	menuI:SetBackgroundBlur( true ) 
	menuI:Center( true ) 
	menuI:SetDraggable( false ) 
	menuI:MakePopup() 

	local menup = vgui.Create( "DPanel", menuI )
	menup:SetPos( 2, 0 )
	menup:SetSize( 80, 120 )
	menup:SetBackgroundColor( Color(97,97,97,0) ) 

	local menui = vgui.Create( "DModelPanel", menup )
	menui:SetPos( 6, 20 )
	menui:SetSize( 80, 120 )
	menui:SetModel( "models/player/gman_high.mdl" )
	menui:Center( true ) 
	function menui:LayoutEntity( Entity ) return end	
	local headpos = menui.Entity:GetBonePosition( menui.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
	menui:SetLookAt( headpos)
	menui:SetCamPos( headpos - Vector( -15, 0, 0 ) )	-- Move cam in front of eyes

	if(LocalPlayer():Team() == TEAM_SHIPMENT) then	
		local menuPara = vgui.Create(  "DLabel", menuI ) 
		menuPara:SetFont("FreePara")
		menuPara:SetTextColor(Color(255,255,255,255))
		menuPara:SetText( "Hello fellow person!\nDo you need a shipment?\nThey are heavy" ) 
		menuPara:SetPos( 80, 25 )  
		menuPara:SizeToContents() 


		local menub = vgui.Create( "Button", menuI ) 
		menub:SetTextColor( Color( 255, 255, 255, 255 ) )
		menub:SetFont("FreeButton")
		menub:SetText( "Spawn Pallet")
		menub:SetSize( 335, 45 ) 
		menub:SetPos ( 0, 160 ) 
		menub.DoClick = function( self ) 
			net.Start( "Rhuliz.Pallet" ) 
		    net.SendToServer()
		end
		menub.Paint = function() -- The paint function
		surface.SetDrawColor(158, 11, 21, 255)
		surface.DrawRect( 0, 0, menub:GetWide(), menub:GetTall() )
		end

		-- TRY USING NET.START WHEN USER SPAWNS A FORKLIFT AND THEN NET.RECIEVE TO CHANGE THE menuc when you recieve the net.start.
		
		--[[
		if(ply.hasFork) then
			local menuc = vgui.Create( "Button", menuI ) 
			menuc:SetTextColor( Color( 255, 255, 255, 255 ) )
			menuc:SetFont("FreeButton")
			menuc:SetText( "Return Forklift" ) 
			menuc:SetSize( 167, 45 ) 
			menuc:SetPos ( 0, 115 ) 
			menuc.DoClick = function( self ) 
			    net.Start( "Rhuliz.Return" ) 
			    net.SendToServer()
			end
			menuc.Paint = function() -- The paint function
			surface.SetDrawColor(0,	172, 238, 255)
			surface.DrawRect( 0, 0, menuc:GetWide(), menuc:GetTall() )
			end
		elseif(ply.hasFork == false) then
		end
		--]]
		local menuc = vgui.Create( "Button", menuI ) 
		menuc:SetTextColor( Color( 255, 255, 255, 255 ) )
		menuc:SetFont("FreeButton")
		menuc:SetText( "Spawn Forklift" ) 
		menuc:SetSize( 167, 45 ) 
		menuc:SetPos ( 0, 115 ) 
		menuc.DoClick = function( self ) 
		    net.Start( "Rhuliz.fork" ) 
		    net.SendToServer()
		end
		menuc.Paint = function() -- The paint function
		surface.SetDrawColor(0,	172, 238, 255)
		surface.DrawRect( 0, 0, menuc:GetWide(), menuc:GetTall() )
		end


		local menud = vgui.Create( "Button", menuI ) 
		menud:SetTextColor( Color( 255, 255, 255, 255 ) )
		menud:SetFont("FreeButton")
		menud:SetText( "Return Forklift" ) 
		menud:SetSize( 167, 45 ) 
		menud:SetPos ( 167, 115 ) 
		menud.DoClick = function( self ) 
		    net.Start( "Rhuliz.Return")
		    net.SendToServer()
		end
		menud.Paint = function() -- The paint function
		surface.SetDrawColor(123, 36, 28, 255)
		surface.DrawRect( 0, 0, menuc:GetWide(), menuc:GetTall() )
		end
		
	else
		local menuNot = vgui.Create(  "DLabel", menuI ) 
			menuNot:SetFont("FreePara")
			menuNot:SetTextColor( Color( 255, 255, 255, 255 ) )
			menuNot:SetText( "It seems, well, um....\nYou're not Qualified.\nSo, yea...")
			menuNot:SetPos( 88, 25 )
			menuNot:SizeToContents() 

			local menuNotb = vgui.Create( "Button", menuI ) 
			menuNotb:SetTextColor( Color( 255, 255, 255, 255 ) )
			menuNotb:SetFont("FreeButton")
			menuNotb:SetText( "Close.")
			menuNotb:SetSize( 335, 90 ) 
			menuNotb:SetPos ( 0, 115 ) 
			menuNotb.DoClick = function( self ) 
				menuI:Close()
			end
			menuNotb.Paint = function() -- The paint function
			surface.SetDrawColor(158, 11, 21, 255)
			surface.DrawRect( 0, 0, menuNotb:GetWide(), menuNotb:GetTall() )
			end
	end
	net.Receive("Rhuliz.Location",function(len, pl)
		timer.Simple(1, function() drawLocation() end)
	end)

	net.Receive("Nofi.MsgErr",function( len, pl)
	    local message = net.ReadString()
		surface.PlaySound( "buttons/weapon_cant_buy.wav" )
		Msg(message)
	    notification.AddLegacy(message, NOTIFY_ERROR, 5 )
    end)

    net.Receive("Nofi.Msg",function( len, pl)
    	local message = net.ReadString()
    	surface.PlaySound( "buttons/button9.wav" )
    	Msg(message)
    	notification.AddLegacy(message, NOTIFY_ERROR, 5 )
    end)
end
usermessage.Hook("elfmenu",RhulizM) 

end