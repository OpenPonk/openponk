initialization
createEdgeFrom: fromElement to: toElement
	| edge label sourceLabel targetLabel createLabel activation |
	edge := DCRTMultiLine new
		head: RTSimpleArrowHead new;
		edgeFrom: fromElement to: toElement.
	edge shape color: Color black.
	edge shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
	createLabel := [ :text | 
	(RTLabel new
		color: self defaultColor;
		height: 10;
		text: text;
		elementOn: edge) @ RTDraggable ].
	label := createLabel value: self model name.
	sourceLabel := createLabel value: self model sourceName.
	targetLabel := createLabel value: self model targetName.
	self parent view
		add: label;
		add: sourceLabel;
		add: targetLabel.
	edge trachelShape shapes first
		addCallback:
			(TRRemoveCallback
				block: [ :shape | 
					label remove.
					sourceLabel remove.
					targetLabel remove ]).
	DCTRConstraint
		stick: label
		alongEdge: edge
		balance: 0.5
		aboveBy: 12.
	DCTRConstraint
		stick: sourceLabel
		alongEdge: edge
		balance: 0.2
		aboveBy: -12.
	DCTRConstraint
		stick: targetLabel
		alongEdge: edge
		balance: 0.8
		aboveBy: -12.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			label shape text: newValue.
			label update.
			edge view signalUpdate ].
	self model sourceNameHolder
		whenChangedDo: [ :newValue | 
			sourceLabel shape text: newValue.
			sourceLabel update.
			edge view signalUpdate ].
	self model targetNameHolder
		whenChangedDo: [ :newValue | 
			targetLabel shape text: newValue.
			targetLabel update.
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