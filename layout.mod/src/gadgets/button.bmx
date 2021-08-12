Import "../tlayoutgadget.bmx"

Type TLayoutButton Extends TLayoutGadget
	
	Method Defaults()
		Self.SetMinSize( 64, 24 )
	EndMethod
	
	Method New( id:String, text:String, width:Int = 64, height:Int = 24, grow:Int = False )
		Self.Defaults()
		Self.SetId( id )
		Self.SetText( text )
		Self.SetGrow( grow )
		Self.SetMinSize( width, height )
	EndMethod
EndType