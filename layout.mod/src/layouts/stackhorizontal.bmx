Import "../tlayoutgadget.header.bmx"
Import "../tlayoutstyle.bmx"

Type TLayoutStyleStackHorizontal Extends TLayoutStyle
	Method RecalculateChildren()
		If Not Self.Parent.Children Or Self.Parent.Children.Count() <= 0 Return
		
		rem
		Local g:TLayoutGadget
		
		' Calculate minimum occupied size of all children
		Local occupiedWidth:Int
		Local occupiedHeight:Int
		Local growCount:Int
		For g = EachIn Self
			If g.Grow Then
				growCount:+1
			EndIf
			occupiedWidth:+g.GetOuterSize( True ).x
			occupiedHeight:+g.GetOuterSize( True ).y
		Next
		occupiedWidth:+Self.GetSpacing().x * (Self.Children.Count() - 1)
		occupiedHeight:+Self.GetSpacing().y * (Self.Children.Count() - 1)
		
		Local freeWidth:Int = Self.GetInnerSize().x - occupiedWidth
		Local freeHeight:Int = Self.GetInnerSize().y - occupiedHeight
		
		' Grow children
		For g = EachIn Self
			If g.Grow Then
				g.SetGrowSize( ..
					Max( g.GetSize( True ).x, freeWidth / growCount),..
					Max( g.GetSize( True ).y, freeHeight / growCount))
			EndIf
		Next
		
		' Final occupied size calculation
		occupiedWidth = 0
		occupiedHeight = 0
		For g = EachIn Self
			occupiedWidth:+g.GetOuterSize().x
			occupiedHeight:+g.GetOuterSize().y
		Next
		occupiedWidth:+Self.GetSpacing().x * (Self.Children.Count() - 1)
		occupiedHeight:+Self.GetSpacing().y * (Self.Children.Count() - 1)
		freeWidth = Self.GetInnerSize().x - occupiedWidth
		freeHeight = Self.GetInnerSize().y - occupiedHeight
		
		Local shrinkWidth:Int
		If freeWidth < 0 Then shrinkWidth = freeWidth / Self.Children.Count()
		Local shrinkHeight:Int
		If freeHeight < 0 Then shrinkHeight = freeHeight / Self.Children.Count()
		
		If Not Self.Parent Then Print freeWidth
		
		' Shrink children if needed and always position
		Local gadgetCount:Int
		Local posX:Int = Self.GetPadding().w
		Local posY:Int = Self.GetPadding().x
		Local addX:Int
		Local addY:Int
		For g = EachIn Self
			If freeWidth < 0 Then 
			
			addX = g.GetOuterSize().x + Self.GetSpacing().x
			addY = g.GetOuterSize().y + Self.GetSpacing().y
			
			If Self.Horizontal Then
				' Horizontal
				
				If Self.Wrap Then
					' Wrap
					
				Else
					' Stack
					
				EndIf
			Else
				' Vertical
				
				If Self.Wrap Then
					' Wrap
					
				Else
					' Stack
					
				EndIf
			EndIf
			
			g.SetPosition( posX + g.GetMargin().w, posY + g.GetMargin().x )
			
			posX:+addX
			posY:+addY
			
			gadgetCount:+1
		Next
		endrem
	EndMethod
EndType
