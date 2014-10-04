public - sticking
stick: aShape betweenPointsOf: anEdge balance: aFloat aboveBy: anInteger
	| callback b |
	self
		move: aShape
		betweenPointsOf: anEdge
		balance: aFloat
		aboveBy: anInteger.
	b := [ :shape :step | 
	self
		move: aShape
		betweenPointsOf: anEdge
		balance: aFloat
		aboveBy: anInteger ].
	callback := TRTranslationCallback block: b.
	anEdge from trachelShape addCallback: callback.
	anEdge to trachelShape addCallback: callback.
	callback := TRExtentCallback block: b.
	anEdge from trachelShape addCallback: callback.
	anEdge to trachelShape addCallback: callback