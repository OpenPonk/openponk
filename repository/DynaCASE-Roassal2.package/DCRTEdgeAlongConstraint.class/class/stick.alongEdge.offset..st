public - sticking
stick: aShape alongEdge: anEdge offset: aNumber
	^ self new
		shape: aShape;
		edge: anEdge;
		offset: aNumber;
		stick;
		yourself