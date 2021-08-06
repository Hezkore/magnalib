SuperStrict

' Dependencies
Import brl.collections
Import brl.standardio
Import brl.linkedlist
Import brl.reflection
Import brl.vector

Import "src/tlayoutstyle.bmx"
Import "src/tlayoutgadget.bmx"

rem
	bbdoc: Interface
	about:
	Magna interface layout
endrem
Module magna.layout

ModuleInfo "Author: Rob C."
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2021 Rob C."

Type TLayoutStyle Abstract
	Field Parent:TLayoutGadget
	Method RecalculateChildren() Abstract
EndType

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

Rem
bbdoc: Base layout gadget
about: Extend your gadget from this type
Has the following special properties:
layout = [Stack/Wrap][Hori/Vert]
size = x, y (if y is not defined then x will be used)
EndRem
Type TLayoutGadget Abstract
	' CONST
	Const META_PROPERTY:String = "gadgetProperty"
	Const FALLBACK_STYLE:String = "StackHorizontal"
	Const FALLBACK_GADGET:String = "Panel"
	
	' Gadget identifier
	Field Id:String
	
	Field Children:TList = New TList
	Field Parent:TLayoutGadget
	
	' Internal fields
	Private
		Field _dirty:Int = True	' Needs to be recalculated
		Field _minSize:SVec2I
		Field _position:SVec2I
		Field _layoutStyle:TLayoutStyle
			
		Field _enumIndex:UInt	' Child enumerator
	Public
	
	' Default gadget properties
	Private
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
	
	' Default property quick access
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
			NeedsRefresh()
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
			NeedsRefresh()
		EndIf
	EndMethod
	
	Rem
	bbdoc: Set the size of the gadget
	EndRem
	Method SetSize( width:Int, height:Int )
		Self.Width = width
		Self.Height = height
		Self._dirty = True
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
			NeedsRefresh()
		EndIf
		
		If Not Self.BorderRight = value.y Then
			Self.BorderRight = value.y
			NeedsRefresh()
		EndIf
		
		If Not Self.BorderBottom = value.z Then
			Self.BorderBottom = value.z
			NeedsRefresh()
		EndIf
		
		If Not Self.BorderLeft = value.w Then
			Self.BorderLeft = value.w
			NeedsRefresh()
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
			NeedsRefresh()
		EndIf
		
		If Not Self.MarginRight = value.y Then
			Self.MarginRight = value.y
			NeedsRefresh()
		EndIf
		
		If Not Self.MarginBottom = value.z Then
			Self.MarginBottom = value.z
			NeedsRefresh()
		EndIf
		
		If Not Self.MarginLeft = value.w Then
			Self.MarginLeft = value.w
			NeedsRefresh()
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
			NeedsRefresh()
		EndIf
		
		If Not Self.PaddingRight = value.y Then
			Self.PaddingRight = value.y
			NeedsRefresh()
		EndIf
		
		If Not Self.PaddingBottom = value.z Then
			Self.PaddingBottom = value.z
			NeedsRefresh()
		EndIf
		
		If Not Self.PaddingLeft = value.w Then
			Self.PaddingLeft = value.w
			NeedsRefresh()
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
			NeedsRefresh()
		EndIf
		
		If Not Self.SpacingHeight = value.y Then
			Self.SpacingHeight = value.y
			NeedsRefresh()
		EndIf
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method SetLayoutStyle( style:String )
		Local id:TTypeId
		If style Then
			style = "TLayoutStyle" + style
			id = TTypeId.ForName( style )
		EndIf
		If Not id Then ' Fallback
			style = "TLayoutStyle" + TLayoutGadget.FALLBACK_STYLE
			id = TTypeId.ForName( style )
		EndIf
		Self._layoutStyle = TLayoutStyle( id.NewObject() )
		Self._layoutStyle.Parent = Self
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method GetLayoutStyle:TLayoutStyle()
		Return Self._layoutStyle
	EndMethod
	
	' New
	' Remember that Self is always TLayoutGadget at this stage
	' Hench why SetProperties cannot be used here
	Method New( id:String = "", minWidth:Int = 0, minHeight:Int = 0 )
		Self.Id = id
		Self.SetMinSize( minWidth, minHeight )
	EndMethod
	
	Rem
	bbdoc: Set fields with the gadgetProperty meta data
	about: Example SetProperties( ["key", value, "key2", value2] )
	EndRem
	Method SetProperties( prop:Object[] )
		SetGadgetProperties( Self, prop )
	EndMethod
	
	Rem
	bbdoc: Get all fields with the gadgetProperty meta data
	about: Does not return any intercepted property changes
	EndRem
	Method GetProperties:String[]()
		Return GetGadgetProperties( Self )
	EndMethod
	
	Rem
	bbdoc: Get the value from a single property
	EndRem
	Method GetProperty:Object( prop:String )
		Local id:TTypeId = TTypeId.ForObject( Self )
		Local fld:TField = id.FindField( prop )
		If fld.HasMetaData( TLayoutGadget.META_PROPERTY ) Then Return fld.Get( Self )
		Return Null
	EndMethod
	
	Rem
	bbdoc: The last added child gadget
	EndRem
	Method AddGadget( gadget:Object )
		If Not gadget Return
		Self._dirty = True
		TLayoutGadget( gadget ).Parent = Self
		ListAddLast( Self.Children, TLayoutGadget( gadget ) )
		Self._recalculateChildrenIfNeeded()
	EndMethod
	
	Method AddGadget( gadgets:Object[] )
		If Not gadgets Or gadgets.Length <= 0 Return
		Self._dirty = True
		
		For Local g:TLayoutGadget = EachIn gadgets
			g.Parent = Self
			ListAddLast( Self.Children, g )
		Next
		
		Self._recalculateChildrenIfNeeded()
	EndMethod
	
	Rem
	bbdoc: The first added child gadget
	EndRem
	Method FirstGadget:TLayoutGadget()
		Return TLayoutGadget( Children.First() )
	EndMethod
	
	Rem
	bbdoc: The last added child gadget
	EndRem
	Method LastGadget:TLayoutGadget()
		Return TLayoutGadget( Children.Last() )
	EndMethod
	
	Rem
	bbdoc: Refresh gadget and all of it children
	EndRem
	Method Refresh()
		Self._dirty = True
		Self._recalculateChildrenIfNeeded()
	EndMethod
	
	Rem
	bbdoc: Flags the gadget as dirty
	EndRem
	Method NeedsRefresh()
		Self._dirty = True
	EndMethod
	
	Rem
	bbdoc: Intercept any property change
	about: The proprety does not need to exist.
	Remember to call Self.NeedsRefresh() to flag as dirty if changes are made
	returns: True halts the property change while False allows any potential property change
	EndRem
	Method IterceptPropertyChange:Int( key:String, value:Object )
		key = key.ToLower()
		Select key
			Case "layout"
				Self.SetLayoutStyle( String( value ).ToLower().Trim() )
				Return True
				
			Case "size"
				Local xy:String[] = String( value ).ToLower().Split( " " )
				If xy.Length > 0 Then
					If xy.Length = 1 Then xy = xy[..2]; xy[1] = xy[0]
					If Self.Grow Then
						Self.SetMinSize( Int( xy[0].Trim() ), Int( xy[1].Trim() ) )
					Else
						Self.SetSize( Int( xy[0].Trim() ), Int( xy[1].Trim() ) )
					EndIf
				EndIf
				Return True
			
			Case "width"
				Local v:Int = Int( String( value ).Trim() )
				If Self.Grow Then
					Self.SetMinSize( v, Self.GetMinSize().y )
				Else
					Self.SetSize( v, Self.GetMinSize().y )
				EndIf
				Return True
				
			Case "height"
				Local v:Int = Int( String( value ).Trim() )
				If Self.Grow Then
					Self.SetMinSize( Self.GetMinSize().x, v )
				Else
					Self.SetSize( Self.GetMinSize().x, v)
				EndIf
				Return True
			
		EndSelect
		
		Return False
	EndMethod
	
	Method _recalculateChildrenIfNeeded()
		If Self._dirty Then
			Self._dirty = False
			If Self.Children.Count() > 0 Then ' Is this a good idea?
				' Use fallback style if no style defined
				If Not Self._layoutStyle Then ..
					Self.SetLayoutStyle( TLayoutGadget.FALLBACK_STYLE )
				' Update style
				Self._layoutStyle.RecalculateChildren()
				For Local g:TLayoutGadget = EachIn Self
					g._dirty = True
				Next
			EndIF
		EndIf
	EndMethod
	
	' Enumerator
	Method ObjectEnumerator:TLayoutGadget()
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
		Return TLayoutGadget( Children.ValueAtIndex( Self._enumIndex - 1) )
	EndMethod
