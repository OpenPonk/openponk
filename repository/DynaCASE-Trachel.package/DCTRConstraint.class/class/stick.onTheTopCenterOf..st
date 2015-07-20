public - sticking
stick: aShape onTheTopCenterOf: anotherShape
	| b |
	self move: aShape onTheTopCenterOf: anotherShape.

	b := [ :shape :step | self move: aShape onTheTopCenterOf: anotherShape ].
	anotherShape addCallback: (TRTranslationCallback block: b).
	anotherShape addCallback: (TRExtentCallback block: b)