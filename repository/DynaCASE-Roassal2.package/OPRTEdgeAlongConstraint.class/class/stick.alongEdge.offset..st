public - sticking
stick: aShape alongEdge: anEdge offset: aNumber
	"keeps position of aShape against anEdge, in the middle of edge, with orthogonal offset distance from it"

	^ self new
		shape: aShape;
		edge: anEdge;
		offset: aNumber;
		stick;
		yourself