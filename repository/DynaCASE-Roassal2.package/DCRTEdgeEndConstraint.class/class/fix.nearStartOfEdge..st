public - sticking
fix: aShape nearStartOfEdge: anEdge
	^ self new
		shape: aShape;
		edge: anEdge;
		nearStart;
		fix;
		yourself