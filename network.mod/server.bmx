SuperStrict

Import brl.objectlist
Import brl.socketstream

Import "packet.bmx"
Import "connection.bmx"

Type TNetworkServer
	Field _clientsMax:Short
	Field _clientCount:Short
	
	Field _noDelay:Byte = True
	Field _port:Int
	Field _socket:TSocket
	Field _packetFuncPointer:TNetworkPacket(packet:TNetworkPacket)
	Field _connections:TNetworkConnection[]	'All our "players" are stored here
	Field _hints:TAddrInfo
	
	Method New(func:TNetworkPacket(packet:TNetworkPacket))
		
		Self.SetPacketFunctionPointer(func)
	EndMethod
	
	Method Running:Byte()
		If Not Self._socket Then Return False
		' FIX: _socket.Connected() sometimes "randomly" returns False
		' Even if the socket is actually connected
		' Ask Brucey about this?
		Return True'Self._socket.Connected()
	EndMethod
	
	Method SetPacketFunctionPointer(func:TNetworkPacket(packet:TNetworkPacket))
		
		Self._packetFuncPointer = func
	EndMethod
	
	Method Start:Byte(port:Int, clientsMax:Short = 16)
		
		' Sanity checks
		If clientsMax <= 0 Then
			Assert("Max client count is too low!")
			Return False
		EndIf
		Self._clientsMax = clientsMax
		Self._port = port
		
		' Resize the connections array so that it fits all clients
		Self._connections = New TNetworkConnection[Self._clientsMax]
		
		' Prepare the socket
		Self._socket = CreateTCPSocket()
		If Not Self._socket Then
			Assert("Unable to create socket")
		    Return False
		EndIf
		
		If Not BindSocket(Self._socket, Self._port) Or Not SocketListen(Self._socket) Then
			CloseSocket(Self._socket)
			Assert("Unable to create server at port #" + Self._port)
			Return False
		EndIf
		
		Self._socket.SetTCPNoDelay(Self._noDelay)
		
		Print("New server at port #" + Self._port)
		
		Return True
	EndMethod
	
	Method Close()
		
		CloseSocket(Self._socket)
	EndMethod
	
	Method _checkDisconnects()
		For Local c:TNetworkConnection = EachIn Self._connections
			If Not c.Connected() Then
				
				If c._identified Then
					' This was an identified connection
					' Report its departure via a packet
					Local leavePacket:TNetworkPacket = New TNetworkPacket(TNetworkDefaultPackets.Left)
					leavePacket.SetFromClient(c._sessionID)
					Self._packetFuncPointer(leavePacket)
				EndIf
				
				Self._connections[c._sessionID] = Null
				Self._clientCount:-1
			EndIf
		Next
	EndMethod
	
	Method _checkNewConnections:TNetworkConnection()
		
		' Accept the new socket if there is one
		Local accepted_socket:TSocket = SocketAccept(Self._socket)
		If Not accepted_socket Return Null ' Return null if there was no new connection
		
		' Check if we're inside the max client limit
		If Self._clientCount < Self._clientsMax Then
			' We're good, continue
			Self._clientCount:+1
			
			Local client:TNetworkConnection = New TNetworkConnection
			client._socket = accepted_socket
			client._stream = CreateSocketStream(client._socket)
			client._includeFromUser = True ' When sending data we can include from user data
			client.SetPacketFunctionPointer(Self._packetFuncPointer)
			client._sessionID = Self._findFreeSessionID()
			Self._connections[client._sessionID] = client
			
			' Send the client his ID
			client.WriteShort(client._sessionID)
			
			Return client
		Else
			' No free client slots, close connection
			accepted_socket.Close()
			
			Print("Client overflow (" + Self._clientCount + "/" + Self._clientsMax + ")")
			Return Null
		EndIf
	EndMethod
	
	Method _receiveAndSendData()
		
		For Local c:TNetworkConnection = EachIn Self._connections
			c.Update()
		Next
	EndMethod
	
	Method _internalPacket(packet:TNetworkPacket)
	EndMethod
	
	Method Update()
		
		' Look for disconnects
		Self._checkDisconnects()
		
		' Look for new connections
		Self._checkNewConnections()
		
		' Receive data
		Self._receiveAndSendData()
	EndMethod
	
	Method _findFreeSessionID:Int()
		
		' Find the first empty space in our connections array
		For Local i:Int = 1 Until Self._connections.Length
			If Not Self._connections[i] Then Return i
		Next
	EndMethod
	
	Method GetConnection:TNetworkConnection(sessionID:Short)
		If Self._connections[sessionID] Then ..
			Return(Self._connections[sessionID])
	EndMethod
EndType