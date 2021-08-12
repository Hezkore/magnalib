Import brl.standardio
Import brl.reflection

Import "tlayoutgadget.base.bmx"
Import "tlayoutstyle.base.bmx"
Import "gadgetproperties.bmx"

Rem
bbdoc: Base layout gadget
about: Extend your gadget from this type
Has the following special properties:
layout = [Stack/Wrap][Hori/Vert]
size = x, y (if y is not defined then x will be used)
EndRem
Type TLayoutGadget Extends TLayoutGadget_Base
	Private
		Field _layoutStyle:TLayoutStyle_Base
	Public
	
	Method _recalculateChildrenIfNeeded()
		If Self.GetNeedsRefresh() Then
			Self.SetNeedsRefresh( False )
			If Self.Children.Count() > 0 Then ' Is this a good idea?
				'For Local g:TLayoutGadget = EachIn Self
					'If g.GetNeedsRefresh() Then g.RefreshLayout()
				'Next
				' Use fallback style if no style defined
				If Not Self._layoutStyle Then ..
					Self.SetLayoutStyle( TLayoutGadget.FALLBACK_STYLE )
				' Update style
				Self._layoutStyle._cacheChildrenInfo()
				Self._layoutStyle.RecalculateChildren( Self.Children )
			EndIf
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
		Self._layoutStyle = TLayoutStyle_Base( id.NewObject() )
		Self._layoutStyle.Gadget = Self
	EndMethod
	
	Rem
	bbdoc:
	EndRem
	Method GetLayoutStyle:TLayoutStyle_Base()
		Return Self._layoutStyle
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
					Self.SetMinSize( Int( xy[0].Trim() ), Int( xy[1].Trim() ) )
					Self.SetSize( Int( xy[0].Trim() ), Int( xy[1].Trim() ) )
				EndIf
				Return True
			
			Case "margin","padding"
				Local size:String[] = String( value ).ToLower().Split( " " )
				If size.Length > 0 Then
					Local top:Int, right:Int, bottom:Int, left:Int
					If size.Length >= 4 Then
						top = Int( size[0] )
						right = Int( size[1] )
						bottom = Int( size[2] )
						left = Int( size[3] )
					EndIf
					If size.Length = 3 Then
						top = Int( size[0] )
						right = Int( size[1] )
						bottom = Int( size[2] )
						left = Int( size[1] )
					EndIf
					If size.Length = 2 Then
						top = Int( size[0] )
						right = Int( size[1] )
						bottom = Int( size[0] )
						left = Int( size[1] )
					EndIf
					If size.Length = 1 Then
						top = Int( size[0] )
						right = Int( size[0] )
						bottom = Int( size[0] )
						left = Int( size[0] )
					EndIf
					If key = "margin" Then
						Self.SetMargin( New SVec4I( top, right, bottom, left ) )
					Else
						Self.SetPadding( New SVec4I( top, right, bottom, left ) )
					EndIf
				EndIf
				Return True
				
			Case "spacing"
			Local size:String[] = String( value ).ToLower().Split( " " )
				If size.Length > 0 Then
					Local width:Int, height:Int
					If size.Length = 2 Then
						width = Int( size[0] )
						height = Int( size[1] )
					EndIf
					If size.Length = 1 Then
						width = Int( size[0] )
						height = Int( size[0] )
					EndIf
					Self.SetSpacing( New SVec2I( width, height ) )
				EndIf
				Return True
				
			Case "width"
				Local v:Int = Int( String( value ).Trim() )
				Self.SetMinSize( v, Self.GetMinSize().y )
				Return True
				
			Case "height"
				Local v:Int = Int( String( value ).Trim() )
				Self.SetMinSize( Self.GetMinSize().x, v )
				Return True
		EndSelect
		Return False
	EndMethod
EndType