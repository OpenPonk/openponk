accessing
p1: aPoint1 p2: aPoint2
	p1Handle := DCVisualCircle new
		radius: 15;
		center: aPoint1;
		container: self.
	p2Handle := DCVisualCircle new
		radius: 15;
		center: aPoint2;
		container: self.
	self width: (aPoint1 x - aPoint2 x) abs.
	self height: (aPoint1 y - aPoint2 y) abs.
	self addNode: p1Handle.
	self addNode: p2Handle.
"	self session announce: (DCVisualNodeAdded node: p1Handle).
	self session announce: (DCVisualNodeAdded node: p2Handle)"