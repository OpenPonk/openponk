public
updateFor: anEdge trachelShape: trachelShape
	| fromPoint toPoint path col shape |
	self checkLineToSelfFor: anEdge.
	fromPoint := attachPoint startingPointOf: anEdge.
	toPoint := attachPoint endingPointOf: anEdge.
	path := blockProducingPath value: fromPoint value: toPoint.
	col := self colorFor: anEdge.
	2 to: path size do: [ :i | 
		shape := trachelShape shapes at: i - 1.
		shape width: width.
		shape from: (path at: i - 1) to: (path at: i).
		shape color: col ].
	head
		ifNotNil: [ 
			head
				updateFor: anEdge
				trachelShape: (trachelShape shapes at: trachelShape shapes size - (tail ifNil: [ 0 ] ifNotNil: [ 1 ]))
				from: (path at: path size - 1) ].
	tail ifNotNil: [ tail updateFor: anEdge trachelShape: trachelShape shapes last from: path second ].
	^ trachelShape