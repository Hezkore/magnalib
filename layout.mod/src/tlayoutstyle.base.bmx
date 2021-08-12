Import "tlayoutgadget.base.bmx"

Type TLayoutStyle_Base Abstract
	Field Gadget:TLayoutGadget_Base
	Private ' Cached child data
		Field _noGrowChildrenMinSize:SVec2I
		Field _allChildrenMinSize:SVec2I
		Field _growingChildrenCount:Int
	Public
	Method GetInnerSize:SVec2I()
		Return Self.Gadget.GetInnerSize()
	EndMethod
	Method GetMinInnerSize:SVec2I()
		Return Self.Gadget.GetMinInnerSize()
	EndMethod
	Method GetOuterSize:SVec2I()
		Return Self.Gadget.GetOuterSize()
	EndMethod
	Method GetMinOuterSize:SVec2I()
		Return Self.Gadget.GetMinOuterSize()
	EndMethod
	Method _cacheChildrenInfo()
		Local allW:Int
		Local allH:Int
		Local noGrowW:Int
		Local noGrowH:Int
		Self._growingChildrenCount = 0
		For Local g:TLayoutGadget_Base = EachIn Self.Gadget.Children
			allW:+g.GetMinOuterSize().x
			allH:+g.GetMinOuterSize().y
			If g.GetGrow() Then
				Self._growingChildrenCount:+1
			Else
				noGrowW:+g.GetMinOuterSize().x
				noGrowH:+g.GetMinOuterSize().y
			EndIf
		Next
		allW:+Self.GetSpacingWidth() * ( Self.Gadget.Children.Count() - 1 )
		allH:+Self.GetSpacingHeight() * ( Self.Gadget.Children.Count() - 1 )
		noGrowW:+Self.GetSpacingWidth() * ( Self.Gadget.Children.Count() - 1 )
		noGrowH:+Self.GetSpacingHeight() * ( Self.Gadget.Children.Count() - 1 )
		Self._allChildrenMinSize = New Svec2I( allW, allH )
		Self._noGrowChildrenMinSize = New Svec2I( noGrowW, noGrowH )
	EndMethod
	Method RecalculateChildren( children:TObjectList ) Abstract
	Method GetChildrenMinSize:SVec2I( noGrow:Int = True )
		If noGrow Then Return Self._noGrowChildrenMinSize
		Return Self._allChildrenMinSize
	EndMethod
	Method GetChildrenOverflow:SVec2I()
		Local w:Int = Self.Gadget.GetInnerSize().x
		Local h:Int = Self.Gadget.GetInnerSize().y
		For Local g:TLayoutGadget_Base = EachIn Self.Gadget.Children
			w:-g.GetOuterSize().x
			h:-g.GetOuterSize().y
		Next
		w:-Self.GetSpacingWidth() * ( Self.Gadget.Children.Count() - 1 )
		h:-Self.GetSpacingHeight() * ( Self.Gadget.Children.Count() - 1 )
		Return New Svec2I( w * -1, h * -1 )
	EndMethod
	Method GetGrowingChildrenCount:Int()
		Return Self._growingChildrenCount
	EndMethod
	Method ShrinkChild:SVec2I( child:TLayoutGadget_Base, shrinkX:Int, shrinkY:Int )
		If Not child Then Return New SVec2I( 0, 0 )
		Local oldSize:SVec2I = child.GetSize()
		child.SetOuterSize( ..
			Max( 0, child.GetOuterSize().x - shrinkX ), ..
			Max( 0, child.GetOuterSize().y - shrinkY ) )
		Return oldSize - child.GetOuterSize()
	EndMethod
	Method _getLargestChild:TLayoutGadget_Base( testX:Int, testY:Int )
		Local largestChild:TLayoutGadget_Base
		
		' Attempt to get child above min size
		For Local g:TLayoutGadget_Base = EachIn Self.Gadget.Children
			If g.GetSize().x <= g.GetMinSize().x Then Continue
			If g.GetSize().y <= g.GetMinSize().y Then Continue
			If largestChild And largestChild = g Then Continue
			If Not largestChild Then
				largestChild = g
			Else
				If testX And largestChild.GetSize().x < g.GetSize().x Then largestChild = g
				If testY And largestChild.GetSize().y < g.GetSize().y Then largestChild = g
			EndIf
		Next
		
		' Any child
		If Not largestChild Then
			For Local g:TLayoutGadget_Base = EachIn Self.Gadget.Children
				If largestChild And largestChild = g Then Continue
				If Not largestChild Then
					largestChild = g
				Else
					If testX And largestChild.GetSize().x < g.GetSize().x Then largestChild = g
					If testY And largestChild.GetSize().y < g.GetSize().y Then largestChild = g
				EndIf
			Next
		EndIf
		
		Return largestChild
	EndMethod
	Method GetLargestXChild:TLayoutGadget_Base()
		Return Self._getLargestChild( True, False )
	EndMethod
	Method GetLargestYChild:TLayoutGadget_Base()
		Return Self._getLargestChild( False, True )
	EndMethod
	Method GetSpacingWidth:Int()
		Return Self.Gadget.GetSpacingWidth()
	EndMethod
	Method GetSpacingHeight:Int()
		Return Self.Gadget.GetSpacingHeight()
	EndMethod
EndType