include('shared.lua')
if CLIENT then
resource.AddFile("resource/fonts/fredoka.ttf")


-- RP_DOWNTOWN_WINTER Vector(-7680.339355, 11822.401367, -2652.462646), Vector(-7425.031250, 11609.031250, -2589.968750)
-- RP_LITTLETOWN Vector(-2949.568604, -2074.177490, 0), Vector(-2604.468994, -2251.681885, 75.250000),
hook.Add("PostDrawOpaqueRenderables", "ZoneRender",
	function()
		render.DrawWireframeBox( Vector(0,0,0), Angle(0,0,0), Vector(-2949.568604, -2074.177490, 0), Vector(-2604.468994, -2251.681885, 75.250000), Color(0, 158, 0, 255), true)
	end)



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
	size = ScreenScale(10),
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
surface.CreateFont( "Free3D", {
	font = "Fredoka One", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	antialias = true,
	size = 30,
	weight = 0,
	shadow = true,
} )


local function RhulizS()

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
	draw.RoundedBox( 0, 0, 0, 335, 160, Color( 0, 0, 0, 145) )

end
menuI:SetPos( 5, 5 )
menuI:SetSize( 335, 160 )
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
menui:SetModel( "models/player/eli.mdl" )
menui:Center( true ) 
function menui:LayoutEntity( Entity ) return end	
local headpos = menui.Entity:GetBonePosition( menui.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
menui:SetLookAt( headpos)
menui:SetCamPos( headpos - Vector( -15, 0, 0 ) )	-- Move cam in front of eyes

if(LocalPlayer():Team() == TEAM_SHIPMENT) then		
	local menuPara = vgui.Create(  "DLabel", menuI ) 
	menuPara:SetFont("FreePara")
	menuPara:SetTextColor( Color( 255, 255, 255, 255 ) )
	menuPara:SetText( "Ya got me a shipment?\nI'll give ya cash yaknow!\nThat is worth $" .. ".")
	menuPara:SetPos( 88, 25 )
	menuPara:SizeToContents() 


	local menub = vgui.Create( "Button", menuI ) 
	menub:SetTextColor( Color( 255, 255, 255, 255 ) )
	menub:SetFont("FreeButton")
	menub:SetText( "Sell Pallet.")
	menub:SetSize( 335, 45 ) 
	menub:SetPos ( 0, 115 ) 
	menub.DoClick = function( self ) 
		net.Start( "Sell.Pallet" ) 
	    net.SendToServer()
	end
	menub.Paint = function() -- The paint function
	surface.SetDrawColor(27,170,58, 255)
	surface.DrawRect( 0, 0, menub:GetWide(), menub:GetTall() )
	end
else
	 
local menuNot = vgui.Create(  "DLabel", menuI ) 
	menuNot:SetFont("FreePara")
	menuNot:SetTextColor( Color( 255, 255, 255, 255 ) )
	menuNot:SetText( "Ya got me a shipment?\nLemmie CHECK YA!\nFAKE, GO GET A JOB!")
	menuNot:SetPos( 88, 25 )
	menuNot:SizeToContents() 

	local menuNotb = vgui.Create( "Button", menuI ) 
	menuNotb:SetTextColor( Color( 255, 255, 255, 255 ) )
	menuNotb:SetFont("FreeButton")
	menuNotb:SetText( "Close.")
	menuNotb:SetSize( 335, 45 ) 
	menuNotb:SetPos ( 0, 115 ) 
	menuNotb.DoClick = function( self ) 
		menuI:Close()
	end
	menuNotb.Paint = function() -- The paint function
	surface.SetDrawColor(158, 11, 21, 255)
	surface.DrawRect( 0, 0, menuNotb:GetWide(), menuNotb:GetTall() )
	end
end


net.Receive("pallet_sold",function( len, pl)
local message = net.ReadString()
notification.AddLegacy(message, NOTIFY_ERROR, 5 )
end)
end
usermessage.Hook("sellmenu",RhulizS) 


SNPCD = SNPCD or {}

function SNPCD.DrawText()
	for _, ent in pairs (ents.FindByClass("seller_npc")) do
		local Ang = ent:GetAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 90)
		Ang:RotateAroundAxis( Ang:Right(), -90)
		
		cam.Start3D2D(ent:GetPos()+ent:GetUp()*85, Ang, 0.35)
			draw.SimpleText( 'Donny The Seller', "Free3D", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		cam.End3D2D()
			
		Ang:RotateAroundAxis( Ang:Right(), -180)
		
		cam.Start3D2D(ent:GetPos()+ent:GetUp()*85, Ang, 0.35)
			draw.SimpleText( 'Donny The Seller', "Free3D", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		cam.End3D2D()
	end
end
hook.Add("PostDrawOpaqueRenderables", "NPC_TEXT1", SNPCD.DrawText)

end