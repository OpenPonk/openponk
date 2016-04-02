actions
translateTo: aPosition
	| center |
	center := self encompassingRectangle center.
	self translateBy: (aPosition - center)