SuperStrict

Framework magna.layout
Import brl.max2d
Import brl.glmax2d

Import "drawgenericgadget.bmx"

' Create our simple layout
Local myLayout:TLayoutContainer = New TLayoutContainer( "main", 400, 340, "stackVertical" )
myLayout.AddGadget( New TLayoutContainer( "titlebar", "stackHorizontal" ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "area", "My simple layout", 0, 0, True ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "minimize", "_", 18, 18 ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "close", "x", 18, 18 ) )

myLayout.AddGadget( New TLayoutContainer( "toolbar", "wrapHorizontal" ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "button1", "File",, 18 ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "button2", "Edit",, 18 ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "button3", "View",, 18 ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "button4", "Blah",, 18 ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "button5", "Help",, 18 ) )

myLayout.AddGadget( New TLayoutContainer( "main", "stackHorizontal", True ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "area", "Main area", 0, 0, True ) )

myLayout.AddGadget( New TLayoutContainer( "buttonrow" ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "abort", "Abort" ) )
myLayout.LastGadget().AddGadget( New TLayoutContainer( "expand",, True ) )
myLayout.LastGadget().AddGadget( New TLayoutButton( "apply", "Apply" ) )

myLayout.SetPadding( New SVec4I( 4, 4, 4, 4 ) )
myLayout.SetPosition( 64, 64 )

' Create a Max2D graphics window
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
	
	' Draw info
	DrawText( "Hold left mouse button to position", 2, 0 )
	DrawText( "Hold right mouse button to resize", 2, 16 )
	
	' Draw the layout and all of its children
	DrawGenericGadget( myLayout )
	
	Flip( 1 )
Wend