SuperStrict

' Dependencies
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
	
	StackVertical
	StackHorizontal
	WrapVertical
	WrapHorizontal
EndEnum

Type TLayout Extends TLayoutContainer
EndType

Type TLayoutGadget
	
	Field Children:TList = New TList
	Field Parent:TLayoutGadget
	
	Field Id:String
	
	Private
		Field _position:SVec2I
		Field _fixedSize:SVec2I
		Field _layoutStyle:ELayoutStyle = ELayoutStyle.StackVertical
		Field _text:String
		
		Field _enumIndex:UInt
	Public
	
	Method New( id:String, width:Int = -1, height:Int = -1, text:String = "" )
		Self.Id = id
		Self._fixedSize = New SVec2I( width, height )
		Self.Text = text
	EndMethod
	
	Method New( id:String, text:String = "" )
		Self.Id = id
		Self._fixedSize = New SVec2I( -1, -1 )
		Self.Text = text
	EndMethod
	
	Method New( width:Int = -1, height:Int = -1 )
		Self.Id = ""
		Self._fixedSize = New SVec2I( width, height )
		Self.Text = ""
	EndMethod
	
	Method AddGadget( gadget:TLayoutGadget )
		gadget.Parent = Self
		ListAddLast( Self.Children, gadget )
	EndMethod
	
	Method GadgetSize:SVec2I()
		Return Self.FixedSize
	EndMethod
	
	Method ObjectEnumerator:TLayoutGadget()
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
EndType

Type TLayoutButton Extends TLayoutGadget
EndType