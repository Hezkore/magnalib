SuperStrict

' Dependencies
?threaded
	Import brl.threads
?
Import brl.collections

rem
bbdoc: Game
about:
Magna state manager
endrem
Module magna.state

ModuleInfo "Author: Rob C."
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2021 Rob C."

?threaded
	Private
		Function ThreadedOnUpdate:Object( data:Object )
			
			Local owner:TManagerState = TManagerState( data )
			
			While Not owner._wantsToStop
				owner._currentUpdateTime = owner.currentState.OnTime()
				If owner.currentState And TryLockMutex( owner._updateMutex ) Then
					UnlockMutex( owner._updateMutex )
					owner.currentState.OnUpdate( (owner._currentUpdateTime - owner._lastUpdateTime) * owner.deltaMulti )
					owner._lastUpdateTime = owner._currentUpdateTime
				EndIf
			Wend
		EndFunction
	Public
?

Type TManagerState
	
	Field states:TStack<TStateBase> = New TStack<TStateBase>
	Field currentState:TStateBase
	Field deltaMulti:Double = 100.0
	Field threadedUpdate:Int = True
	
	?threaded
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
		
		?threaded
			If Self.threadedUpdate Then
				' Use crappy threading for updates
				' Halts on rendering, but doesn't halt rendering
				If Not Self._updateThread Then ..
					Self._updateThread = CreateThread( ThreadedOnUpdate, Self )
			Else If Self.currentState Then
		?
			' Do a "normal" update
			Self._currentUpdateTime = Self.currentState.OnTime()
			If Self.currentState Then
				Self.currentState.OnUpdate( (Self._currentUpdateTime - self._lastUpdateTime) * Self.deltaMulti )
			EndIf
			Self._lastUpdateTime = Self._currentUpdateTime
		?threaded
			EndIf
		?
	EndMethod
	
	Method OnRender()
		
		Self._currentRenderTime = Self.currentState.OnTime()
		If Self.currentState Then
			?threaded
				LockMutex( Self._updateMutex )
			?
			Self.currentState.OnRender( (Self._currentRenderTime - self._lastRenderTime) * Self.deltaMulti )
			?threaded
				UnlockMutex( Self._updateMutex )
			?
		EndIf
		Self._lastRenderTime = Self._currentRenderTime
	EndMethod
	
	Method Register( name:String, state:TStateBase )
		
		state.Name = name
		
		Self.States.Push( state )
		
		If Not Self.CurrentState Self.CurrentState = state
	EndMethod
	
	Method Close()
		Self._wantsToStop = True
		?threaded
			If Self._updateThread Then
				If Self._updateThread.Running() Then WaitThread( Self._updateThread )
				Self._updateThread = null
			EndIf
		?
	EndMethod
EndType

Type TStateBase Abstract
	
	Field Name:String = "Unknown"
	
	Method OnTime:Double()				Abstract
	Method OnUpdate( delta:Double )	Abstract
	Method OnRender( delta:Double )	Abstract
EndType