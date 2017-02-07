public - moving
move: aShape alongEdge: anEdge offset: aNumber
	"changes position of aShape against anEdge, in the middle of edge, with orthogonal offset distance from it"

	^ self new
		shape: aShape;
		edge: anEdge;
		offset: aNumber;
		move;
		yourself