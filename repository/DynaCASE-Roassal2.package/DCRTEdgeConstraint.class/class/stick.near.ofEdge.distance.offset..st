public - sticking
stick: aShape near: origin ofEdge: anEdge distance: aNumber offset: anotherNumber
	"possible origins: #start , #end"

	| moveBlock |
	moveBlock := [ 
	self
		move: aShape
		near: origin
		ofEdge: anEdge
		distance: aNumber
		offset: anotherNumber ].
	moveBlock value.
	self
		subscribeShape: aShape
		edge: anEdge
		whenDragOnce: [ self fix: aShape near: origin ofEdge: anEdge ]
		whenMove: moveBlock