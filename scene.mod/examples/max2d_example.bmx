SuperStrict

Framework brl.glmax2d
Import brl.standardio
Import magna.scene

' Our scene manager
Global SceneManager:TSceneManager = New TSceneManager


' Example Scenes
SceneManager.Register( "My test scene", New TMyScene )
Type TMyScene Extends TSceneBase
	
	Field SomeVariable:Double
	
	Method OnTime:Double()
		Return MilliSecs()
	EndMethod
	
	Method OnUpdate( delta:Double )
		Self.SomeVariable:+delta * 0.001
	EndMethod
	
	Method OnRender( delta:Double )
		SetColor( 238, 68, 68 )
		DrawOval( 320 + Sin( Self.SomeVariable ) * 200, 240 + Cos( Self.SomeVariable * 0.75 ) * 100, 32 , 32 )
	EndMethod
EndType

SceneManager.Register( "Another Scene", New TAnotherScene )
Type TAnotherScene Extends TSceneBase
	
	Field SomeVariable:Double
	
	Method OnTime:Double()
		Return MilliSecs()
	EndMethod
	
	Method OnUpdate( delta:Double )
		Self.SomeVariable:+delta * 0.001
	EndMethod
	
	Method OnRender( delta:Double )
		SetColor( 96, 221, 96 )
		DrawOval( 320 + Cos( Self.SomeVariable ) * 200, 240 + Sin( Self.SomeVariable * 0.75 ) * 100, 32 , 32 )
	EndMethod
EndType

' Usage
Graphics( 640, 480, 0, 30 )

SceneManager.Activate( "My test scene" )
SceneManager.Activate( "aNoThEr ScEnE" )

While Not KeyDown( KEY_ESCAPE ) And Not AppTerminate()
	SceneManager.Update()
	
	Cls()
	SceneManager.Render()
	Flip( 1 )
Wend