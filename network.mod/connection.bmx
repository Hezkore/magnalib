SuperStrict

Import brl.standardio
Import brl.objectlist
Import brl.socketstream

Import "packet.bmx"

' Per user connection
rem
bbdoc: TNetworkConnection is a class that represents a connection to a client or server
endrem
Type TNetworkConnection
	' Internals
	Field _socket:TSocket
	Field _stream:TSocketStream
	
	Field _sessionID:Short
	Field _identified:Byte
	
	rem
	bbdoc: Extra is a field that can be used to store any data you want
	endrem
	Field Extra:Object
	
	' For receiveing packets
	Field _incomingPacketState:Byte
	Field _incomingPacket:TNetworkPacket
	
	Field _packetFuncPointer:TNetworkPacket(packet:TNetworkPacket)
	
	' For sending packets
	Field _sendQueue:TObjectList ' FIX: Make TQueue (but crashes for now)
	Field _includeFromUser:Byte = False
	Field _canReceiveMorePackets:Byte
	
	rem
	bbdoc: Creates a new network connection
	endrem
	Method New()
		Self._sendQueue = New TObjectList
	EndMethod
	
	rem
	bbdoc: Returns true if the connection is identified
	endrem
	Method Connected:Byte()
		If Not Self._stream Return False
		If Not Self._socket Return False
		Return Self._socket.Connected()
	EndMethod
	
	rem
	bbdoc: Queues a packet to be sent
	about: The packet will be sent the next time the connection is updated
	endrem
	Method QueuePacket(packet:TNetworkPacket)
		Self._sendQueue.AddLast(packet)
	EndMethod
	
	rem
	bbdoc: Set the function to be called when a packet is received
	endrem
	Method SetPacketFunctionPointer(func:TNetworkPacket(packet:TNetworkPacket))
		
		Self._packetFuncPointer = func
	EndMethod
	
	' This method is called by the server or client when a packet is received
	Method _triggerPacketFuncPointer(packet:TNetworkPacket)
		
		' Call the packet function pointer
		' Anything returned will be queued
		Local returnPacket:TNetworkPacket = ..
			Self._packetFuncPointer(packet)
		
		' Did we get a return packet?
		If returnPacket Then Self.QueuePacket(returnPacket)
	EndMethod
	
	rem
	bbdoc: Receives data from the connection
	endrem
	Method Update()
		
		' Receive data
		Self._receiveAndSendData()
	EndMethod
	
	' This method is called by the server or client to check for packets
	Method _receiveAndSendData()
		
		' Send packets in the queue
		If Self._sendQueue.Count() > 0 Then
			Local packet:TNetworkPacket
			Local bank:TBank
			' FIX: Send as one huge bank, not one bank per packet (?)
			For packet = EachIn Self._sendQueue
				'Self._stream.WriteBytes(packet.ToBank(Self._includeFromUser), packet.SizeWithHeader())
				bank = packet.ToBank()
				For Local i:Int = 0 Until bank.Size()
					Self._stream.WriteByte(bank.PeekByte(i))
				Next
			Next
			Self._sendQueue.Clear()
		EndIf
		
		' Receive packets
		
		' Only handle a certain amount of packets
		Self._canReceiveMorePackets = 5 ' TODO: Make not hardcoded
		
		' WHILE there's stuff to read
		' Remember to exit the loop whenever possible!
		While Self.ReadAvail() > 0
			
			' Is this connection identified?
			If Not Self._identified Then ' Nope
				
				' This part is only used by the server
				If Self.ReadAvail() >= 2 Then
					
					' Connection needs to identify by sending correct session ID
					If Self.ReadShort() = Self._sessionID Then
						
						Self._identified = 1
						
						' Announce via packet
						Local joinPacket:TNetworkPacket = New TNetworkPacket(TNetworkDefaultPackets.Join)
						joinPacket.SetFromClient(Self._sessionID)
						Self._triggerPacketFuncPointer(joinPacket)
					Else
						Print("Connection #" + Self._sessionID + " failed to ident!")
						Self.Close()
					EndIf
				EndIf
				
				Exit
			EndIf
			
			If Self._identified Then ' Yep
				' Used by both the server and client
				Select Self._incomingPacketState
					
					' First stage is getting the ID for the packet
					Case 0
						If Self.ReadAvail() >= 1 Then
							Self._incomingPacket = New TNetworkPacket(Self.ReadByte())
							Self._incomingPacketState:+1
						Else
							Exit
						EndIf
					
					' Second stage is getting destination
					Case 1
						If Self.ReadAvail() >= 2 Then
							Self._incomingPacket.SetToClient(Self.ReadShort())
							Self._incomingPacket.SetFromClient(Self._sessionID)
							Self._incomingPacketState:+1
						Else
							Exit
						EndIf
					
					' Third stage is getting the length and preparing our bank
					Case 2
						If Self.ReadAvail() >= 2 Then
							Self._incomingPacket.SetSize(Self.ReadShort())
							Self._incomingPacketState:+1
						Else
							Exit
						EndIf
					
					' Fourth is the actual packet
					Case 3
						' FIX: Instead of adding one byte we could add a bunch
						If Not Self._incomingPacket.EOF() Then
							Self._incomingPacket.WriteByte(Self.ReadByte())
							If Not Self._incomingPacket.EOF() Exit
						EndIf
						
						' Packet is complete!
						If Self._incomingPacket.EOF() Then
							Self._canReceiveMorePackets:-1
							Self._incomingPacketState = 0
							Self._incomingPacket.Seek(0)
							
							' Is this an internal packet?
							If Self._incomingPacket.ID() <= 250 Then
								'Print "Got packet with ID " + Self._incomingPacket.ID() + " with a size of " + Self._incomingPacket.Size()
								Self._triggerPacketFuncPointer(Self._incomingPacket)
							Else
								'Self._internalPacket(Self._incomingPacket)
							EndIf
							
							Self._incomingPacket = Null
						EndIf
				EndSelect
			EndIf
			
			If Self._canReceiveMorePackets < 0 Then Exit
		Wend
	EndMethod
	
	rem
	bbdoc: Close the connection
	endrem
	Method Close()
		CloseSocket(Self._socket)
	EndMethod
	
	Method ReadByte:Byte()
		Return Self._stream.ReadByte()
	EndMethod
	
	Method ReadShort:Short()
		Return Self._stream.ReadShort()
	EndMethod
	
	Method ReadInt:Int()
		Return Self._stream.ReadInt()
	EndMethod
	
	Method ReadLong:Long()
		Return Self._stream.ReadLong()
	EndMethod
	
	Method ReadFloat:Float()
		Return Self._stream.ReadFloat()
	EndMethod
	
	Method ReadDouble:Double()
		Return Self._stream.ReadDouble()
	EndMethod
	
	Method WriteByte(value:Byte)
		Self._stream.WriteByte(value)
	EndMethod
	
	Method WriteShort(value:Short)
		Self._stream.WriteShort(value)
	EndMethod
	
	Method WriteInt(value:Int)
		Self._stream.WriteInt(value)
	EndMethod
	
	Method WriteLong(value:Long)
		Self._stream.WriteLong(value)
	EndMethod
	
	Method WriteDouble(value:Double)
		Self._stream.WriteDouble(value)
	EndMethod
	
	rem
	bbdoc: Returns the amount of bytes available to read
	endrem
	Method ReadAvail:Int()
		Return SocketReadAvail(Self._socket)
	EndMethod
EndType