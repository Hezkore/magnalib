Import brl.standardio

Import "../tlayoutgadget.bmx"

Type TLayoutPanel Extends TLayoutGadget
	
	Method New()
	EndMethod
	
	Method IterceptPropertyChange:Int( key:String, value:Object )
		Super.IterceptPropertyChange( key, value )
	EndMethod
EndType