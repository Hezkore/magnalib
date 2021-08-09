Import "wrap.base.bmx"

Type TLayoutStyleWrapHorizontal Extends TLayoutStyleWrapBase
	Method RecalculateChildren( children:TObjectList )
		Self.ResizeToParent( children, True )
		Self.CalculateWrap( children, True )
		Self.ResizeChildren( children, True )
		Self.PositionChildren( children, True )
		'Self.ResizeOverflow( children, True )
	EndMethod
EndType
