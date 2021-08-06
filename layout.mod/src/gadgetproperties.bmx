Import brl.reflection

Import "tlayoutgadget.header.bmx"

Function SetGadgetProperties( gadget:TLayoutGadget_Header, prop:Object[], overrideGadgetType:String = "" )
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
		If Not fld Or Not fld.HasMetaData( TLayoutGadget_Header.META_PROPERTY ) Then Continue
		If value = fld.Get( gadget ) Then Continue
		
		gadget.SetNeedsRefresh()
		fld.Set( gadget, value )
	Next
EndFunction

Function GetGadgetProperties:String[]( gadget:Object )
	If Not gadget Return []
	
	Local result:TList = New TList
	Local id:TTypeId = TTypeId.ForObject( gadget )
	
	For Local fld:TField = EachIn id.EnumFields()
		If Not fld.HasMetaData( TLayoutGadget_Header.META_PROPERTY ) Then Continue
		result.AddLast( fld.Name() )
	Next
	
	' NOTICE: String[]( result.ToArray() ) does not work
	' Which is why we need to create our own array
	Local strArr:String[] = New String[result.Count()]
	For Local i:Int = 0 Until strArr.Length
		strArr[i] = String( result.First() )
		result.RemoveFirst()
	Next
	
	Return strArr
EndFunction