public - sticking
fix: aShape nearEndOfEdge: anEdge
	^ self new
		shape: aShape;
		edge: anEdge;
		nearEnd;
		fix;
		yourself