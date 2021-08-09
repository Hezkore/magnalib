Import "wrap.base.bmx"

Type TLayoutStyleWrapVertical Extends TLayoutStyleWrapBase
	Method RecalculateChildren( children:TObjectList )
		Self.ResizeToParent( children, False )
		Self.CalculateWrap( children, False )
		Self.ResizeChildren( children, False )
		Self.PositionChildren( children, False )
		'Self.ResizeOverflow( children, False )
	EndMethod
EndType
