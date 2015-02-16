public - sticking
fix: aShape nearStartOfEdge: anEdge
	"keeps current position of aShape against anEdge. Uses orthogonal distance from line and distance from start of the line along it"

	^ self new
		shape: aShape;
		edge: anEdge;
		nearStart;
		fix;
		yourself