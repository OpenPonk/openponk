building
build
	| l |
	self
		add: (RTBox new size: 0) element;
		add: (RTBox new size: 0) element.
	l := RTEdge from: self first to: self second.
	l + (RTLine new color: Color black).
	self add: l