Import brl.reflection
Import brl.objectlist
Import brl.vector

Type TLayoutGadget_Base Abstract
	' CONST
	Const META_PROPERTY:String = "gadgetProperty"
	Const FALLBACK_STYLE:String = "StackHorizontal"
	Const FALLBACK_GADGET:String = "Panel"
	
	' Gadget identifier
	Field Id:String
	
	Field Children:TObjectList = New TObjectList
	Field Parent:TLayoutGadget_Base
	
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
		
		Field MarginTop:Int = 1		{gadgetProperty}
		Field MarginRight:Int = 1	{gadgetProperty}
		Field MarginBottom:Int = 1	{gadgetProperty}
		Field MarginLeft:Int = 1	{gadgetProperty}
		
		Field PaddingTop:Int = 3	{gadgetProperty}
		Field PaddingRight:Int = 3	{gadgetProperty}
		Field PaddingBottom:Int = 3{gadgetProperty}
		Field PaddingLeft:Int = 3	{gadgetProperty}
		
		Field BorderTop:Int			{gadgetProperty}
		Field BorderRight:Int		{gadgetProperty}
		Field BorderBottom:Int		{gadgetProperty}
		Field BorderLeft:Int			{gadgetProperty}
		
		Field SpacingWidth:Int = 4 {gadgetProperty}
		Field SpacingHeight:Int = 2{gadgetProperty}
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
		If Self.Grow <> value Then
			Self.Grow = value
			Self.SetNeedsRefresh()
		EndIf
	EndMethod
	
	Rem
	bbdoc: Set the size of the gadget
	EndRem
	Method SetSize( width:Int, height:Int )
		If Self.Width <> width Or Self.Height <> height Then
			Self.Width = width
			Self.Height = height
			Self.SetNeedsRefresh()
		EndIf
	EndMethod
	
	Rem
	bbdoc: Get the current size of the gadget
	EndRem
	Method GetSize:SVec2I()
		Self._recalculateChildrenIfNeeded()
		Return New SVec2I( Self.Width, Self.Height )
	EndMethod
	
	Rem
	bbdoc: Set the minimum size of the gadget
	EndRem
	Method SetMinSize( width:Int, height:Int )
		If Self._minSize.x <> width Or Self._minSize.y <> height Then
			Self._minSize = New SVec2I( width, height )
			Self.SetNeedsRefresh()
		EndIf
	EndMethod
	
	Rem
	bbdoc: Get the minimum size of the gadget
	EndRem
	Method GetMinSize:SVec2I()
		Self._recalculateChildrenIfNeeded()
		Return Self._minSize
	EndMethod
	
	Rem
	bbdoc: Get gadget current size with inner padding
	EndRem
	Method GetInnerSize:SVec2I()
		Return Self.GetSize() - New SVec2I( ..
			Self.GetPaddingWidth(),..
			Self.GetPaddingHeight() )
	EndMethod
	
	Rem
	bbdoc: Set gadget current size with inner padding
	EndRem
	Method SetInnerSize( width:Int, height:Int )
		Self.SetSize( ..
			width + Self.GetPaddingWidth(), ..
			height + Self.GetPaddingHeight() )
	EndMethod
	
	Rem
	bbdoc: Get gadget minimum size with inner padding
	EndRem
	Method GetMinInnerSize:SVec2I()
		Return Self.GetMinSize() - New SVec2I( ..
			Self.GetPaddingWidth(),..
			Self.GetPaddingHeight() )
	EndMethod
	
	Rem
	bbdoc: Set gadget minimum size with inner padding
	EndRem
	Method SetMinInnerSize( width:Int, height:Int )
		Self.SetMinSize( ..
			width + Self.GetPaddingWidth(), ..
			height + Self.GetPaddingHeight() )
	EndMethod
	
	Rem
	bbdoc: Get gadget current size with outer margin
	EndRem
	Method GetOuterSize:SVec2I()
		Return Self.GetSize() + New SVec2I( ..
			Self.GetMarginWidth(), ..
			Self.GetMarginHeight() )
	EndMethod
	
	Rem
	bbdoc: Set gadget current size with outer margin
	EndRem
	Method SetOuterSize( width:Int, height:Int )
		Self.SetSize( ..
			width - Self.GetMarginWidth(), ..
			height - Self.GetMarginHeight() )
	EndMethod
	
	Rem
	bbdoc: Get gadget minimum size with outer margin
	EndRem
	Method GetMinOuterSize:SVec2I()
		Return Self.GetMinSize() + New SVec2I( ..
			Self.GetMarginWidth(), ..
			Self.GetMarginHeight() )
	EndMethod
	
	Rem
	bbdoc: Set gadget minimum size with outer margin
	EndRem
	Method SetMinOuterSize( width:Int, height:Int )
		Self.SetMinSize( ..
			width - Self.GetMarginWidth(), ..
			height - Self.GetMarginHeight() )
	EndMethod
	
	Rem
	bbdoc: Set the position of the gadget
	EndRem
	Method SetPosition( x:Int, y:Int )
		Self._position = New SVec2I( x, y )
	EndMethod
	
	Rem
	bbdoc: Set the position of the gadget with outer margin
	EndRem
	Method SetOuterPosition( x:Int, y:Int )
		SetPosition( x + Self.MarginLeft, y + Self.MarginTop )
	EndMethod
	
	Rem
	bbdoc: Set the position of the gadget with inner padding
	EndRem
	Method SetInnerPosition( x:Int, y:Int )
		SetPosition( x - Self.PaddingLeft, y - Self.PaddingTop )
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
	bbdoc: Get the inner position of the gadget
	EndRem
	Method GetInnerPosition:SVec2I()
		If Self.Parent Then ..
			Return New SVec2I( ..
				Self._position.x + Self.Parent.GetPosition().x + Self.PaddingLeft, ..
				Self._position.y + Self.Parent.GetPosition().y + Self.PaddingTop )
		Return Self._position + New SVec2I( Self.PaddingLeft, Self.PaddingTop )
	EndMethod
	
	Rem
	bbdoc: Get the outer position of the gadget
	EndRem
	Method GetOuterPosition:SVec2I()
		If Self.Parent Then ..
			Return New SVec2I( ..
				Self._position.x + Self.Parent.GetPosition().x - Self.MarginLeft, ..
				Self._position.y + Self.Parent.GetPosition().y - Self.MarginTop )
		Return Self._position - New SVec2I( Self.MarginLeft, Self.MarginTop )
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
		If Self.BorderTop <> value.x Then
			Self.BorderTop = value.x
			Self.SetNeedsRefresh()
		EndIf
		
		If Self.BorderRight <> value.y Then
			Self.BorderRight = value.y
			Self.SetNeedsRefresh()
		EndIf
		
		If Self.BorderBottom <> value.z Then
			Self.BorderBottom = value.z
			Self.SetNeedsRefresh()
		EndIf
		
		If Self.BorderLeft <> value.w Then
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
	
	Method GetMarginWidth:Int()
		Return Self.MarginRight + Self.MarginLeft
	EndMethod
	
	Method GetMarginHeight:Int()
		Return Self.MarginTop + Self.MarginBottom
	EndMethod
	
	Rem
	bbdoc: Set gadget margin size
	EndRem
	Method SetMargin( value:SVec4I )
		If Self.MarginTop <> value.x Then
			Self.MarginTop = value.x
			Self.SetNeedsRefresh()
		EndIf
		
		If Self.MarginRight <> value.y Then
			Self.MarginRight = value.y
			Self.SetNeedsRefresh()
		EndIf
		
		If Self.MarginBottom <> value.z Then
			Self.MarginBottom = value.z
			Self.SetNeedsRefresh()
		EndIf
		
		If Self.MarginLeft <> value.w Then
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
	
	Method GetPaddingWidth:Int()
		Return Self.PaddingRight + Self.PaddingLeft
	EndMethod
	
	Method GetPaddingHeight:Int()
		Return Self.PaddingTop + Self.PaddingBottom
	EndMethod
	
	Rem
	bbdoc: Set gadget padding size
	EndRem
	Method SetPadding( value:SVec4I )
		If Self.PaddingTop <> value.x Then
			Self.PaddingTop = value.x
			Self.SetNeedsRefresh()
		EndIf
		
		If Self.PaddingRight <> value.y Then
			Self.PaddingRight = value.y
			Self.SetNeedsRefresh()
		EndIf
		
		If Self.PaddingBottom <> value.z Then
			Self.PaddingBottom = value.z
			Self.SetNeedsRefresh()
		EndIf
		
		If Self.PaddingLeft <> value.w Then
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
	bbdoc: Get gadget child spacing width size
	EndRem
	Method GetSpacingWidth:Int()
		Return Self.SpacingWidth
	EndMethod
	
	Rem
	bbdoc: Get gadget child spacing height size
	EndRem
	Method GetSpacingHeight:Int()
		Return Self.SpacingHeight
	EndMethod
	
	Rem
	bbdoc: Set gadget child spacing size
	EndRem
	Method SetSpacing( value:SVec2I )
		If Self.SpacingWidth <> value.x Then
			Self.SpacingWidth = value.x
			SetNeedsRefresh()
		EndIf
		
		If Self.SpacingHeight <> value.y Then
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
	Method ObjectEnumerator:TLayoutGadget_Base()
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
		Return TLayoutGadget_Base( Children.ValueAtIndex( Self._enumIndex - 1) )
	EndMethod
EndType