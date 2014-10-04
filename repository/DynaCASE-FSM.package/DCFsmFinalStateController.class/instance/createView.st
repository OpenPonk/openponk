initialization
createView
	| element label shape |
	element := RTElement new.
	shape := DCRoassalSmFinalState new
		size: 50;
		color: Color white;
		borderColor: Color black.
	label := RTLabel new
		height: 10;
		text: self model name.
	element + shape.
	element + label.
	element @ RTDraggable.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			label text: newValue.
			element update.
			element view signalUpdate ].
	^ element