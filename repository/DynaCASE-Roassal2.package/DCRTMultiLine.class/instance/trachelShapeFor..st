public
trachelShapeFor: anEdge
	| multiShape |
	multiShape := super trachelShapeFor: anEdge.
	head ifNotNil: [ multiShape addShape: (head trachelShapeFor: anEdge) ].
	^ multiShape