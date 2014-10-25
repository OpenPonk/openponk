public - resizing
keepExtentOf: aShape like: anotherShape plus: aPoint
	| b |
	self changeExtentOf: aShape like: anotherShape plus: aPoint.
	b := [ :shape :step | self changeExtentOf: aShape like: anotherShape plus: aPoint ].
	aShape addCallback: (TRExtentCallback block: b).
	aShape addCallback: (TRTranslationCallback block: b)