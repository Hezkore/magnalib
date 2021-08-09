Import brl.random
Import brl.randomdefault
Import "../tlayoutgadget.bmx"
Import "stack.base.bmx"

Type TLayoutStyleWrapBase Extends TLayoutStyleStackBase
	Field gadgetWrapIndex:Int[]
	Field growersAtWrapIndex:Int[]
	Field freeSpaceAtWrapIndex:Int[]
	
	Field prevTmpMinWidth:Int
	Field prevTmpMinHeight:Int
	
	Field realMinWidth:Int
	Field realMinHeight:Int
	
	Method ResizeToParent( children:TObjectList, hori:Int )
		Local w:Int
		Local h:Int
		For Local g:TLayoutGadget = EachIn children
			If w < g.GetMinOuterSize().x Then w = g.GetMinOuterSize().x
			If h < g.GetMinOuterSize().y Then h = g.GetMinOuterSize().y
		Next
		
		Self.prevTmpMinWidth = Self.Gadget.GetMinInnerSize().x
		Self.prevTmpMinHeight = Self.Gadget.GetMinInnerSize().y
		
		Self.Gadget.ResetTmpMinSize()
		
		If hori Then
			Self.realMinWidth = Self.Gadget.GetMinInnerSize().x
			Self.realMinHeight = Max( h, Self.Gadget.GetMinInnerSize().y )
		Else
			Self.realMinWidth = Max( w, Self.Gadget.GetMinInnerSize().x )
			Self.realMinHeight = Self.Gadget.GetMinInnerSize().y
		EndIf
	EndMethod
	
	Method CalculateWrap( children:TObjectList, hori:Int )
		If Self.Gadget.GetInnerSize().x <= 0 And Self.Gadget.GetInnerSize().y <= 0 Return
		
		Self.gadgetWrapIndex = New Int[children.Count() + 1]
		Self.growersAtWrapIndex = New Int[children.Count() + 1]
		Self.freeSpaceAtWrapIndex = New Int[children.Count() + 1]
		
		For Local i:Int = 0 Until Self.freeSpaceAtWrapIndex.Length
			If hori Then
				Self.freeSpaceAtWrapIndex[i] = Self.Gadget.GetInnerSize().x
			Else
				Self.freeSpaceAtWrapIndex[i] = Self.Gadget.GetInnerSize().y
			EndIf
		Next
		
		Local wrapIndex:Int
		Local gadgetIndex:Int
		Local gX:Int = Self.Gadget.GetPadding().w
		Local gY:Int = Self.Gadget.GetPadding().x
		Local gW:Int
		Local gH:Int
		For Local g:TLayoutGadget = EachIn children
			gW = g.GetMinOuterSize().x
			gH = g.GetMinOuterSize().y
			
			If hori Then
				If gX + gW > Self.Gadget.GetInnerSize().x Then
					gX = Self.Gadget.GetPadding().w
					wrapIndex:+1
				EndIf
				
				If Not g.GetGrow() Then ..
					Self.freeSpaceAtWrapIndex[wrapIndex]:-g.GetMinOuterSize().x + Self.Gadget.GetSpacingWidth()
			Else
				If gY + gH > Self.Gadget.GetInnerSize().y Then
					gY = Self.Gadget.GetPadding().x
					wrapIndex:+1
				EndIf
				
				If Not g.GetGrow() Then ..
					Self.freeSpaceAtWrapIndex[wrapIndex]:-g.GetMinOuterSize().y + Self.Gadget.GetSpacingHeight()
			EndIf
			
			Self.gadgetWrapIndex[gadgetIndex] = wrapIndex
			Self.growersAtWrapIndex[wrapIndex]:+g.GetGrow()
			gadgetIndex:+1
			
			If hori Then
				gX:+g.GetMinOuterSize().x + Self.GetSpacingWidth()
			Else
				gY:+g.GetMinOuterSize().y + Self.GetSpacingHeight()
			EndIf
		Next
		
		wrapIndex:+1
		If hori Then
			Self.Gadget.SetTmpMinInnerSize( ..
				Self.realMinWidth, ..
				(Self.realMinHeight + Self.GetSpacingHeight()) * wrapIndex, False )
		Else
			
		EndIf
		
		If Self.prevTmpMinWidth <> Self.realMinWidth Or Self.prevTmpMinHeight <> Self.realMinHeight Then
			Local pG:TLayoutGadget_Base = Self.Gadget.Parent
			While pG
				pG.RefreshLayout()
				pG = pG.Parent
			Wend
		EndIf
	EndMethod
	
	Method ResizeChildren( children:TObjectList, hori:Int )
		If Self.Gadget.GetInnerSize().x <= 0 And Self.Gadget.GetInnerSize().y <= 0 Return
		
		Local wrapIndex:Int
		Local gadgetIndex:Int
		For Local g:TLayoutGadget = EachIn children
			wrapIndex = Self.gadgetWrapIndex[gadgetIndex]
			gadgetIndex:+1
			If g.GetGrow() Then
				If hori Then
					g.SetOuterSize( ..
						Max( g.GetMinOuterSize().x, Self.freeSpaceAtWrapIndex[wrapIndex] / Self.growersAtWrapIndex[wrapIndex] ), ..
						Self.realMinHeight )
				Else
					g.SetOuterSize( ..
						Self.realMinWidth, ..
						Max( g.GetMinOuterSize().y, Self.freeSpaceAtWrapIndex[wrapIndex] / Self.growersAtWrapIndex[wrapIndex] ) )
				EndIf
			Else
				If hori Then
					g.SetOuterSize( g.GetMinOuterSize().x, Self.realMinHeight )
				Else
					g.SetOuterSize( Self.realMinWidth, g.GetMinOuterSize().y )
				EndIf
			EndIf
		Next
	EndMethod
	
	Method PositionChildren( children:TObjectList, hori:Int )
		If Self.Gadget.GetInnerSize().x <= 0 And Self.Gadget.GetInnerSize().y <= 0 Return
		
		Local gX:Int = Self.Gadget.GetPadding().w
		Local gY:Int = Self.Gadget.GetPadding().x
		Local gW:Int
		Local gH:Int
		Local wrapIndex:Int = 0
		Local lastWrapIndex:Int = 0
		Local gadgetIndex:Int
		For Local g:TLayoutGadget = EachIn children
			gW = g.GetOuterSize().x
			gH = g.GetOuterSize().y
			
			wrapIndex = Self.gadgetWrapIndex[gadgetIndex]
			gadgetIndex:+1
			
			If hori Then
				If lastWrapIndex <> wrapIndex Then
					lastWrapIndex = wrapIndex
					gX = Self.Gadget.GetPadding().w
				EndIf
			Else
				If lastWrapIndex <> wrapIndex Then
					lastWrapIndex = wrapIndex
					gY = Self.Gadget.GetPadding().x
				EndIf
			EndIf
			
			If hori Then
				g.SetOuterPosition( ..
					gX, ..
					Self.Gadget.GetPadding().x + ..
					( Self.realMinHeight + Self.Gadget.GetSpacingHeight() ) * wrapIndex )
				
				gX:+g.GetOuterSize().x + Self.GetSpacingWidth()
			Else
				g.SetOuterPosition( ..
					Self.Gadget.GetPadding().w + ..
					( Self.realMinWidth + Self.Gadget.GetSpacingWidth() ) * wrapIndex, ..
					gY )
				
				gY:+g.GetOuterSize().y + Self.GetSpacingHeight()
			EndIf
		Next
	EndMethod
EndType
