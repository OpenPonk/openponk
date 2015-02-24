public
updateFor: anEdge trachelShape: trachelShape
	| path col shape |
	path := self pathFor: anEdge.
	col := self colorFor: anEdge.
	2 to: path size do: [ :i | 
		shape := trachelShape shapes at: i - 1.
		shape
			width: width;
			from: (path at: i - 1) to: (path at: i);
			color: col ].
	head updateFor: anEdge trachelShape: trachelShape shapes allButLast last from: path allButLast last.
	tail updateFor: anEdge trachelShape: trachelShape shapes last from: path second.
	trachelShape canvas ifNotNil: [ trachelShape pushFront ].
	^ trachelShape