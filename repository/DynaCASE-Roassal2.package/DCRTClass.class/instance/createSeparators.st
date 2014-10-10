private
createSeparators
	| l |
	separatorGroup := RTGroup new.
	separatorGroup
		add: (RTBox new extent: 0 @ 0) element;
		add: (RTBox new extent: 0 @ 0) element.
	l := RTEdge from: separatorGroup first to: separatorGroup second.
	l + (RTLine new color: Color black).
	separatorGroup add: l.
	^ separatorGroup