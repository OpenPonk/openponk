public - moving
move: aShape nearEndOfEdge: anEdge distance: aNumber offset: anotherNumber
	^ self new
		shape: aShape;
		edge: anEdge;
		nearEnd;
		distance: aNumber;
		offset: anotherNumber;
		move;
		yourself