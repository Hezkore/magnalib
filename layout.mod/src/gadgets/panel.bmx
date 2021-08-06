Import brl.standardio

Import "../tlayoutgadget.bmx"

Type TLayoutPanel Extends TLayoutGadget
	Method IterceptPropertyChange:Int( key:String, value:Object )
		Print "INTERCEPT"
		Super.IterceptPropertyChange( key, value )
	EndMethod
EndType