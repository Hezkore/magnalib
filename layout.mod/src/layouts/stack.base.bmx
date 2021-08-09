Import "../tlayoutgadget.bmx"
Import "../tlayoutstyle.bmx"

Type TLayoutStyleStackBase Extends TLayoutStyle
	Method ResizeToParent( children:TObjectList, hori:Int )
	EndMethod
	
	Method ResizeChildren( children:TObjectList, hori:Int )
		Local childMinSize:SVec2I = Self.GetChildrenMinSize()
		Local sizeFree:Svec2I = Self.GetInnerSize() - childMinSize
		For Local g:TLayoutGadget = EachIn children
			If g.GetGrow() Then
				If hori Then
					g.SetOuterSize( ..
						Max( g.GetMinOuterSize().x, sizeFree.x / Self.GetGrowingChildrenCount() ), ..
						Max( g.GetMinOuterSize().y, Self.GetInnerSize().y ) )
				Else
					g.SetOuterSize( ..
						Max( g.GetMinOuterSize().x, Self.GetInnerSize().x ), ..
						Max( g.GetMinOuterSize().y, sizeFree.y / Self.GetGrowingChildrenCount() ) )
				EndIf
			Else
				If hori Then
					g.SetOuterSize( g.GetMinOuterSize().x, Self.GetInnerSize().y )
				Else
					g.SetOuterSize( Self.GetInnerSize().x, g.GetMinOuterSize().y )
				EndIf
			EndIf
		Next
	EndMethod
	
	Method ResizeOverflow( children:TObjectList, hori:Int )
		Local totaOverflow:SVec2I = Self.GetChildrenOverflow()
		Local childOverflow:Int
		Local shrank:Int
		If hori Then childOverflow = totaOverflow.x Else childOverflow = totaOverflow.y
		While childOverflow > 0
			If hori Then
				shrank = Self.ShrinkChild( Self.GetLargestXChild(), 1, 0 ).x
			Else
				shrank = Self.ShrinkChild( Self.GetLargestYChild(), 0, 1 ).y
			EndIf
			If shrank Then
				childOverflow:-shrank
			Else
				Exit
			EndIf
		Wend
	EndMethod
	
	Method PositionChildren( children:TObjectList, hori:Int )
		Local gX:Int = Self.Gadget.GetPadding().x
		Local gY:Int = Self.Gadget.GetPadding().w
		For Local g:TLayoutGadget = EachIn children
			g.SetOuterPosition( gX, gY )
			If hori Then
				gX:+g.GetOuterSize().x + Self.GetSpacingWidth()
			Else
				gY:+g.GetOuterSize().y + Self.GetSpacingHeight()
			EndIf
		Next
	EndMethod
EndType
