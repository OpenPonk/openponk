as yet unclassified
createEdgeFrom: fromElement to: toElement
	| label callback edge |
	edge := DCRTMultiLineHeaded edgeFrom: fromElement to: toElement.
	edge shape color: Color black.
	edge shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
	label := TRLabelShape new
		color: Color black;
		text: self model name;
		yourself.
	self parent view canvas addShape: label.
	callback := TRRemoveCallback block: [ :shape | label remove ].
	edge trachelShape shapes first addCallback: callback.
	DCTRConstraint
		stick: label
		betweenPointsOf: edge
		balance: 0.8
		aboveBy: 12.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			label text: newValue.
			edge update.
			edge view signalUpdate ].
	^ edge