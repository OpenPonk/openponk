public - moving
move: aShape alongEdge: anEdge offset: aNumber
	^ self new
		shape: aShape;
		edge: anEdge;
		offset: aNumber;
		move;
		yourself