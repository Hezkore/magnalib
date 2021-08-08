SuperStrict

' Dependencies
?Threaded
	Import brl.threads
?
Import brl.collections

rem
bbdoc: Game
about:
Magna scene manager
endrem
Module magnalib.scene

ModuleInfo "Author: Rob C."
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2021 Rob C."

?Threaded
	Private
		Function ThreadedOnUpdate:Object( data:Object )
			
			Local owner:TSceneManager = TSceneManager( data )
			
			While Not owner._wantsToStop
				owner._currentUpdateTime = owner.currentScene.OnTime()
				If owner.currentScene And TryLockMutex( owner._updateMutex ) Then
					UnlockMutex( owner._updateMutex )
					owner.currentScene.OnUpdate( (owner._currentUpdateTime - owner._lastUpdateTime) * owner.deltaMulti )
					owner._lastUpdateTime = owner._currentUpdateTime
				EndIf
			Wend
		EndFunction
	Public
?

Type TSceneManager
	
	Field scenes:TStack<TSceneBase> = New TStack<TSceneBase>
	Field currentScene:TSceneBase
	Field deltaMulti:Double = 100.0
	Field threadedUpdate:Int = True
	
	?Threaded
		Field _updateThread:TThread
		Field _updateMutex:TMutex
	?
	Field _wantsToStop:Int
	Field _lastUpdateTime:Double
	Field _currentUpdateTime:Double
	Field _lastRenderTime:Double
	Field _currentRenderTime:Double
	
	Method New()
		
		Self._updateMutex = CreateMutex()
	EndMethod
	
	Method OnUpdate()
		
		?Threaded
			If Self.threadedUpdate Then
				' Use crappy threading for updates
				' Halts on rendering, but doesn't halt rendering
				If Not Self._updateThread Then ..
					Self._updateThread = CreateThread( ThreadedOnUpdate, Self )
			Else If Self.currentScene Then
		?
			' Do a "normal" update
			Self._currentUpdateTime = Self.currentScene.OnTime()
			If Self.currentScene Then
				Self.currentScene.OnUpdate( (Self._currentUpdateTime - self._lastUpdateTime) * Self.deltaMulti )
			EndIf
			Self._lastUpdateTime = Self._currentUpdateTime
		?Threaded
			EndIf
		?
	EndMethod
	
	Method OnRender()
		
		Self._currentRenderTime = Self.currentScene.OnTime()
		If Self.currentScene Then
			?Threaded
				LockMutex( Self._updateMutex )
			?
			Self.currentScene.OnRender( (Self._currentRenderTime - self._lastRenderTime) * Self.deltaMulti )
			?Threaded
				UnlockMutex( Self._updateMutex )
			?
		EndIf
		Self._lastRenderTime = Self._currentRenderTime
	EndMethod
	
	Method Register( name:String, Scene:TSceneBase )
		
		Scene.Name = name
		
		Self.Scenes.Push( Scene )
		
		If Not Self.CurrentScene Self.CurrentScene = Scene
	EndMethod
	
	Method Close()
		Self._wantsToStop = True
		?Threaded
			If Self._updateThread Then
				If Self._updateThread.Running() Then WaitThread( Self._updateThread )
				Self._updateThread = null
			EndIf
		?
	EndMethod
EndType

Type TSceneBase Abstract
	
	Field Name:String = "Unknown"
	Field ZOrder:Int = 0
	
	Method OnTime:Double()				Abstract
	Method OnUpdate( delta:Double )	Abstract
	Method OnRender( delta:Double )	Abstract
EndType