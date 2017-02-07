public - sticking
stick: aShape alongEdge: anEdge balance: aFloat offset: aNumber
	"keeps position of aShape against anEdge, with orthogonal offset distance from it.
	balance = 0.5 => in the middle of line
	balance = 0 => on the starting point of line
	balance = 1 => on the ending point of line"

	^ self new
		shape: aShape;
		edge: anEdge;
		balance: aFloat;
		offset: aNumber;
		stick;
		yourself