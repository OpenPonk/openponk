public
updateFor: anEdge trachelShape: trachelShape
	| path |
	super updateFor: anEdge trachelShape: trachelShape.
	self changeDecorationsFor: anEdge trachelShape: trachelShape.
	path := self pathFor: anEdge.
	decorations head
		updateFor: anEdge
		trachelShape: trachelShape shapes allButLast last
		from: path allButLast last.
	decorations tail updateFor: anEdge trachelShape: trachelShape shapes last from: path second.
	trachelShape canvas ifNotNil: [ trachelShape pushFront ].
	^ trachelShape