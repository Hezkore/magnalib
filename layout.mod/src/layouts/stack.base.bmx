Import "../tlayoutgadget.bmx"
Import "../tlayoutstyle.bmx"

Type TLayoutStyleStackBase Extends TLayoutStyle
	
	Method ResizeToParent( children:TObjectList, hori:Int )
		If Self.Parent.Parent Then
			If hori Then
				Self.Parent.SetMinSize( ..
					Self.Parent.Parent.GetInnerSize().x, ..
					Self.Parent.GetMinSize().y )
			Else
				Self.Parent.SetMinSize( ..
					Self.Parent.GetMinSize().x, ..
					Self.Parent.Parent.GetInnerSize().y )
			EndIf
		EndIf
	EndMethod
	
	Method ResizeChildren( children:TObjectList, hori:Int )
		Local childMinSize:SVec2I = Self.GetChildrenMinSize()
		Local sizeFree:Svec2I = Self.GetInnerSize() - childMinSize
		For Local g:TLayoutGadget = EachIn children
			If g.GetGrow() Then
				If hori Then
					g.SetSize( ..
						Max( g.GetMinSize().x, sizeFree.x / Self.GetGrowingChildrenCount() ), ..
						Max( 0, Self.GetInnerSize().y ) )
				Else
					g.SetSize( ..
						Max( 0, Self.GetInnerSize().x ) ), ..
						Max( g.GetMinSize().y, sizeFree.y / Self.GetGrowingChildrenCount() )
				EndIf
			Else
				If hori Then
					g.SetSize( g.GetMinSize().x, Max( 0, Min( Self.GetInnerSize().y, g.GetMinSize().y ) ) )
				Else
					g.SetSize( Max( 0, Min( Self.GetInnerSize().x, g.GetMinSize().x ) ), g.GetMinSize().y )
				EndIf
			EndIf
		Next
	EndMethod
	
	Method ResizeOversize( children:TObjectList, hori:Int )
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
		Local gX:Int
		Local gY:Int
		For Local g:TLayoutGadget = EachIn children
			g.SetPosition( gX, gY )
			If hori Then
				gX:+g.GetOuterSize().x
			Else
				gY:+g.GetOuterSize().y
			EndIf
		Next
	EndMethod
EndType
