public - sticking
stick: aShape nearEndOfEdge: anEdge distance: aNumber offset: anotherNumber
	"keeps position of aShape against anEdge, with orthogonal offset distance from it and aNumber distance from end of the line"

	^ self new
		shape: aShape;
		edge: anEdge;
		nearEnd;
		distance: aNumber;
		offset: anotherNumber;
		stick;
		yourself