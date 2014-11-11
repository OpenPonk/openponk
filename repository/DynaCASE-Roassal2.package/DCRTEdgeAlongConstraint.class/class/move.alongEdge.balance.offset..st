public - moving
move: aShape alongEdge: anEdge balance: aFloat offset: aNumber
	^ self new
		shape: aShape;
		edge: anEdge;
		balance: aFloat;
		offset: aNumber;
		move;
		yourself