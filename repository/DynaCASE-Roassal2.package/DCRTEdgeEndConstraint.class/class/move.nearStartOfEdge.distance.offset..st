public - moving
move: aShape nearStartOfEdge: anEdge distance: aNumber offset: anotherNumber
	^ self new
		shape: aShape;
		edge: anEdge;
		nearStart;
		distance: aNumber;
		offset: anotherNumber;
		move;
		yourself