public - sticking
stick: aShape nearEndOfEdge: anEdge distance: aNumber offset: anotherNumber
	^ self new
		shape: aShape;
		edge: anEdge;
		nearEnd;
		distance: aNumber;
		offset: anotherNumber;
		stick;
		yourself