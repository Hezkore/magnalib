SuperStrict

Framework brl.standardio
Import magna.network

' Packet definer
Import "mypackets.bmx"

Local server:TNetworkServer = New TNetworkServer(OnNetPacket)

' Start the server
' Use port 2472
' Max 8 user connections
If server.Start(2472, 8) Then
	
	While server.Running()
		server.Update()
		Delay(1)
	Wend
Else
	
	Print("Error starting the server")
EndIf
End

' Our packet handler
' Any client message will pass through here
Function OnNetPacket:TNetworkPacket(packet:TNetworkPacket)
	Print "Got Packet with ID " + packet.ID()
	
	Select packet.ID()
		Case TNetworkDefaultPackets.Join
			Print("#" + packet.FromClient() + " joined")
		
		Case TNetworkDefaultPackets.Left
			Print("#" + packet.fromClient + " left")
		
		Case TMyPackets.Hello
			Print("Msg from client " + packet.FromClient() + ": " + Packet.ReadString())
	EndSelect
EndFunction