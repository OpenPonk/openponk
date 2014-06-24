accessing
generateState: aState x: xPosition y: yPosition
	| stateLayout cell trio |
	stateLayout := DCSmLayoutState new.
	cell := 0 @ 0 corner: self cellSize.
	cell := cell translateBy: (xPosition * self cellSize x) @ (yPosition * self cellSize y).
	stateLayout boundingBox: cell.
	trio := DCTriad new
		model: aState;
		layout: stateLayout.
	^ trio