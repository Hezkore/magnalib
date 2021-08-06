Import brl.reflection
Import brl.objectlist
Import brl.vector

Type TLayoutGadget_Header Abstract
	' CONST
	Const META_PROPERTY:String = "gadgetProperty"
	Const FALLBACK_STYLE:String = "StackHorizontal"
	Const FALLBACK_GADGET:String = "Panel"
	
	' Gadget identifier
	Field Id:String
	
	Field Children:TObjectList = New TObjectList
	Field Parent:TLayoutGadget_Header
	
	Private
		' Internal fields
		Field _dirty:Int = True	' Needs to be recalculated
		Field _minSize:SVec2I
		Field _position:SVec2I
		Field _enumIndex:UInt	' Child enumerator index
		Field _cachedTypeHash:ULong
		
		' Default gadget properties
		Field Text:String				{gadgetProperty}
		Field Grow:Int					{gadgetProperty}
		Field Width:Int				{gadgetProperty}
		Field Height:Int				{gadgetProperty}
		
		Field MarginTop:Int = 0		{gadgetProperty}
		Field MarginRight:Int = 0	{gadgetProperty}
		Field MarginBottom:Int = 0	{gadgetProperty}
		Field MarginLeft:Int = 0	{gadgetProperty}
		
		Field PaddingTop:Int = 0	{gadgetProperty}
		Field PaddingRight:Int = 0	{gadgetProperty}
		Field PaddingBottom:Int = 0{gadgetProperty}
		Field PaddingLeft:Int = 0	{gadgetProperty}
		
		Field BorderTop:Int			{gadgetProperty}
		Field BorderRight:Int		{gadgetProperty}
		Field BorderBottom:Int		{gadgetProperty}
		Field BorderLeft:Int			{gadgetProperty}
		
		Field SpacingWidth:Int = 16 {gadgetProperty}
		Field SpacingHeight:Int = 16{gadgetProperty}
	Public
	
	Method _recalculateChildrenIfNeeded() Abstract
	Method IterceptPropertyChange:Int( key:String, value:Object ) Abstract
	
	Rem
	bbdoc: Get gadget type in hash format
	about: GetTypeHash = "Panel".Hash()
	EndRem
	Method GetTypeHash:ULong()
		If Not Self._cachedTypeHash Then
			Self._cachedTypeHash = TTypeId.ForObject( Self ).Name()[7..].Hash()
		EndIf
		Return Self._cachedTypeHash
	EndMethod
	
	Rem
	bbdoc: Get gadget text
	EndRem
	Method GetText:String()
		Return Self.Text
	EndMethod
	
	Rem
	bbdoc: Set gadget text
	EndRem
	Method SetText( value:Int )
		If Not Self.Text = value Then
			Self.Text = value
			Self.SetNeedsRefresh()
		EndIf
	EndMethod
	
	Rem
	bbdoc: Get gadget grow state
	EndRem
	Method GetGrow:Int()
		Return Self.Grow
	EndMethod
	
	Rem
	bbdoc: Set gadget grow state
	EndRem
	Method SetGrow( value:Int )
		If Not Self.Grow = value Then
			Self.Grow = value
			Self.SetNeedsRefresh()
		EndIf
	EndMethod
	
	Rem
	bbdoc: Set the size of the gadget
	EndRem
	Method SetSize( width:Int, height:Int )
		Self.Width = width
		Self.Height = height
		Self.SetNeedsRefresh()
	EndMethod
	
	Rem
	bbdoc: Get the current size of the gadget
	EndRem
	Method GetSize:SVec2I()
		Return New SVec2I( Self.Width, Self.Height )
	EndMethod
	
	Rem
	bbdoc: Set the minimum size of the gadget
	EndRem
	Method SetMinSize( width:Int, height:Int )
		Self._minSize = New SVec2I( width, height )
		Self._dirty = True
	EndMethod
	
	Rem
	bbdoc: Get the minimum size of the gadget
	EndRem
	Method GetMinSize:SVec2I()
		Return Self._minSize
	EndMethod
	
	Rem
	bbdoc: Get gadget current size with inner padding
	EndRem
	Method GetInnerSize:SVec2I()
		Return Self.GetSize() - New SVec2I( ..
			Self.PaddingLeft + Self.PaddingRight,..
			Self.PaddingTop + Self.PaddingBottom )
	EndMethod
	
	Rem
	bbdoc: Get gadget current size with outer margin
	EndRem
	Method GetOuterSize:SVec2I()
		Return Self.GetSize() + New SVec2I( ..
			Self.MarginLeft + Self.MarginRight,..
			Self.MarginTop + Self.MarginBottom )
	EndMethod
	
	Rem
	bbdoc: Set the position of the gadget
	EndRem
	Method SetPosition( x:Int, y:Int )
		Self._position = New SVec2I( x, y )
	EndMethod
	
	Rem
	bbdoc: Get the current position of the gadget
	EndRem
	Method GetPosition:SVec2I()
		If Self.Parent Then ..
			Return New SVec2I( ..
				Self._position.x + Self.Parent.GetPosition().x,..
				Self._position.y + Self.Parent.GetPosition().y )
		Return Self._position
	EndMethod
	
	Rem
	bbdoc: Get gadget border size
	EndRem
	Method GetBorder:SVec4I()
		Return New SVec4I( Self.BorderTop, Self.BorderRight, Self.BorderBottom, Self.BorderLeft  )
	EndMethod
	
	Rem
	bbdoc: Set gadget border size
	EndRem
	Method SetBorder( value:SVec4I )
		If Not Self.BorderTop = value.x Then
			Self.BorderTop = value.x
			Self.SetNeedsRefresh()
		EndIf
		
		If Not Self.BorderRight = value.y Then
			Self.BorderRight = value.y
			Self.SetNeedsRefresh()
		EndIf
		
		If Not Self.BorderBottom = value.z Then
			Self.BorderBottom = value.z
			Self.SetNeedsRefresh()
		EndIf
		
		If Not Self.BorderLeft = value.w Then
			Self.BorderLeft = value.w
			Self.SetNeedsRefresh()
		EndIf
	EndMethod
	
	Rem
	bbdoc: Get gadget margin size
	EndRem
	Method GetMargin:SVec4I()
		Return New SVec4I( Self.MarginTop, Self.MarginRight, Self.MarginBottom, Self.MarginLeft  )
	EndMethod
	
	Rem
	bbdoc: Set gadget margin size
	EndRem
	Method SetMargin( value:SVec4I )
		If Not Self.MarginTop = value.x Then
			Self.MarginTop = value.x
			Self.SetNeedsRefresh()
		EndIf
		
		If Not Self.MarginRight = value.y Then
			Self.MarginRight = value.y
			Self.SetNeedsRefresh()
		EndIf
		
		If Not Self.MarginBottom = value.z Then
			Self.MarginBottom = value.z
			Self.SetNeedsRefresh()
		EndIf
		
		If Not Self.MarginLeft = value.w Then
			Self.MarginLeft = value.w
			Self.SetNeedsRefresh()
		EndIf
	EndMethod
	
	Rem
	bbdoc: Get gadget padding size
	EndRem
	Method GetPadding:SVec4I()
		Return New SVec4I( Self.PaddingTop, Self.PaddingRight, Self.PaddingBottom, Self.PaddingLeft  )
	EndMethod
	
	Rem
	bbdoc: Set gadget padding size
	EndRem
	Method SetPadding( value:SVec4I )
		If Not Self.PaddingTop = value.x Then
			Self.PaddingTop = value.x
			Self.SetNeedsRefresh()
		EndIf
		
		If Not Self.PaddingRight = value.y Then
			Self.PaddingRight = value.y
			Self.SetNeedsRefresh()
		EndIf
		
		If Not Self.PaddingBottom = value.z Then
			Self.PaddingBottom = value.z
			Self.SetNeedsRefresh()
		EndIf
		
		If Not Self.PaddingLeft = value.w Then
			Self.PaddingLeft = value.w
			Self.SetNeedsRefresh()
		EndIf
	EndMethod
	
	Rem
	bbdoc: Get gadget child spacing size
	EndRem
	Method GetSpacing:SVec2I()
		Return New SVec2I( Self.SpacingWidth, Self.SpacingHeight  )
	EndMethod
	
	Rem
	bbdoc: Set gadget child spacing size
	EndRem
	Method SetSpacing( value:SVec2I )
		If Not Self.SpacingWidth = value.x Then
			Self.SpacingWidth = value.x
			SetNeedsRefresh()
		EndIf
		
		If Not Self.SpacingHeight = value.y Then
			Self.SpacingHeight = value.y
			SetNeedsRefresh()
		EndIf
	EndMethod
	
	Rem
	bbdoc: Set the gadget dirty flag
	EndRem
	Method SetNeedsRefresh( dirty:Int = True )
		Self._dirty = dirty
	EndMethod
	
	Rem
	bbdoc: Get the gadget dirty state
	EndRem
	Method GetNeedsRefresh:Int()
		Return Self._dirty
	EndMethod
	
	' Enumerator
	Method ObjectEnumerator:TLayoutGadget_Header()
		Self._recalculateChildrenIfNeeded()
		Return Self
	EndMethod
	
	Method HasNext:Int()
		If Self._enumIndex < Self.Children.Count() Then
			Return True
		Else
			Self._enumIndex = 0
			Return False
		EndIf
	EndMethod
	
	Method NextObject:Object()
		Self._enumIndex:+1
		Return TLayoutGadget_Header( Children.ValueAtIndex( Self._enumIndex - 1) )
	EndMethod
EndType