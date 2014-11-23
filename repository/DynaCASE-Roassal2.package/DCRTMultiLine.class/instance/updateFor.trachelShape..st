public
updateFor: anEdge trachelShape: trachelShape
	| path col shape |
	path := self pathFor: anEdge.
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
				from: path allButLast last ].
	tail ifNotNil: [ tail updateFor: anEdge trachelShape: trachelShape shapes last from: path second ].
	^ trachelShape