public - sticking
fix: aShape nearEndOfEdge: anEdge
	"keeps current position of aShape against anEdge. Uses orthogonal distance from line and distance from end of the line along it"

	^ self new
		shape: aShape;
		edge: anEdge;
		nearEnd;
		fix;
		yourself