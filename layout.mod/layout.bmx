SuperStrict

' Dependencies
Import brl.standardio
Import brl.linkedlist
Import brl.vector

rem
	bbdoc: Interface
	about:
	Magna interface layout
endrem
Module magna.layout

ModuleInfo "Author: Rob C."
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2021 Rob C."

Enum ELayoutStyle
	StackHorizontal
	StackVertical
	WrapHorizontal
	WrapVertical
EndEnum

Type TLayout Extends TLayoutContainer
EndType

Type TLayoutGadget
	
	Field Children:TList = New TList
	Field Parent:TLayoutGadget
	
	Field Id:String
	
	Field _grow:SVec2I = New SVec2I( 1, 1 )
	Field _dirty:Int = True
	Field _position:SVec2I
	Field _fixedSize:SVec2I = New SVec2I( -1, -1 )
	Field _growSize:SVec2I
	Field _layoutStyle:ELayoutStyle = ELayoutStyle.StackHorizontal
	Field _text:String
	
	Field _enumIndex:UInt

	Method New( id:String, width:Int, height:Int, text:String = "" )
		Self.Id = id
		Self._fixedSize = New SVec2I( width, height )
		Self._text = text
	EndMethod
	
	Method New( id:String, width:Int, height:Int, layoutStyle:ELayoutStyle )
		Self.Id = id
		Self._fixedSize = New SVec2I( width, height )
		Self._layoutStyle = layoutStyle
	EndMethod
	
	Method New( id:String, text:String = "" )
		Self.Id = id
		Self._text = text
	EndMethod
	
	Method New( id:String, layoutStyle:ELayoutStyle )
		Self.Id = id
		Self._layoutStyle = layoutStyle
	EndMethod
	
	Method New( width:Int = -1, height:Int = -1, layoutStyle:ELayoutStyle = ELayoutStyle.StackHorizontal )
		Self._fixedSize = New SVec2I( width, height )
		Self._layoutStyle = layoutStyle
	EndMethod
	
	Method FirstGadget:TLayoutGadget()
		Return TLayoutGadget( Children.First() )
	EndMethod
	
	Method LastGadget:TLayoutGadget()
		Return TLayoutGadget( Children.Last() )
	EndMethod
	
	Method AddGadget( gadget:TLayoutGadget )
		Self._dirty = True
		gadget.Parent = Self
		ListAddLast( Self.Children, gadget )
		Self._recalculateChildrenIfNeeded()
	EndMethod
	
	Method GadgetSize:SVec2I()
		Self._recalculateChildrenIfNeeded()
		
		If Self.Grow.x And Self.Grow.y Then Return Self._growSize
		If Self.Grow.x And Not Self.Grow.y Then ..
			Return New SVec2I( Self._growSize.x, Self._fixedSize.y )
		If Not Self.Grow.x And Self.Grow.y Then ..
			Return New SVec2I( Self._fixedSize.x, Self._growSize.y )
		Return Self._fixedSize
	EndMethod
	
	Method GadgetPosition:SVec2I()
		Self._recalculateChildrenIfNeeded()
		Return Self._position
	EndMethod
	
	Method Grow:SVec2I()
		Self._recalculateChildrenIfNeeded()
		Return Self._grow
	EndMethod
	
	Method RecalculateChildren() Abstract
	Method _recalculateChildrenIfNeeded()
		If Self._dirty Then
			Self._dirty = False
			Self._grow = New SVec2I( Self._fixedSize.x < 0, Self._fixedSize.y < 0 )
			Self.RecalculateChildren()
			For Local g:TLayoutGadget = EachIn Self
				g._dirty = True
			Next
		EndIf
	EndMethod
	
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

Type TLayoutContainer Extends TLayoutGadget
	
	Method RecalculateChildren()
		Local occupiedWidth:Int = 0
		Local occupiedHeight:Int = 0
		Local growWidthCount:Int = 0
		Local growHeightCount:Int = 0
		
		Local posX:Int = 0
		Local posY:Int = 0
		
		Local growSpaceWidth:Int = 0
		Local growSpaceHeight:Int = 0
		
		' Calculate how much space is occupied
		' and how much room there is to grow
		For Local g:TLayoutGadget = EachIn Self
			
			Select Self._layoutStyle
				Case ELayoutStyle.StackHorizontal, ELayoutStyle.WrapHorizontal
					If g.Grow.x Then
						growWidthCount:+1
					Else
						occupiedWidth:+g.GadgetSize.x
					EndIf
					growSpaceHeight = Self.GadgetSize.y
					
				Case ELayoutStyle.StackVertical, ELayoutStyle.WrapVertical
					If g.Grow.y Then
						growHeightCount:+1
					Else
						occupiedHeight:+g.GadgetSize.y
					EndIf
					growSpaceWidth = Self.GadgetSize.x
			Endselect
		Next
		
		' Adjust size and position of all children according to layout
		For Local g:TLayoutGadget = EachIn Self
			
			If growWidthCount Then ..
				growSpaceWidth = (Self.GadgetSize.x - occupiedWidth) / growWidthCount
			If growHeightCount Then ..
				growSpaceHeight = (Self.GadgetSize.y - occupiedHeight) / growHeightCount
			
			g._growSize = New SVec2I( growSpaceWidth, growSpaceHeight )
			
			Select Self._layoutStyle
				Case ELayoutStyle.StackHorizontal, ELayoutStyle.WrapHorizontal
					g._position = New SVec2I( posX, posY )
					posX:+g.GadgetSize.x
					
				Case ELayoutStyle.StackVertical, ELayoutStyle.WrapVertical
					g._position = New SVec2I( posX, posY )
					posY:+g.GadgetSize.y
			Endselect
		Next
	EndMethod
EndType

Type TLayoutButton Extends TLayoutGadget
	
	Method RecalculateChildren()
		' Buttons can't have children! Ur silly
	EndMethod
EndType