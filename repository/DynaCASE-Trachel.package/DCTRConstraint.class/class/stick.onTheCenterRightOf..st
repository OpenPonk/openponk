public - sticking
stick: aShape onTheCenterRightOf: anotherShape
	| b |
	self move: aShape onTheTopCenterOf: anotherShape.

	b := [ :shape :step | self move: aShape onTheCenterRightOf: anotherShape ].
	anotherShape addCallback: (TRTranslationCallback block: b).
	anotherShape addCallback: (TRExtentCallback block: b)