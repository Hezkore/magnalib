Import brl.standardio

Import "../tlayoutgadget.bmx"
Import "../tlayoutstyle.bmx"

Type TLayoutStyleStackHorizontal Extends TLayoutStyle
	Method RecalculateChildren( children:TList )
		
		Local posX:Int
		For Local g:TLayoutGadget_Header = EachIn children
			g.SetPosition( posX, 0 )
			g.SetSize( 32, 16 + posX )
			posX:+g.GetOuterSize().x
		Next
	EndMethod
EndType
