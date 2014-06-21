accessing
p1: aPoint1 p2: aPoint2
	p1 := aPoint1.
	p2 := aPoint2.
	self width: (p1 x - p2 x) abs.
	self height: (p1 y - p2 y) abs