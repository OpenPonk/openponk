initialization
defaultViewBlock
	^ [ :fromVertex :toVertex | 
	| label callback |
	view := DCRTMultiLineArrowed edgeFrom: fromVertex to: toVertex.
	view shape color: Color black.
	view shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
	label := TRLabelShape new
		color: Color black;
		text: self model name;
		yourself.
	self parent view canvas
		addShape: label.
	callback := TRRemoveCallback
		block: [ :shape | 
			label remove.].
	view trachelShape shapes first addCallback: callback.
	DCTRConstraint
		stick: label
		betweenPointsOf: view
		balance: 0.5
		aboveBy: 12.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			label text: newValue.
			view update.
			view view signalUpdate ].
	view ]