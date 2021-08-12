Import brl.standardio

Import "../tlayoutgadget.bmx"

Type TLayoutContainer Extends TLayoutGadget
	
	Method Defaults()
		Self.SetMargin( New SVec4I( 0, 0, 0, 0 ) )
		Self.SetPadding( New SVec4I( 0, 0, 0, 0 ) )
	EndMethod
	
	Method New( id:String, layout:String = "stackHorizontal", grow:Int = False )
		Self.Defaults()
		Self.SetId( id )
		Self.SetLayoutStyle( layout )
		Self.SetGrow( grow )
	EndMethod
	
	Method New( width:Int, height:Int, layout:String = "stackHorizontal", grow:Int = False )
		Self.Defaults()
		Self.SetSize( width, height )
		Self.SetLayoutStyle( layout )
		Self.SetGrow( grow )
	EndMethod
	
	Method New( id:String, width:Int, height:Int, layout:String = "stackHorizontal", grow:Int = False )
		Self.Defaults()
		Self.SetId( id )
		Self.SetSize( width, height )
		Self.SetLayoutStyle( layout )
		Self.SetGrow( grow )
	EndMethod
	
	Method IterceptPropertyChange:Int( key:String, value:Object )
		Super.IterceptPropertyChange( key, value )
	EndMethod
EndType