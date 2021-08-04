SuperStrict

Framework magna.layout
Import brl.standardio
Import brl.max2d
Import brl.glmax2d

rem
Local myLayout:TLayout = New TLayout( 320, 240 )
myLayout.AddGadget( New TLayoutButton( "button1", 20, 32, "B1" ) )
myLayout.AddGadget( New TLayoutButton( "button2", -1, 32, "Button 2" ) )
myLayout.AddGadget( New TLayoutContainer( "container1", ELayoutStyle.StackVertical ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "subbutton1", "sub1" ) )
myLayout.LastGadget.AddGadget( New TLayoutContainer( "container2", ELayoutStyle.StackHorizontal ) )
myLayout.LastGadget.LastGadget.AddGadget( New TLayoutButton( "subsubbutton1", "subsub1" ) )
myLayout.LastGadget.LastGadget.AddGadget( New TLayoutButton( "subsubbutton2", "subsub2" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "subbutton2", "sub2" ) )
myLayout.AddGadget( New TLayoutButton( "button4", 50, 32, "B4" ) )
endrem

Local myLayout:TLayout = New TLayout( 320, 240, ELayoutStyle.StackVertical )
myLayout.AddGadget( New TLayoutContainer( "window", -1, 16, ELayoutStyle.StackHorizontal ) )
myLayout.LastGadget.AddGadget( New TLayoutContainer( "expand" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "minimize", 16, -1, "_" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "close", 16, -1, "x" ) )
myLayout.AddGadget( New TLayoutContainer( "toolbar", -1, 16, ELayoutStyle.StackHorizontal ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "button1", 64, -1, "File" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "button2", 64, -1, "Edit" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "button3", 64, -1, "Help" ) )
myLayout.AddGadget( New TLayoutContainer( "main", ELayoutStyle.StackHorizontal ) )
myLayout.LastGadget.AddGadget( New TLayoutContainer( "empty", 96, -1 ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "area", -1, -1, "Some Area" ) )
myLayout.AddGadget( New TLayoutContainer( "buttonrow", -1, 24 ) )
myLayout.LastGadget.AddGadget( New TLayoutContainer( "expand" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "apply", 64, -1, "Apply" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "abort", 64, -1, "Abort" ) )

Graphics( 640, 480 )

While Not AppTerminate() And Not KeyDown(KEY_ESCAPE)
	
	Cls()
	SetBlend( ALPHABLEND )
	
	myLayout._fixedSize = New SVec2I( 320 + Sin( MilliSecs() * 0.1 ) * 100, 240 + Cos( MilliSecs() * 0.1 ) * 100 )
	myLayout._dirty = True
	
	DrawGenericGadgetItem( myLayout, New SVec2I( 32, 32 )  )
	For Local g:TLayoutGadget = EachIn myLayout
		DrawGenericGadgetItem( g, New SVec2I( 32, 32 ) )
	Next
	
	Flip(1)
Wend

Function DrawGenericGadgetItem( g:TLayoutGadget, offset:SVec2I )
	SetOrigin( offset.x, offset.y)
	SetAlpha( 0.1 )
	DrawRect( g.GadgetPosition.x, g.GadgetPosition.y, g.GadgetSize.x, g.GadgetSize.y )
	
	SetAlpha( 0.5 )
	DrawLine( g.GadgetPosition.x, g.GadgetPosition.y, g.GadgetPosition.x + g.GadgetSize.x, g.GadgetPosition.y, False )
	DrawLine( g.GadgetPosition.x + g.GadgetSize.x, g.GadgetPosition.y, g.GadgetPosition.x + g.GadgetSize.x, g.GadgetPosition.y + g.GadgetSize.y, False )
	DrawLine( g.GadgetPosition.x + g.GadgetSize.x, g.GadgetPosition.y + g.GadgetSize.y, g.GadgetPosition.x, g.GadgetPosition.y + g.GadgetSize.y, False )
	DrawLine( g.GadgetPosition.x, g.GadgetPosition.y + g.GadgetSize.y, g.GadgetPosition.x, g.GadgetPosition.y, False )
	
	If g._text Then
		DrawText( g._text, ..
			g.GadgetPosition.x + g.GadgetSize.x / 2 - TextWidth( g._text ) / 2,..
			g.GadgetPosition.y + g.GadgetSize.y / 2 - TextHeight( g._text ) / 2 )
	EndIf
	
	For Local cg:TLayoutGadget = EachIn g
		DrawGenericGadgetItem( cg, New SVec2I( g.GadgetPosition.x + offset.x, g.GadgetPosition.y + offset.y ) )
	Next
	SetOrigin( 0, 0 )
EndFunction