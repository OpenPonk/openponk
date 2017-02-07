rendering
createLineToSelfFor: anEdge
	| radius right top topRight rect |
	radius := 30.
	rect := anEdge from encompassingRectangle.
	right := rect right @ rect center y + (radius @ 0).
	top := rect center x @ rect top - (0 @ radius)
		+ ((2 * (self attachPoint offsetNormalFor: anEdge) x) @ 0).
	topRight := right x @ top y.
	anEdge from
		addCallback: (TRTranslationCallback block: [ :s :step | self translateBy: step for: anEdge ]).
	self
		addPoint: right;
		addPoint: topRight;
		addPoint: top