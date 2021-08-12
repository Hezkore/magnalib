Import brl.standardio

Import "../tlayoutgadget.bmx"

Type TLayoutPanel Extends TLayoutGadget
	
	Method New( id:String, layout:String = "stackHorizontal", grow:Int = False )
		Self.SetId( id )
		Self.SetLayoutStyle( layout )
		Self.SetGrow( grow )
	EndMethod
	
	Method New( width:Int, height:Int, layout:String = "stackHorizontal", grow:Int = False )
		Self.SetSize( width, height )
		Self.SetLayoutStyle( layout )
		Self.SetGrow( grow )
	EndMethod
	
	Method New( id:String, width:Int, height:Int, layout:String = "stackHorizontal", grow:Int = False )
		Self.SetId( id )
		Self.SetSize( width, height )
		Self.SetLayoutStyle( layout )
		Self.SetGrow( grow )
	EndMethod
	
	Method IterceptPropertyChange:Int( key:String, value:Object )
		Super.IterceptPropertyChange( key, value )
	EndMethod
EndType