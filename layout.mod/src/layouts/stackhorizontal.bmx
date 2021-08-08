Import "stack.base.bmx"

Type TLayoutStyleStackHorizontal Extends TLayoutStyleStackBase
	Method RecalculateChildren( children:TObjectList )
		Self.ResizeToParent( children, True )
		Self.ResizeChildren( children, True )
		Self.ResizeOversize( children, True )
		Self.PositionChildren( children, True )
	EndMethod
EndType
