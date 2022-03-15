SuperStrict

' Dependencies
Import text.jconv
Import brl.filesystem

rem
bbdoc: Configuration
about:
Load Magna configuration files using reflection and JConv
endrem
Module magna.config

ModuleInfo "Author: Rob C."
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2021 Rob C."

rem
bbdoc: Load a JSON Magna configuration file
about: Configuration file does not have to exist
endrem
Function LoadMagnaConfig:Object( configType:String, file:String, path:String = "config\" )
	Return TMagnaConfig.Load( configType, file, path )
EndFunction

rem
bbdoc: Abstract Magna configuration type
about: Use by extending your own type
endrem
Type TMagnaConfig Abstract
	
	Field configType:String					{ transient }
	Field configPath:String					{ transient }
	Field configFile:String					{ transient }
	
	rem
	bbdoc: Load a JSON Magna configuration file
	about: Configuration file does not have to exist
	endrem
	Function Load:Object( configType:String, file:String, path:String = "config\" )
		
		Local fullPath:String = AppDir + "\" + path + file + ".json"
		Local json:String = "{}"
		Local jconv:TJConv = New TJConvBuilder.WithBoxing().Build()
		
		If FileType( fullPath ) Then json = LoadString( fullPath )
		
		Local configObject:Object = jconv.FromJson( json, configType )
		TMagnaConfig( configObject ).configType = configType
		TMagnaConfig( configObject ).configFile = file
		TMagnaConfig( configObject ).configPath = path
		
		Return configObject
	EndFunction
	
	rem
	bbdoc: Save the JSON Magna configuration file
	about: Directory does not have to exist
	endrem
	Method Save( allowEmptyFile:Int = False )
		
		If Not Self.configFile Return
		
		Local fullPath:String = AppDir + "\" + Self.configPath
		Local jconv:TJConv = New TJConvBuilder.WithBoxing().WithIndent( 4 ).Build()
		Local json:String = jconv.ToJson( Self )
		If Not allowEmptyFile And json.Length <= 2 Return
		
		If FileType( fullPath ) <> FILETYPE_DIR Then
			If Not CreateDir( fullPath, True ) Then
				Throw( "Unable to create ~q" + fullPath + "~q" )
				Return
			EndIf
		EndIf
		
		SaveString( json, fullPath + Self.configFile + ".json" )
	EndMethod
EndType