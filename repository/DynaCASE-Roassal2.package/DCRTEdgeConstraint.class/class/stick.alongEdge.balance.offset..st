public - sticking
stick: aShape alongEdge: anEdge balance: aFloat offset: aNumber
	| moveBlock |
	moveBlock := [ 
	self
		move: aShape
		alongEdge: anEdge
		balance: aFloat
		offset: aNumber ].
	moveBlock value.
	self
		subscribeShape: aShape
		edge: anEdge
		whenDragOnce: [ self fix: aShape alongEdge: anEdge ]
		whenMove: moveBlock