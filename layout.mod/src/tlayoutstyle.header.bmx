Import "tlayoutgadget.header.bmx"

Type TLayoutStyle_Header Abstract
	Field Parent:TLayoutGadget_Header
	Private ' Cached child data
		Field _allChildrenMinSize:SVec2I
		Field _growingChildrenCount:Int
	Public
	Method GetInnerSize:SVec2I()
		Return Self.Parent.GetInnerSize()
	EndMethod
	Method GetMinInnerSize:SVec2I()
		Return Self.Parent.GetMinInnerSize()
	EndMethod
	Method _cacheChildrenInfo()
		Local minWidth:Int
		Local minHeight:Int
		Self._growingChildrenCount = 0
		For Local g:TLayoutGadget_Header = EachIn Self.Parent.Children
			If Not g.GetGrow() Then
				minWidth:+g.GetMinOuterSize().x
				minHeight:+g.GetMinOuterSize().y
			Else
				Self._growingChildrenCount:+1
			EndIf
		Next
		Self._allChildrenMinSize = New Svec2I( minWidth, minHeight )
	EndMethod
	Method RecalculateChildren( children:TObjectList ) Abstract
	Method GetChildrenMinSize:SVec2I()
		Return Self._allChildrenMinSize
	EndMethod
	Method GetChildrenOverflow:SVec2I()
		Local w:Int = Self.Parent.GetInnerSize().x
		Local h:Int = Self.Parent.GetInnerSize().y
		For Local g:TLayoutGadget_Header = EachIn Self.Parent.Children
			w:-g.GetOuterSize().x
			h:-g.GetOuterSize().y
		Next
		Return New Svec2I( w * -1, h * -1 )
	EndMethod
	Method GetGrowingChildrenCount:Int()
		Return Self._growingChildrenCount
	EndMethod
	Method ShrinkChild:SVec2I( child:TLayoutGadget_Header, shrinkX:Int, shrinkY:Int )
		If Not child Then Return New SVec2I( 0, 0 )
		Local oldSize:SVec2I = child.GetSize()
		child.SetSize( ..
			Max( 0, child.GetSize().x - shrinkX ), ..
			Max( 0, child.GetSize().y - shrinkY ) )
		Return oldSize - child.GetSize()
	EndMethod
	Method GetLargestXChild:TLayoutGadget_Header()
		Local largestChild:TLayoutGadget_Header
		
		' Attempt to get child above min size
		For Local g:TLayoutGadget_Header = EachIn Self.Parent.Children
			If g.GetSize().x <= g.GetMinSize().x Then Continue
			If g.GetSize().y <= g.GetMinSize().y Then Continue
			
			If largestChild And largestChild = g Then Continue
			If Not largestChild Or ..
				(largestChild And largestChild.GetSize().x < g.GetSize().x) Then ..
					largestChild = g
		Next
		
		' Any child
		If Not largestChild Then
			For Local g:TLayoutGadget_Header = EachIn Self.Parent.Children
				If largestChild And largestChild = g Then Continue
				If Not largestChild Or ..
					(largestChild And largestChild.GetSize().x < g.GetSize().x) Then ..
						largestChild = g
			Next
		EndIf
		
		Return largestChild
	EndMethod
	Method GetLargestYChild:TLayoutGadget_Header()
		Local largestChild:TLayoutGadget_Header
		
		' Attempt to get child above min size
		For Local g:TLayoutGadget_Header = EachIn Self.Parent.Children
			If g.GetSize().x <= g.GetMinSize().x Then Continue
			If g.GetSize().y <= g.GetMinSize().y Then Continue
			
			If largestChild And largestChild = g Then Continue
			If Not largestChild Or ..
				(largestChild And largestChild.GetSize().y < g.GetSize().y) Then ..
					largestChild = g
		Next
		
		' Any child
		If Not largestChild Then
			For Local g:TLayoutGadget_Header = EachIn Self.Parent.Children
				If largestChild And largestChild = g Then Continue
				If Not largestChild Or ..
					(largestChild And largestChild.GetSize().y < g.GetSize().y) Then ..
						largestChild = g
			Next
		EndIf
		
		Return largestChild
	EndMethod
EndType