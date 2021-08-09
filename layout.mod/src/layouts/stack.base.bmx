Import "../tlayoutgadget.bmx"
Import "../tlayoutstyle.bmx"

Type TLayoutStyleStackBase Extends TLayoutStyle
	Method ResizeToParent( children:TObjectList, hori:Int )
		Local childMinSize:SVec2I = Self.GetChildrenMinSize()
		Local w:Int
		Local h:Int
		For Local g:TLayoutGadget = EachIn children
			If w < g.GetMinOuterSize().x Then w = g.GetMinOuterSize().x
			If h < g.GetMinOuterSize().y Then h = g.GetMinOuterSize().y
		Next
		If hori Then
			Self.Gadget.SetMinInnerSize( childMinSize.x, h )
			Self.Gadget.SetInnerSize( Max( childMinSize.x, Self.Gadget.GetInnerSize().x), Max( h, Self.Gadget.GetInnerSize().y) )
		Else
			Self.Gadget.SetMinInnerSize( w, childMinSize.y )
			Self.Gadget.SetInnerSize( Max( w, Self.Gadget.GetInnerSize().x), Max( childMinSize.y, Self.Gadget.GetInnerSize().y) )
		EndIf
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
				childOverflow:+shrank
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
