Import "stack.base.bmx"

Type TLayoutStyleStackVertical Extends TLayoutStyleStackBase
	Method RecalculateChildren( children:TObjectList )
		'Self.ResizeToParent( children, False )
		Self.ResizeChildren( children, False )
		'Self.ResizeOverflow( children, False )
		Self.PositionChildren( children, False )
	EndMethod
EndType
