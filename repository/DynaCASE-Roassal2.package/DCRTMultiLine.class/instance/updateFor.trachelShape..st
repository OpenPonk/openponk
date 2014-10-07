public
updateFor: anEdge trachelShape: trachelShape
	| shape |
	shape := super updateFor: anEdge trachelShape: trachelShape.
	head ifNotNil: [ head updateFor: anEdge trachelShape: shape shapes last ].
	^ shape