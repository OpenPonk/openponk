public
updateFor: anEdge trachelShape: trachelShape
	self checkLineToSelfFor: anEdge.
	super updateFor: anEdge trachelShape: trachelShape.
	head ifNotNil: [ head updateFor: anEdge trachelShape: trachelShape shapes last ].
	^ trachelShape