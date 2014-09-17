initialization
defaultViewBlock
	^ [ :fromVertex :toVertex | 
	| label callback sourceLabel targetLabel |
	view := DCRTMultiLine edgeFrom: fromVertex to: toVertex.
	view shape color: Color black.
	view shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
	label := TRLabelShape new
		color: Color black;
		text: self model name;
		yourself.
	sourceLabel := TRLabelShape new
		color: Color black;
		text: self model sourceName;
		yourself.
	targetLabel := TRLabelShape new
		color: Color black;
		text: self model targetName;
		yourself.
	self parent view canvas
		addShape: label;
		addShape: sourceLabel;
		addShape: targetLabel.
	callback := TRRemoveCallback
		block: [ :shape | 
			label remove.
			sourceLabel remove.
			targetLabel remove ].
	view trachelShape shapes first addCallback: callback.
	TRConstraint
		stick: label
		between: view from trachelShape
		and: view to trachelShape
		offset: 0.5.
	TRConstraint
		stick: sourceLabel
		between: view from trachelShape
		and: view to trachelShape
		offset: 0.2.
	TRConstraint
		stick: targetLabel
		between: view from trachelShape
		and: view to trachelShape
		offset: 0.8.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			label text: newValue.
			view update.
			view view signalUpdate ].
	self model sourceNameHolder
		whenChangedDo: [ :newValue | 
			sourceLabel text: newValue.
			view update.
			view view signalUpdate ].
	self model targetNameHolder
		whenChangedDo: [ :newValue | 
			targetLabel text: newValue.
			view update.
			view view signalUpdate ].
	view ]