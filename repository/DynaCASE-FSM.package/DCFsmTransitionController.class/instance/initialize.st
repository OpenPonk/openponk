initialization
initialize
	viewBlock := [ :fromVertex :toVertex | 
	| shape |
	view := RTEdge from: fromVertex to: toVertex.
	shape := RTMultiLine new color: Color black.
	view + shape ]