public - sticking
stick: aShape onTheTopRightOf: anotherShape
	| b |
	self move: aShape onTheTopRightOf: anotherShape.

	b := [ :shape :step | self move: aShape onTheTopRightOf: anotherShape ].
	anotherShape addCallback: (TRTranslationCallback block: b).
	anotherShape addCallback: (TRExtentCallback block: b)