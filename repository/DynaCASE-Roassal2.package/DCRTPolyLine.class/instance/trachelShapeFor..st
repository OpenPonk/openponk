public
trachelShapeFor: anEdge
	| shape multiShape col fromPoint toPoint path |
	col := self colorFor: anEdge.
	fromPoint := attachPoint startingPointOf: anEdge.
	toPoint := attachPoint endingPointOf: anEdge.
	path := {fromPoint} , self points , {toPoint}.

	multiShape := TRCompositeShape new.
	2 to: path size do: [ :i | 
		shape := TRLineShape new.
		shape width: width.
		shape from: (path at: i - 1) to: (path at: i).
		shape color: col.

		multiShape addShape: shape ].
	^ multiShape