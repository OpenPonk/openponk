rendering
updateFor: anEdge trachelShape: trachelShape
	| shape col fromPoint toPoint path |
	self logCr: 'updateFor:trachelShape:.'.
	col := self colorFor: anEdge.
	fromPoint := attachPoint startingPointOf: anEdge.
	toPoint := attachPoint endingPointOf: anEdge.
	path := {fromPoint} , self points , {toPoint}.

	self addOrRemoveLinesFor: anEdge trachelShape: trachelShape.

	2 to: path size do: [ :i | 
		shape := trachelShape shapes at: i - 1.
		shape width: width.
		shape from: (path at: i - 1) to: (path at: i).
		shape color: col ].
	^ trachelShape