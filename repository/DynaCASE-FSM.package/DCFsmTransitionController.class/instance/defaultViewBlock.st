initialization
defaultViewBlock
	^ [ :fromVertex :toVertex | 
	| label |
	view := DCRTMultiLine edgeFrom: fromVertex to: toVertex.
	view shape color: Color black.
	view shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
	label := DCRTEdgeLabel new.
	label text: self model name.
	view + label.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			label text: newValue.
			view update.
			view view signalUpdate ].
	view ]