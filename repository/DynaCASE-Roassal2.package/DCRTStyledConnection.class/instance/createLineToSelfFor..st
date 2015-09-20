rendering
createLineToSelfFor: anEdge
	| radius  right top topRight rect  |
	radius := 30.
	rect := anEdge from encompassingRectangle.
	right := rect right @ rect center y + (radius @ 0).
	top := rect center x @ rect top - (-5 @ radius).
	topRight := right x @ top y.
	self
		addPoint: right;
		addPoint: topRight;
		addPoint: top