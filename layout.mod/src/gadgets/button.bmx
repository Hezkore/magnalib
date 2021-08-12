Import "../tlayoutgadget.bmx"

Type TLayoutButton Extends TLayoutGadget
	
	Method New( id:String, text:String, width:Int = 64, height:Int = 24, grow:Int = False )
		Self.SetId( id )
		Self.SetText( text )
		Self.SetGrow( grow )
		Self.SetMinSize( width, height )
	EndMethod
	
	Method New()
		Self.SetMinSize( 64, 24 )
	EndMethod
EndType