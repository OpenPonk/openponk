as yet unclassified
createEdgeFrom: fromElement to: toElement
	| label edge activation |
	edge := DCRTMultiLine new
		head: RTSimpleArrowHead new;
		edgeFrom: fromElement to: toElement.
	edge shape color: Color black.
	edge shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
	label := (RTLabel new
		color: self defaultColor;
		text: self model name;
		elementOn: edge) @ RTDraggable.
	self parent view add: label.
	edge trachelShape addCallback: (TRRemoveCallback new block: [ :shape | label remove ]).
	DCTRConstraint
		stick: label
		alongEdge: edge
		balance: 0.8
		aboveBy: 10.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			label shape text: newValue.
			label update.
			edge signalUpdate ].
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