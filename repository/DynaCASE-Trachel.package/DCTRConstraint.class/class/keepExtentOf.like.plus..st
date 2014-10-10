public - sticking
keepExtentOf: aShape like: anotherShape plus: aPoint
	| callback b |
	self changeExtentOf: aShape like: anotherShape plus: aPoint.
	b := [ :shape :step | self changeExtentOf: aShape like: anotherShape plus: aPoint ].
	callback := TRExtentCallback block: b.
	aShape trachelShape addCallback: callback