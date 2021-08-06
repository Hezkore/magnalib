SuperStrict

Framework magna.layout
Import brl.standardio
Import brl.max2d
Import brl.glmax2d

Local myLayout:TLayoutGadget = TLayoutGadget( GadgetFromString( """
#window (size = 320 240) {
	button#b1 (text=~qButt1~q, grow=1, size=32 24)
	button#b2 (text=~qButton 2~q, size=68 24)
	(grow=1) {
		button#b3 (text=B3, size=24)
	}
	button#b4 (text=~qButton 4~q, size=68 24)
	button#b5 (text=~qButton 5~q, size=68 24)
}
""" )[0] )
'myLayout.AddGadget( GadgetFromString( "b1#button (text=~qButton 1~q, size=64)" ) )
'myLayout.AddGadget( New TLayoutButton( ["id=b1", "text=Button 1", "size=64"] ) )

' Make example layout
' TLayout is the same as TLayoutContainer
rem
Local myLayout:TLayoutContainer = New TLayoutContainer( 320, 240, ELayoutStyle.StackVertical )
myLayout.AddGadget( New TLayoutContainer( "window", -1, 16, ELayoutStyle.StackHorizontal ) )
myLayout.LastGadget.AddGadget( New TLayoutContainer( "expand" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "minimize", 16, -1, "_" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "close", 16, -1, "x" ) )
myLayout.AddGadget( New TLayoutContainer( "toolbar", -1, 16, ELayoutStyle.WrapHorizontal ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "button1", 64, -1, "File" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "button2", -1, -1, "Edit" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "button3", 64, -1, "View" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "button4", 64, -1, "Blah" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "button5", 64, -1, "Help" ) )
myLayout.AddGadget( New TLayoutContainer( "main", ELayoutStyle.StackHorizontal ) )
myLayout.LastGadget.AddGadget( New TLayoutContainer( "empty", 96, -1 ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "area", -1, -1, "Some Area" ) )
myLayout.AddGadget( New TLayoutContainer( "buttonrow", -1, 24 ) )
myLayout.LastGadget.AddGadget( New TLayoutContainer( "expand" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "apply", 64, -1, "Apply" ) )
myLayout.LastGadget.AddGadget( New TLayoutButton( "abort", 64, -1, "Abort" ) )
endrem

Print( "myLayout has the following properties: " )
Print( ", ".Join( myLayout.GetProperties() ) )

Graphics( 640, 480 )
While Not AppTerminate() And Not KeyDown(KEY_ESCAPE)
	Cls()
	
	myLayout.SetPosition( ..
		64 + Sin( MilliSecs() * 0.075 ) * 8,..
		128 + Cos( MilliSecs() * 0.075 ) * 8 )
	
	myLayout.SetSize( ..
		320 + Sin( MilliSecs() * 0.09 ) * 80,..
		240 + Cos( MilliSecs() * 0.09 ) * 80 )
	
	' Draw the base container the same way as any gadget
	DrawGenericGadgetItem( myLayout )
	
	' Draw base container children
	For Local g:TLayoutGadget = EachIn myLayout
		DrawGenericGadgetItem( g )
	Next
	
	Flip( 1 )
Wend

Function DrawGenericGadgetItem( g:TLayoutGadget )
	SetBlend( ALPHABLEND )
	
	' Area rectangle
	SetAlpha( 0.15 )
	If g.Parent Then SetColor( 233, 179, 255 ) Else SetColor( 194, 218, 255 )
	DrawRect( g.GetPosition.x, g.GetPosition.y, g.GetSize.x, g.GetSize.y )
	
	' Outline
	SetAlpha( 0.5 )
	DrawLine( g.GetPosition.x, g.GetPosition.y, g.GetPosition.x + g.GetSize.x, g.GetPosition.y, False )
	DrawLine( g.GetPosition.x + g.GetSize.x, g.GetPosition.y, g.GetPosition.x + g.GetSize.x, g.GetPosition.y + g.GetSize.y, False )
	DrawLine( g.GetPosition.x + g.GetSize.x, g.GetPosition.y + g.GetSize.y, g.GetPosition.x, g.GetPosition.y + g.GetSize.y, False )
	DrawLine( g.GetPosition.x, g.GetPosition.y + g.GetSize.y, g.GetPosition.x, g.GetPosition.y, False )
	
	' Text
	If g.GetText() Then
		DrawText( g.GetText(), ..
			g.GetPosition.x + g.GetSize.x / 2 - TextWidth( g.GetText() ) / 2,..
			g.GetPosition.y + g.GetSize.y / 2 - TextHeight( g.GetText() ) / 2 )
	EndIf
	
	' Draw any potential children of this gadget
	For Local cg:TLayoutGadget = EachIn g
		DrawGenericGadgetItem( cg )
	Next
EndFunction