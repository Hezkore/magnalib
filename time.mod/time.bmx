SuperStrict

' Dependencies
Import "src/native.c"

rem
bbdoc: System
about:
Magna time handler
endrem
Module magna.time

ModuleInfo "Author: Rob C."
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2022 Rob C."

' Import functions from native.c
Extern "C"
	rem
	bbdoc: Get current microseconds
	endrem
	Function MicroSecs:Int()
	rem
	bbdoc: Get current date
	endrem
	Function Date:Int()
	rem
	bbdoc: Get seconds between two date
	endrem
	Function SecondsSince:Int( date1:Int, date2:Int )
EndExtern