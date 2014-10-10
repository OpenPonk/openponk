building
build
	| l |
	self add: (RTBox new extent: 0 @ 0) element.
	self add: (RTBox new extent: 0 @ 0) element.
	l := RTEdge from: self first to: self second.
	l + (RTLine new color: Color black).
	self add: l