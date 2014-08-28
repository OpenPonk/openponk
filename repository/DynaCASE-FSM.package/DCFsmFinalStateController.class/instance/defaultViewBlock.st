initialization
defaultViewBlock
	^ [ 
	| label shape |
	view := RTElement new.
	shape := DCRoassalSmFinalState new
		size: 50;
		color: Color white;
		borderColor: Color black.
	label := RTLabel new
		height: 10;
		text: self model name.
	view + shape.
	view + label.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			label text: newValue.
			view update.
			view view signalUpdate ].
	view ]