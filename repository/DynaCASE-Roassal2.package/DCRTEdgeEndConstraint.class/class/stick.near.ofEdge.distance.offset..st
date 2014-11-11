public - sticking
stick: aShape near: origin ofEdge: anEdge distance: aNumber offset: anotherNumber
	^ self new
		shape: aShape;
		edge: anEdge;
		near: origin;
		distance: aNumber;
		offset: anotherNumber;
		stick;
		yourself