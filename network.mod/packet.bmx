SuperStrict

Import brl.bank
Import brl.stringbuilder
Import brl.math

Import brl.standardio

' Default internal packets
rem
bbdoc: These are the default packets that are used internally by the network module
endrem
Type TNetworkDefaultPackets
	Global Ping:Byte = 255
	Global Left:Byte = 254
	Global Join:Byte = 253
	Global Bank:Byte = 252
EndType

' Packet type
rem
bbdoc: A packet is a data structure that is sent over the network
endrem
Type TNetworkPacket
	' The size of the buffer that is used when writing to the packet
	Global WriteBufferSize:Int = 32
	
	' Internal fields
	Field _id:Byte
	Field _data:TBank
	Field _fromClient:Short
	Field _toClient:Short
	
	Field _offset:Short
	Field _realSize:Short
	
	rem
	bbdoc: Creates a new packet with the specified ID
	endrem
	Method New(id:Byte)
		Self._id = id
		Self._data = CreateBank(Self.WriteBufferSize)
	EndMethod
	
	rem
	bbdoc: Returns the ID of the packet
	endrem
	Method ID:Byte()
		Return Self._id
	EndMethod
	
	rem
	bbdoc: Returns the client ID that the packet was sent from
	endrem
	Method FromClient:Short()
		Return Self._fromClient
	EndMethod
	
	rem
	bbdoc: Sets the client ID that the packet was sent from
	endrem
	Method SetFromClient(id:Short)
		Self._fromClient = id
	EndMethod
	
	rem
	bbdoc: Returns the client ID that the packet was sent to
	endrem
	Method ToClient:Short()
		Return Self._toClient
	EndMethod
	
	rem
	bbdoc: Sets the client ID that the packet was sent to
	endrem
	Method SetToClient(id:Short)
		Self._toClient = id
	EndMethod
	
	rem
	bbdoc: Returns the size of the packet
	endrem
	Method Size:Short()
		Return Self._realSize
	EndMethod
	
	Method SizeWithBuffer:Short()
		Return Int(Self._data.Size())
	EndMethod
	
	Method SizeWithHeader:Short()
		Return Int(Self._data.Size() + 1 + 2 + 2)
	EndMethod
	
	Method SetSize(size:Short)
		Self._realSize = size
	EndMethod
	
	Method Offset:Short()
		Return Self._offset
	EndMethod
	
	Method EOF:Byte()
		Return Self._offset >= Self._realSize
	EndMethod
	
	' Converts the packet to a bank
	' Which is later sent over the network
	Method ToBank:TBank()
		
		Local tmpBank:TBank = CreateBank(Self.Size() + 1 + 2 + 2)
		Local tmpOffset:Int
		
		tmpBank.PokeByte(tmpOffset, Self.ID()) ; tmpOffset:+1
		tmpBank.PokeShort(tmpOffset, Self.ToClient()) ; tmpOffset:+2
		tmpBank.PokeShort(tmpOffset, Self.Size()) ; tmpOffset:+2
		
		' Poke bytes into our bank from the packet
		' FIX: Add multiple bytes instead of one by one
		For Local i:Int = 0 Until Self.Size()
			tmpBank.PokeByte(tmpOffset, Self._data.PeekByte(i)) ; tmpOffset:+1
		Next
		
		' Sanity checks
		If tmpBank.PeekByte(0) <> Self.ID() Then Assert("Error generating packet bank")
		If tmpBank.PeekByte(1) <> Self.ToClient() Then Assert("Error generating packet bank")
		
		'Print "Generated packet bank from ID " + Self.ID() + " with a size of " + Self.Size()
		
		Return tmpBank
	EndMethod
	
	Method _getRealSizeFromOffsetAndResize:Int()
		Local sizeDiff:Int = Self._offset - Self._realSize
		If sizeDiff <= 0 Then Return 0
		
		'Print "Offset is now " + sizeDiff + " larger than realsize of " + Self._realSize
		If Self._offset > Self._data.Size() Then
			Print "Buffer needs to grow to " + Int(Ceil(Double(Self._offset) / Double(Self._realSize)) * Self.WriteBufferSize)
			Self._data.Resize(Int(Ceil(Double(Self._offset) / Double(Self._realSize)) * Self.WriteBufferSize))
		EndIf
		
		Return sizeDiff
	EndMethod
	
	rem
	bbdoc: Seek to a specific offset in the packet
	endrem
	Method Seek(offset:Int)
		Self._offset = offset
	EndMethod
	
	rem
	bbdoc: Write a byte to the packet
	endrem
	Method WriteByte(value:Byte)
		Self._offset:+1
		Self._realSize:+Self._getRealSizeFromOffsetAndResize()
		Self._data.PokeByte(Self._offset - 1, value)
	EndMethod
	
	rem
	bbdoc: Write a short to the packet
	endrem
	Method WriteShort(value:Short)
		Self._offset:+2
		Self._realSize:+Self._getRealSizeFromOffsetAndResize()
		Self._data.PokeShort(Self._offset - 2, value)
	EndMethod
	
	rem
	bbdoc: Write an integer to the packet
	endrem
	Method WriteInt(value:Int)
		Self._offset:+4
		Self._realSize:+Self._getRealSizeFromOffsetAndResize()
		Self._data.PokeInt(Self._offset - 4, value)
	EndMethod
	
	rem
	bbdoc: Write a long to the packet
	endrem
	Method WriteLong(value:Long)
		Self._offset:+8
		Self._realSize:+Self._getRealSizeFromOffsetAndResize()
		Self._data.PokeLong(Self._offset - 8, value)
	EndMethod
	
	rem
	bbdoc: Write a double to the packet
	endrem
	Method WriteDouble(value:Double)
		Self._offset:+8
		Self._realSize:+Self._getRealSizeFromOffsetAndResize()
		Self._data.PokeDouble(Self._offset - 8, value)
	EndMethod
	
	rem
	bbdoc: Write a float to the packet
	endrem
	Method WriteFloat(value:Float)
		Self._offset:+4
		Self._realSize:+Self._getRealSizeFromOffsetAndResize()
		Self._data.PokeFloat(Self._offset - 4, value)
	EndMethod
	
	rem
	bbdoc: Write a string to the packet
	endrem
	Method WriteString(text:String)
		For Local i:Int = 0 Until text.Length
			If Byte(text[i]) > 0 Then ..
				Self.WriteByte(Byte(text[i]))
		Next
		Self.WriteByte(0) ' Null terminated
	EndMethod
	
	rem
	bbdoc: Reads a byte from the packet
	endrem
	Method ReadByte:Byte()
		Self._offset:+1
		Return Self._data.PeekByte(Self._offset - 1)
	EndMethod
	
	rem
	bbdoc: Reads a short from the packet
	endrem
	Method ReadShort:Short()
		Self._offset:+2
		Return Self._data.PeekShort(Self._offset - 2)
	EndMethod
	
	rem
	bbdoc: Reads an integer from the packet
	endrem
	Method ReadInt:Int()
		Self._offset:+4
		Return Self._data.PeekInt(Self._offset - 4)
	EndMethod
	
	rem
	bbdoc: Reads a long from the packet
	endrem
	Method ReadLong:Long()
		Self._offset:+8
		Return Self._data.PeekLong(Self._offset - 8)
	EndMethod
	
	rem
	bbdoc: Reads a float from the packet
	endrem
	Method ReadFloat:Float()
		Self._offset:+4
		Return Self._data.PeekFloat(Self._offset - 4)
	EndMethod
	
	rem
	bbdoc: Reads a double from the packet
	endrem
	Method ReadDouble:Double()
		Self._offset:+8
		Return Self._data.PeekDouble(Self._offset - 8)
	EndMethod
	
	rem
	bbdoc: Reads a string from the packet
	endrem
	Method ReadString:String()
		Local text:TStringBuilder = New TStringBuilder
		Local char:Byte
		Repeat
			char = Self.ReadByte()
			If char = 0 Then Return text.ToString()
			text.AppendChar(char)
		Forever
	EndMethod
EndType