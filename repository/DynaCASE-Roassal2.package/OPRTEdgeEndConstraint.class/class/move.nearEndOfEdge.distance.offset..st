public - moving
move: aShape nearEndOfEdge: anEdge distance: aNumber offset: anotherNumber
	"changes position of aShape against anEdge, with orthogonal offset distance from it and aNumber distance from end of the line"

	^ self new
		shape: aShape;
		edge: anEdge;
		nearEnd;
		distance: aNumber;
		offset: anotherNumber;
		move;
		yourself