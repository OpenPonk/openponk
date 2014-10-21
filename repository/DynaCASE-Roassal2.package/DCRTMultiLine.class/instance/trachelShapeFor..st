public
trachelShapeFor: anEdge
	| multiShape col fromPoint toPoint path |
	col := self colorFor: anEdge.
	fromPoint := attachPoint startingPointOf: anEdge.
	toPoint := attachPoint endingPointOf: anEdge.
	path := blockProducingPath value: fromPoint value: toPoint.
	multiShape := TRMultiCompositeShape new.
	2 to: path size do: [ :i | 
		multiShape
			addShape:
				(DCTRStyledLineShape new
					dashes: dashes;
					width: width;
					from: (path at: i - 1) to: (path at: i);
					color: col) ].
	head ifNotNil: [ multiShape addShape: (head trachelShapeFor: anEdge) ].
	^ multiShape