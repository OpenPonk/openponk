as yet unclassified
createEdgeFrom: fromElement to: toElement
	| label callback edge activation |
	edge := DCRTMultiLine edgeFrom: fromElement to: toElement.
	edge shape color: Color black.
	edge shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
	label := TRLabelShape new
		color: self defaultColor;
		text: self model name;
		yourself.
	self parent view canvas addShape: label.
	callback := TRRemoveCallback new block: [ :shape | label remove ].
	edge trachelShape addCallback: callback.
	DCTRConstraint
		stick: label
		alongEdge: edge
		balance: 0.8
		aboveBy: 10.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			label text: newValue.
			edge update.
			edge view signalUpdate ].
	edge @ (activation := DCRTActivableWithColor new).
	activation
		activateWhen: TRMouseEnter
			deactivateWhen: TRMouseLeave
			priority: 10
			value: Color gray;
		activateWhen: DCTRSelectedEvent
			deactivateWhen: DCTRUnselectedEvent
			priority: 20
			value: Color blue.
	^ edge