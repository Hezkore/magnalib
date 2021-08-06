Import brl.standardio
Import brl.reflection

Import "tlayoutgadget.header.bmx"
Import "tlayoutstyle.header.bmx"
Import "gadgetproperties.bmx"

Rem
bbdoc: Base layout gadget
about: Extend your gadget from this type
Has the following special properties:
layout = [Stack/Wrap][Hori/Vert]
size = x, y (if y is not defined then x will be used)
EndRem
Type TLayoutGadget Extends TLayoutGadget_Header
	Private
		Field _layoutStyle:TLayoutStyle_Header
	Public
	
	Method _recalculateChildrenIfNeeded()
		If Self.GetNeedsRefresh() Then
			Self.SetNeedsRefresh( False )
			If Self.Children.Count() > 0 Then ' Is this a good idea?
				' Use fallback style if no style defined
				If Not Self._layoutStyle Then ..
					Self.SetLayoutStyle( TLayoutGadget.FALLBACK_STYLE )
				' Update style
				Self._layoutStyle.RecalculateChildren( Self.Children )
				For Local g:TLayoutGadget = EachIn Self
					g.SetNeedsRefresh()
				Next
			EndIF
		EndIf
	EndMethod
	
	' Default property quick access
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
		Self._layoutStyle = TLayoutStyle_Header( id.NewObject() )
		Self._layoutStyle.Parent = Self
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method GetLayoutStyle:TLayoutStyle_Header()
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
	bbdoc: Add a single child gadget
	EndRem
	Method AddGadget( gadget:Object )
		If Not gadget Return
		Self.SetNeedsRefresh()
		TLayoutGadget( gadget ).Parent = Self
		Self.Children.AddLast( TLayoutGadget( gadget ) )
		Self._recalculateChildrenIfNeeded()
	EndMethod
	
	Rem
	bbdoc: Add multiple child gadgets
	EndRem
	Method AddGadget( gadgets:Object[] )
		If Not gadgets Or gadgets.Length <= 0 Return
		Self.SetNeedsRefresh()
		
		For Local g:TLayoutGadget = EachIn gadgets
			g.Parent = Self
			Self.Children.AddLast( g )
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
	bbdoc: Refresh the current layout
	EndRem
	Method RefreshLayout()
		Self.SetNeedsRefresh()
		Self._recalculateChildrenIfNeeded()
	EndMethod
	
	Rem
	bbdoc: Intercept any property change
	about: The proprety does not need to exist
	Remember to call Self.NeedsRefresh() to flag as dirty if changes are made
	returns: True halts the property change while False allows any potential property change
	EndRem
	Method IterceptPropertyChange:Int( key:String, value:Object )
		key = key.ToLower()
		Select key
			Case "layout"
				Self.SetLayoutStyle( String( value ).ToLower().Trim() )
				Return True
				
			Case "pos"
				Local xy:String[] = String( value ).ToLower().Split( " " )
				If xy.Length > 0 Then
					If xy.Length = 1 Then xy = xy[..2]; xy[1] = xy[0]
					Self.SetPosition( Int( xy[0].Trim() ), Int( xy[1].Trim() ) )
				EndIf
				Return True
				
			Case "size"
				Local xy:String[] = String( value ).ToLower().Split( " " )
				If xy.Length > 0 Then
					If xy.Length = 1 Then xy = xy[..2]; xy[1] = xy[0]
					If Self.GetGrow() Then
						Self.SetMinSize( Int( xy[0].Trim() ), Int( xy[1].Trim() ) )
					Else
						Self.SetSize( Int( xy[0].Trim() ), Int( xy[1].Trim() ) )
					EndIf
				EndIf
				Return True
			
			Case "width"
				Local v:Int = Int( String( value ).Trim() )
				If Self.GetGrow() Then
					Self.SetMinSize( v, Self.GetMinSize().y )
				Else
					Self.SetSize( v, Self.GetMinSize().y )
				EndIf
				Return True
				
			Case "height"
				Local v:Int = Int( String( value ).Trim() )
				If Self.GetGrow() Then
					Self.SetMinSize( Self.GetMinSize().x, v )
				Else
					Self.SetSize( Self.GetMinSize().x, v)
				EndIf
				Return True
			
		EndSelect
		
		Return False
	EndMethod
EndType