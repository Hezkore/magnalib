SuperStrict

Framework magna.layout
Import brl.standardio
Import brl.max2d
Import brl.glmax2d

Local myLayout:TLayout = New TLayout( 320, 240 )
myLayout.Position = New SVec2I( 32, 32 )
myLayout.AddGadget( New TLayoutButton( "button1", "My Button" ) )
myLayout.AddGadget( New TLayoutButton( "button2", "Your Button" ) )

Graphics( 640, 480 )

While Not AppTerminate() And Not KeyDown(KEY_ESCAPE)
	
	Cls()
	SetBlend( ALPHABLEND )
	
	SetOrigin( myLayout.Position.x, myLayout.Position.y )
	For Local g:TLayoutGadget = EachIn myLayout
		DrawGenericGadgetItem( g )
	Next
	SetOrigin( 0, 0 )
	
	Flip(1)
Wend

Function DrawGenericGadgetItem( g:TLayoutGadget )
	SetAlpha( 0.1 )
	DrawRect( g.Position.x, g.Position.y, g.GadgetSize.x, g.GadgetSize.y )
	
	SetAlpha( 0.5 )
	DrawLine( g.Position.x, g.Position.y, g.Position.x + g.GadgetSize.x, g.Position.y, False )
	DrawLine( g.Position.x + g.GadgetSize.x, g.Position.y, g.Position.x + g.GadgetSize.x, g.Position.y + g.GadgetSize.y, False )
	DrawLine( g.Position.x + g.GadgetSize.x, g.Position.y + g.GadgetSize.y, g.Position.x, g.Position.y + g.GadgetSize.y, False )
	DrawLine( g.Position.x, g.Position.y + g.GadgetSize.y, g.Position.x, g.Position.y, False )
	
	If g.Text Then
		DrawText( g.Text, ..
			g.Position.x + g.GadgetSize.x / 2 - TextWidth( g.Text ) / 2,..
			g.Position.y + g.GadgetSize.y / 2 - TextHeight( g.Text ) / 2 )
	EndIf
EndFunction