EndType

Function SetGadgetProperties( gadget:TLayoutGadget, prop:Object[], overrideGadgetType:String = "" )
	If Not gadget Or prop.Length <= 0 Return
	
	Local id:TTypeId
	If overrideGadgetType Then
		id = TTypeId.ForName( overrideGadgetType )
	Else
		id = TTypeId.ForObject( gadget )
	EndIf
	
	Local propAsString:String
	Local fld:TField
	Local findField:String
	Local split:String
	Local key:String
	Local value:Object
	Local skip:Int
	
	For Local i:Int = 0 Until prop.Length
		If skip Then
			' Skip segmented data value
			skip = False
			Continue
		EndIf
		propAsString = String( prop[i] )
		key = propAsString[..propAsString.Find( "=" )]
		
		' Find value
		If key.Length <= 0 Then
			' Data is segmented
			' (the next property is the value)
			skip = True
			key = propAsString
			value = prop[i + 1]
		Else
			' Simple text change
			value = propAsString[key.Length + 1..]
		EndIf
		
		' Attempt to intercept the property change
		If gadget.IterceptPropertyChange( key, value ) Then Continue
		
		' Find the actual field
		fld = id.FindField( key )
		
		' Make sure the field is valid and not the same as value
		If Not fld Or Not fld.HasMetaData( TLayoutGadget.META_PROPERTY ) Then Continue
		If value = fld.Get( gadget ) Then Continue
		
		gadget._dirty = True
		fld.Set( gadget, value )
	Next
