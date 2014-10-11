initialization
createEdgeFrom: fromElement to: toElement
	| edge label callback sourceLabel targetLabel createLabel |
	edge := DCRTMultiLine edgeFrom: fromElement to: toElement.
	edge shape color: Color black.
	edge shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
	createLabel := [ :text | 
	TRLabelShape new
		color: Color black;
		fontSize: 10;
		text: text;
		yourself ].
	label := createLabel value: self model name.
	sourceLabel := createLabel value: self model sourceName.
	targetLabel := createLabel value: self model targetName.
	self parent view canvas
		addShape: label;
		addShape: sourceLabel;
		addShape: targetLabel.
	callback := TRRemoveCallback
		block: [ :shape | 
			label remove.
			sourceLabel remove.
			targetLabel remove ].
	edge trachelShape shapes first addCallback: callback.
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
			label text: newValue.
			edge update.
			edge view signalUpdate ].
	self model sourceNameHolder
		whenChangedDo: [ :newValue | 
			sourceLabel text: newValue.
			edge update.
			edge view signalUpdate ].
	self model targetNameHolder
		whenChangedDo: [ :newValue | 
			targetLabel text: newValue.
			edge update.
			edge view signalUpdate ].
	^ edge