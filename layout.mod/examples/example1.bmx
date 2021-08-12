SuperStrict

Framework magnalib.layout
Import brl.standardio
Import brl.max2d
Import brl.glmax2d

' Example layout
Local myLayout:TLayoutPanel = New TLayoutPanel( "main", 320, 240, "stackVertical" )
myLayout.AddGadget( New TLayoutPanel( "titlebar", "stackHorizontal" ) )
myLayout.LastGadget().AddGadget( New TLayoutPanel( "title",, True ) ).SetText("My litte layout")
myLayout.LastGadget().AddGadget( New TLayoutButton( "minimize", "_", 18, 18 ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "close", "x", 18, 18 ) )

myLayout.AddGadget( New TLayoutPanel( "toolbar", "wrapHorizontal" ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "button1", "File",, 18 ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "button2", "Edit",, 18 ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "button3", "View",, 18 ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "button4", "Blah",, 18 ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "button5", "Help",, 18 ) )

myLayout.AddGadget( New TLayoutPanel( "main", "stackHorizontal", True ) )
myLayout.LastGadget().AddGadget( New TLayoutPanel( "area",, True ) ).SetMinSize( 160, 100 )

myLayout.AddGadget( New TLayoutPanel( "buttonrow" ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "abort", "Abort" ) )
myLayout.LastGadget().AddGadget( New TLayoutPanel( "expand",, True ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "apply", "Apply" ) )

Graphics( 640, 480 )
While Not AppTerminate() And Not KeyDown(KEY_ESCAPE)
	Cls()

	' Move with left mouse button
	If MouseDown( 1 ) Then
		myLayout.SetPosition( MouseX(), MouseY() )
	EndIf
	
	' Resize with right mouse button
	If MouseDown( 2 ) Then
		myLayout.SetSize( ..
			MouseX() - myLayout.GetPosition().x, ..
			MouseY() - myLayout.GetPosition().y )
	EndIf
	
	' Draw the layout and all of its children
	DrawGenericGadgetItem( myLayout )
	
	Flip( 1 )
Wend

Function DrawGenericGadgetItem( g:TLayoutGadget )
	SetBlend( ALPHABLEND )
	
	' Area rectangle
	SetAlpha( 0.2 )
	Select g.GetTypeHash()
		' Cache "Panel".Hash() ULong for even better performance
		Case "Panel".Hash()
			SetColor( 166, 204, 255 )
		Default
			SetColor( 239, 201, 253 )
	EndSelect
	DrawRect( g.GetPosition().x, g.GetPosition().y, g.GetSize().x, g.GetSize().y )
	
	' Outline
	SetAlpha( 1 )
	SetColor( 207, 217, 230 )
	DrawOutline( g.GetPosition.x, g.GetPosition.y, g.GetSize.x, g.GetSize.y  )
	
	' Text
	If g.GetText() Then
		SetViewport( ..
			g.GetInnerPosition().x, g.GetInnerPosition().y , ..
			g.GetInnerSize().x, g.GetInnerSize().y )
		SetAlpha( 1 )
		SetColor( 244, 245, 223 )
		DrawText( g.GetText(), ..
			g.GetPosition.x + g.GetSize.x / 2 - TextWidth( g.GetText() ) / 2,..
			g.GetPosition.y + g.GetSize.y / 2 - TextHeight( g.GetText() ) / 2 )
		SetViewport( 0, 0, GraphicsWidth(), GraphicsHeight() )
	EndIf
	
	' Draw any potential children of this gadget
	For Local cg:TLayoutGadget = EachIn g
		DrawGenericGadgetItem( cg )
	Next
EndFunction

Function DrawOutline( x:Int, y:Int, w:Int, h:Int )
	DrawLine( x, y - 1, x + w, y - 1, False )
	DrawLine( x + w, y, x + w, y + h, False )
	DrawLine( x + w - 1, y + h, x - 1, y + h, False )
	DrawLine( x - 1, y + h - 1, x - 1, y - 1, False )
EndFunction