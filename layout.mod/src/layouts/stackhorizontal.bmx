Import brl.standardio

Import "../tlayoutgadget.bmx"
Import "../tlayoutstyle.bmx"

Type TLayoutStyleStackHorizontal Extends TLayoutStyle
	Method RecalculateChildren( children:TObjectList )
		Self.ResizeParent( children )
		Self.ResizeChildren( children )
		Self.ResizeOversize( children )
		Self.PositionChildren( children )
	EndMethod
	
	Method ResizeChildren( children:TObjectList )
		Local childMinSize:SVec2I = Self.GetChildrenMinSize()
		Local sizeFree:Svec2I = Self.GetInnerSize() - childMinSize
		For Local g:TLayoutGadget = EachIn children
			If g.GetGrow() Then
				g.SetSize( ..
					Max( g.GetMinSize().x, sizeFree.x / Self.GetGrowingChildrenCount() ), ..
					Max( 0, Self.GetInnerSize().y ) )
			Else
				g.SetSize( g.GetMinSize().x, Max( 0, Min( Self.GetInnerSize().y, g.GetMinSize().y ) ) )
			EndIf
		Next
	EndMethod
	
	Method ResizeOversize( children:TObjectList )
		Local childOverflow:Int = Self.GetChildrenOverflow().x
		While childOverflow > 0
			If Self.ShrinkChild( Self.GetLargestXChild(),  1, 0 ).x Then
				childOverflow:-1
			Else
				Exit
			EndIf
		Wend
	EndMethod
	
	Method PositionChildren( children:TObjectList )
		Local gX:Int
		Local gY:Int
		For Local g:TLayoutGadget = EachIn children
			g.SetPosition( gX, gY )
			gX:+g.GetOuterSize().x
		Next
	EndMethod
	
	Method ResizeParent( children:TObjectList )
		Local maxY:Int
		For Local g:TLayoutGadget = EachIn children
			If maxY < g.GetMinOuterSize().y Then maxY = g.GetMinOuterSize().y
		Next
		maxY = Max( Self.Parent.GetMinSize().y, maxY )
		
		If Self.Parent.Parent Then
			Self.Parent.SetMinSize( ..
				Self.Parent.Parent.GetInnerSize().x, ..
				maxY )
		Else
			Self.Parent.SetMinSize( ..
				Self.Parent.GetMinSize().x, ..
				maxY )
		EndIf
	EndMethod
EndType
