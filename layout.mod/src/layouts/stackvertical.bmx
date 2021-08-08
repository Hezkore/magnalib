Import brl.standardio

Import "stackhorizontal.bmx"

Type TLayoutStyleStackVertical Extends TLayoutStyleStackHorizontal
	
	Method ResizeChildren( children:TObjectList )
		Local childMinSize:SVec2I = Self.GetChildrenMinSize()
		Local sizeFree:Svec2I = Self.GetInnerSize() - childMinSize
		For Local g:TLayoutGadget = EachIn children
			If g.GetGrow() Then
				g.SetSize( ..
					Max( 0, Self.GetInnerSize().x ) ), ..
					Max( g.GetMinSize().y, sizeFree.y / Self.GetGrowingChildrenCount() )
			Else
				g.SetSize( Max( 0, Min( Self.GetInnerSize().x, g.GetMinSize().x ) ), g.GetMinSize().y )
			EndIf
		Next
	EndMethod
	
	Method ResizeOversize( children:TObjectList )
		Local childOverflow:Int = Self.GetChildrenOverflow().y
		While childOverflow > 0
			If Self.ShrinkChild( Self.GetLargestYChild(),  1, 0 ).y Then
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
			gY:+g.GetOuterSize().y
		Next
	EndMethod
	
	Method ResizeParent( children:TObjectList )
		Local maxX:Int
		For Local g:TLayoutGadget = EachIn children
			If maxX < g.GetMinOuterSize().x Then maxX = g.GetMinOuterSize().x
		Next
		maxX = Max( Self.Parent.GetMinSize().x, maxX )
		
		If Self.Parent.Parent Then
			Self.Parent.SetMinSize( ..
				maxX, ..
				Self.Parent.Parent.GetInnerSize().x )
		Else
			Self.Parent.SetMinSize( ..
				maxX, ..
				Self.Parent.GetMinSize().x )
		EndIf
	EndMethod
EndType
