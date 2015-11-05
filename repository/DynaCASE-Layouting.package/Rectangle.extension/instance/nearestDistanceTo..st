*DynaCASE-Layouting
nearestDistanceTo: anotherRectangle
	| line this that |
	line := RTLineSegment from: self center to: anotherRectangle center.
	this := (line intersectRectangle: self) anyOne.
	that := (line intersectRectangle: anotherRectangle) anyOne.
	^ this dist: that