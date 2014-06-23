accessing
resetBounds
	self position: (self p1 x min: self p2 x) @ (self p1 y min: self p2 y).
	self width: (self p1 x - self p2 x) abs.
	self height: (self p1 y - self p2 y) abs