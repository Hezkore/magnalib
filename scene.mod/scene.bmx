SuperStrict

' Dependencies
?Threaded
	Import brl.threads
?
Import brl.objectlist

rem
bbdoc: Game
about:
Magna scene manager
endrem
Module magna.scene

ModuleInfo "Author: Rob C."
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2021 Rob C."

Type TSceneManager
	
	Field Scenes:TObjectList = New TObjectList
	Field ActiveScenes:TObjectList = New TObjectList
	Field _wantsToStop:Int
	
	Method New()
	EndMethod
	
	Method Update()
		For Local s:TSceneBase = EachIn Self.ActiveScenes
			s._currentUpdateTime = s.OnTime()
			s.OnUpdate( (s._currentUpdateTime - s._lastUpdateTime) * s.DeltaMulti )
			s._lastUpdateTime = s._currentUpdateTime
		Next
	EndMethod
	
	Method Render()
		For Local s:TSceneBase = EachIn Self.ActiveScenes
			s._currentRenderTime = s.OnTime()
			s.OnRender( (s._currentRenderTime - s._lastRenderTime) * s.deltaMulti )
			s._lastRenderTime = s._currentRenderTime
		Next
	EndMethod
	
	Method Register( name:String, scene:TSceneBase, active:Int = False )
		scene._name = name
		scene._searchName = name.ToLower()
		Self.Scenes.AddLast( Scene )
		If active Then Self.Activate( scene )
	EndMethod
	
	Method Activate( name:String )
		Local scene:TSceneBase = Self.GetFromName( name )
		If Not Self.ActiveScenes.Contains( scene ) Then
			Self.ActiveScenes.AddLast( scene )
		EndIf
	EndMethod
	
	Method Activate( scene:TSceneBase )
		If Not Self.ActiveScenes.Contains( scene ) Then
			Self.ActiveScenes.AddLast( scene )
		EndIf
	EndMethod
	
	Method Deactivate( name:String )
		Local scene:TSceneBase = Self.GetFromName( name )
		Self.ActiveScenes.Remove( scene )
	EndMethod
	
	Method Deactivate( scene:TSceneBase )
		Self.ActiveScenes.Remove( scene )
	EndMethod
	
	Method GetFromName:TSceneBase( name:String )
		name = name.ToLower()
		For Local s:TSceneBase = EachIn Self.Scenes
			If s._searchName = name Then
				Return s
			EndIf
		Next
		
		Return Null
	EndMethod
	
	Method Close()
		Self._wantsToStop = True
	EndMethod
EndType

Type TSceneBase Abstract
	
	Field DeltaMulti:Double = 100.0
	
	Field _name:String = "Unknown"
	Field _searchName:String = "unknown"
	
	Field _lastUpdateTime:Double
	Field _currentUpdateTime:Double
	Field _lastRenderTime:Double
	Field _currentRenderTime:Double
	
	Method OnTime:Double()			Abstract
	Method OnUpdate( delta:Double )	Abstract
	Method OnRender( delta:Double )	Abstract
EndType