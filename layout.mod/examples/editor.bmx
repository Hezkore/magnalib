SuperStrict

Framework magna.layout
Import brl.eventqueue
Import maxgui.drivers
Import maxgui.proxygadgets
Import brl.standardio
Import brl.max2d
Import brl.glmax2d
Import brl.timerdefault
Import brl.timer

?win32
	Import maxgui.win32maxguiex
	Import maxgui.maxguitextareascintilla
?linux
	Import maxgui.gtk3maxgui
	'Import maxgui.gtk3webkitgtk
	Import maxgui.gtk3webkit2gtk
	Import maxgui.maxguitextareascintilla
?

Import "drawgenericgadget.bmx"

Global window:TGadget = CreateWindow( "MagnaLib Layout Editor", 0, 0, 640, 720, Desktop(), ..
	WINDOW_CENTER | WINDOW_CLIENTCOORDS | WINDOW_TITLEBAR | WINDOW_RESIZABLE | WINDOW_STATUS )

Global splitter:TSplitter = CreateSplitter( 0, 0, ClientWidth(window), ClientHeight(window), window )
SetGadgetLayout( splitter,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
SetSplitterOrientation( splitter, SPLIT_HORIZONTAL )
SetSplitterPosition( splitter, ClientHeight(window) / 2 )

Global splitterText:TGadget =  SplitterPanel(splitter,SPLITPANEL_MAIN)
Global splitterPreview:TGadget =  SplitterPanel(splitter,SPLITPANEL_SIDEPANE)

Global textarea:TGadget = CreateTextArea( 0, 0, ClientWidth(splitterText), ClientHeight(splitterText), splitterText )
SetGadgetLayout( textarea, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED )
SetGadgetText( textarea, """
#window (layout=stackVertical, padding=4) {
	#toolbar (layout=wrapHorizontal) {
		button#open (text="open")
		button#save (text="save")
		button#saveAs (text="save as")
		(grow=1)
		button#search (text="search field", width=200)
	}
	#content (layout=stackHorizontal, grow=1) {
		button#(width=200) {
			//sidebar content here
		}
		button#area (text="area", grow=1)
	}
	#actions (layout=stackHorizontal) {
		button#cancel (text="Cancel")
		(grow=1)
		button#okay (text="Okay")
	}
}
""")

Global canvas:TGadget=CreateCanvas(0,0,ClientWidth( splitterPreview ),ClientHeight( splitterPreview ),splitterPreview)
SetGadgetLayout( canvas, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED )

Global myLayout:TLayoutGadget[]' = GadgetFromString( GadgetText( textarea ) )

ActivateGadget( textarea )

Global updateTimer:TTimer = CreateTimer( 10 )
Global updateCountdown:Int

Global genTime:Int
Global drawTime:Int

While WaitEvent()
	Select EventID()
		Case EVENT_TIMERTICK
			updateCountdown:-1
			If updateCountdown = 0 Then
				genTime = MilliSecs()
				SetStatusText( window, "Generating layout from script..." )
				myLayout = GadgetFromString( GadgetText( textarea ) )
				'For Local g:TLayoutGadget = EachIn myLayout
				'	g.SetPadding( New SVec4I( 4, 4, 4, 4 ) )
				'Next
				genTime = MilliSecs() - genTime
				UpdateStatus()
				RedrawGadget( splitterPreview )
			EndIf
			
		Case EVENT_GADGETPAINT
			SetGraphics( CanvasGraphics(canvas) )
			SetViewport( 0, 0, ClientWidth( canvas ), ClientHeight( canvas ) )
			Cls()
			
			drawTime = MilliSecs()
			
			' Draw the base containers and its children
			Local posX:Int
			For Local g:TLayoutGadget = EachIn myLayout
				g.SetPosition( posX, 0 )
				g.SetSize( ClientWidth( canvas ) / myLayout.Length, ClientHeight( canvas ) )
				DrawGenericGadget( g )
				posX:+g.GetOuterSize().x
			Next
			
			drawTime = MilliSecs() - drawTime
			
			UpdateStatus()
			Flip(0)

		Case EVENT_MOUSEMOVE
			'Print "MOVE!"

		Case EVENT_GADGETACTION
			Select EventSource()
				Case textarea updateCountdown = 6
			EndSelect
			
		Case EVENT_WINDOWCLOSE
			FreeGadget( canvas )
			End

		Case EVENT_APPTERMINATE
			End
	EndSelect
Wend
End

Function UpdateStatus()
	SetStatusText( window, "Layout generated in " + genTime + "ms~t~tDrawn in " + drawTime + "ms " )
EndFunction