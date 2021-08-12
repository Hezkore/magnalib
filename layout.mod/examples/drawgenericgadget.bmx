Import brl.max2d

' Helper function for drawing any generic layout gadget
Function DrawGenericGadget( g:TLayoutGadget )
	' Store current viewport
	' Can we use GetViewport with a struct instead?
	Local viewportX:Int, viewportY:Int, viewportW:Int, viewportH:Int
	GetViewport( viewportX, viewportY, viewportW, viewportH )
	SetBlend( ALPHABLEND )
		
	' Draw gadget rectangle
	Select g.GetTypeHash()
		' Cache Hash ULong for even better performance
		Case "Container".Hash()
			If Not g.Parent Then
				SetColor( 59, 53, 61 )
			Else
				SetAlpha( 0 )
			EndIf
			
		Default
			SetColor( 97, 112, 133 )
			SetAlpha( 1 )
	EndSelect
	DrawRect( g.GetPosition().x + 1, g.GetPosition().y + 1, g.GetSize().x - 2, g.GetSize().y - 2 )
	
	' Draw outline
	If GetAlpha() > 0 Then
		SetAlpha( GetAlpha() * 0.75 )
		DrawOutline( g.GetPosition().x, g.GetPosition().y, g.GetSize().x, g.GetSize().y )
	EndIf
	
	' Limit viewport
	SetViewport( ..
		g.GetInnerPosition().x, g.GetInnerPosition().y , ..
		g.GetInnerSize().x, g.GetInnerSize().y )
	
	' Text
	If g.GetText() Then
		SetAlpha( 0.9 )
		SetColor( 244, 245, 223 )
		DrawText( g.GetText(), ..
			g.GetPosition.x + g.GetSize.x / 2 - TextWidth( g.GetText() ) / 2,..
			g.GetPosition.y + g.GetSize.y / 2 - TextHeight( g.GetText() ) / 2 )
		SetViewport( 0, 0, GraphicsWidth(), GraphicsHeight() )
	EndIf
	
	' Draw any potential children of this gadget
	For Local cG:TLayoutGadget = EachIn g
		DrawGenericGadget( cG )
	Next
	
	' Restore viewport
	SetViewport( viewportX, viewportY, viewportW, viewportH )
	SetAlpha( 1 )
EndFunction

Function DrawOutline( x:Int, y:Int, w:Int, h:Int )
	DrawLine( x + 1, y, x + w - 1, y , False )
	DrawLine( x + w - 1, y + 1, x + w - 1, y + h - 1, False )
	DrawLine( x + w - 2, y + h - 1, x, y + h - 1, False )
	DrawLine( x, y + h - 2, x, y, False )
EndFunction