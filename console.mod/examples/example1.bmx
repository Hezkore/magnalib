SuperStrict

Framework magna.console
Import brl.standardio

Local myConsole:TMagnaConsole = New TMagnaConsole

local x:Int = 1

While True
	Print "INPUT PLOX"
	Local userInput:String = Input$( ">" )
	
	Print( "User said: " + userInput )
Wend