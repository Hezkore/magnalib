Load Magna configuration files using reflection and JConv.

Example:
```blitzmax
Framework magna.config
Import brl.standardio

' Define your type
Type TMyType
	
	' Load options using a Magna configuration file
	Field options:TMyOptions = TMyOptions( LoadMagnaConfig( "TMyOptions", "myConfigFile" ) )
EndType

' Define available options by extending TMagnaConfig
Type TMyOptions Extends TMagnaConfig
	
	Field myOption:Int = 15 ' Default value 15
	Field hiddenOption:TBool = New TBool( True )	{ transient }
	' Read more at https://blitzmax.org/docs/en/api/text/text.jconv/#ignoring-fields
EndType

Local test:TMyType = New TMyType

Print( test.options.myOption )

' Update or create the external configuration file
test.options.Save()
```