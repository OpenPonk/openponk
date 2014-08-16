public
trachelShapeFor: anEdge
	| shape multiShape col fromPoint toPoint path headTrachelShape |
	col := self colorFor: anEdge.
	fromPoint := attachPoint startingPointOf: anEdge.
	toPoint := attachPoint endingPointOf: anEdge.
	path := blockProducingPath value: fromPoint value: toPoint.
	multiShape := TRMultiCompositeShape new.
	2 to: path size do: [ :i | 
		shape := TRLineShape new.
		shape width: width.
		shape from: (path at: i - 1) to: (path at: i).
		shape color: col.
		multiShape addShape: shape ].
	head
		ifNotNil: [ 
			head attachPoint: attachPoint.
			head color: col.
			headTrachelShape := head trachelShapeFor: anEdge.
			multiShape addShape: headTrachelShape ].
	^ multiShape