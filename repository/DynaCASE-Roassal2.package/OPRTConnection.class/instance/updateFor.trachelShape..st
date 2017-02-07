rendering
updateFor: anEdge trachelShape: trachelShape
	| shape col path |
	col := self colorFor: anEdge.
	path := self pathFor: anEdge.

	self addOrRemoveLinesFor: anEdge trachelShape: trachelShape.

	2 to: path size do: [ :i | 
		shape := trachelShape shapes at: i - 1.
		shape width: (self widthFor: anEdge).
		shape from: (path at: i - 1) to: (path at: i).
		shape color: col ].
	^ trachelShape