EndFunction

Function GetGadgetProperties:String[]( gadget:Object )
	If Not gadget Return []
	
	Local result:TStack<String> = New TStack<String>
	Local id:TTypeId = TTypeId.ForObject( gadget )
	
	For Local fld:TField = EachIn id.EnumFields()
		If Not fld.HasMetaData( TLayoutGadget.META_PROPERTY ) Then Continue
		result.Push( fld.Name() )
	Next
	
	Return result.ToArray()
EndFunction

Function GadgetFromString:Object[]( str:String )
	Local ch:String
	Local token:String
	
	Local gadgets:TList = New TList ' Oh I wish TStack<TLayoutGadget> didn't crash
	Local gadgetId:String
	Local gadgetType:String
	Local gadgetProp:TStack<String> = New TStack<String>
	Local lastGadget:TLayoutGadget
	
	Local gadgetDepth:TList = New TList ' Again, TStack please
	
	Local inParam:Int
	Local inString:Int
	
	Local extractedKey:String
	Local extractedValue:String
	
	For Local i:Int = 0 Until str.Length
		If str[i] < 32 Then Continue ' Skip junk
		ch = Chr(str[i])
		
		If ch = "~q" Then inString = Not inString
		
		If inString Then
			If ch <> "~q" Then token:+ch
			Continue
		ElseIf inParam Then
			If ch = ")" Then
				' This creates the gadget
				inParam:-1
				If token Then
					extractedValue = token
					gadgetProp.Push( extractedKey + "=" + extractedValue )
				EndIf
				token = Null
				
				gadgetType = "TLayout" + gadgetType
				Local id:TTypeId = TTypeId.ForName( gadgetType )
				If Not id Then ' Fallback
					gadgetType = "TLayout" + TLayoutGadget.FALLBACK_GADGET
					id = TTypeId.ForName( gadgetType )
				EndIf
				lastGadget = TLayoutGadget( id.NewObject() )
				lastGadget.Id = gadgetId
				
				Print "Create Gadget: " + gadgetId + " as a " + id.Name() + " with properties " + ", ".Join( gadgetProp.ToArray() )
				
				SetGadgetProperties( lastGadget, gadgetProp.ToArray(), gadgetType )
				token = Null
				gadgetProp.Clear()
				
				If gadgetDepth.Count() > 0 Then
					TLayoutGadget( gadgetDepth.Last() ).AddGadget( lastGadget )
				Else
					gadgets.AddLast( lastGadget )
				EndIf
			ElseIf ch = ","
				extractedValue = token
				token = Null
				gadgetProp.Push( extractedKey + "=" + extractedValue )
			ElseIf ch = "="
				extractedKey = token.Trim()
				token = Null
			Else
				If ch <> "~q" Then
					If ch = " " Then
						If token.Length > 0 Then token:+ch
					Else
						token:+ch
					EndIf
				EndIf
			EndIf
		Else
			If ch = "(" Then
				inParam:+1
				gadgetId = token
				token = Null
			ElseIf ch = "#"
				gadgetType = token
				token = Null
			ElseIf ch = "{"
				gadgetDepth.AddLast( lastGadget )
			ElseIf ch = "}"
				gadgetDepth.RemoveLast()
			Else
				If ch <> " " And ch <> "~q" Then token:+ch
			EndIf
		EndIf
	Next
	
	Return gadgets.ToArray()
EndFunction

Type TLayoutPanel Extends TLayoutGadget
	
	Method New( prop:Object[] )
		Self.SetProperties( prop )
	EndMethod
	
	Method IterceptPropertyChange:Int( key:String, value:Object )
		Print "INTERCEPT"
		Super.IterceptPropertyChange( key, value )
	EndMethod
EndType

Type TLayoutButton Extends TLayoutGadget
	
	Method New( prop:Object[] )
		Self.SetProperties( prop )
	EndMethod
EndType