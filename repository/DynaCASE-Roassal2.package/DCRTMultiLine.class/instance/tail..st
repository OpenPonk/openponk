accessing
tail: aLineDecorationShape
	(tail := aLineDecorationShape) ifNotNil: [ attachPoint ifNotNil: [ tail attachPoint: attachPoint ] ].
	self color: color