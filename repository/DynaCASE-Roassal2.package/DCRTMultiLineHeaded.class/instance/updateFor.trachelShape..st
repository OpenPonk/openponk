public
updateFor: anEdge trachelShape: trachelShape
	| shape col fromPoint toPoint path |
	col := self colorFor: anEdge.
	fromPoint := attachPoint startingPointOf: anEdge.
	toPoint := attachPoint endingPointOf: anEdge.
	path := blockProducingPath value: fromPoint value: toPoint.
	head ifNotNil: [ head updateFor: anEdge trachelShape: trachelShape shapes last ].
	2 to: path size do: [ :i | 
		shape := trachelShape shapes at: i - 1.
		shape width: width.
		shape from: (path at: i - 1) to: (path at: i).
		shape color: col ].
	^ trachelShape