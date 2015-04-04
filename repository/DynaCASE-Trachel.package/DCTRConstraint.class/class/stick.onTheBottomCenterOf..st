public - sticking
stick: aShape onTheBottomCenterOf: anotherShape
	| b |
	self move: aShape onTheBottomCenterOf: anotherShape.

	b := [ :shape :step | self move: aShape onTheBottomCenterOf: anotherShape ].
	anotherShape addCallback: (TRTranslationCallback block: b).
	anotherShape addCallback: (TRExtentCallback block: b)