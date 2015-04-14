public
trachelShapeFor: anEdge
	| shape multiShape path |
	path := self pathFor: anEdge.
	multiShape := TRCompositeShape new.
	2 to: path size do: [ :i | 
		shape := self lineSegmentFor: anEdge from: (path at: i - 1) to: (path at: i).
		multiShape addShape: shape ].
	^ multiShape