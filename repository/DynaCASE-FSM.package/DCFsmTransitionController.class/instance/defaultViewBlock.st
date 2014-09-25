initialization
defaultViewBlock
	^ [ :fromVertex :toVertex | 
	| label callback |
	view := RTArrow edgeFrom: fromVertex to: toVertex.
"	view := DCRTMultiLine edgeFrom: fromVertex to: toVertex."
	view shape color: Color black.
	view shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
	label := TRLabelShape new
		color: Color black;
		text: self model name;
		yourself.
	self parent view canvas addShape: label.
	callback := TRRemoveCallback block: [ :shape | label remove ].
	view trachelShape shape1 addCallback: callback.
	TRConstraint
		stick: label
		between: view from trachelShape
		and: view to trachelShape
		offset: 0.7.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			label text: newValue.
			view update.
			view view signalUpdate ].
	view ]