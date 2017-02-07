public - sticking
fix: aShape alongEdge: anEdge
	"keeps current position of aShape against anEdge. Uses orthogonal distance from line and proportional distance from middle of line along it"

	^ self new
		shape: aShape;
		edge: anEdge;
		fix;
		yourself