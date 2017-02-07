public - sticking
stick: aShape nearStartOfEdge: anEdge distance: aNumber offset: anotherNumber
	"keeps position of aShape against anEdge, with orthogonal offset distance from it and aNumber distance from start of the line"

	^ self new
		shape: aShape;
		edge: anEdge;
		nearStart;
		distance: aNumber;
		offset: anotherNumber;
		stick;
		yourself