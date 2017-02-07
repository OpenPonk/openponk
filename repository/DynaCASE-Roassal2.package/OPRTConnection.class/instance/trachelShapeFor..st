rendering
trachelShapeFor: anEdge
	| shape multiShape path |
	path := self pathFor: anEdge.
	multiShape := TRCompositeShape new.
	path overlappingPairsDo: [ :a :b |
		shape := self lineSegmentFor: anEdge from: a to: b.
		multiShape addShape: shape ].
	^ multiShape