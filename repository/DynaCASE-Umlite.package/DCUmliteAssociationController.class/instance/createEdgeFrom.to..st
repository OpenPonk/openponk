hooks
createEdgeFrom: fromElement to: toElement
	"	| builder edge label sourceLabel targetLabel |
	DCRTCallbackBuilder
		block: [ :view | 
			builder := DCRTRelationshipBuilder new.
			edge := builder createEdgeFrom: fromElement to: toElement.
			view add: edge.
			label := builder addLabelTo: edge.
			builder constraint: label balance: 0.5 offset: 12.
			sourceLabel := builder addLabelTo: edge.
			builder constraint: sourceLabel toTargetDistance: 60 offset: -12.
			targetLabel := builder addLabelTo: edge.
			builder constraint: targetLabel toSourceDistance: 60 offset: -12.
			edge ]."

	| builder edge label sourceLabel targetLabel |
	builder := DCRTRelationshipBuilder new.
	edge := builder createEdgeFrom: fromElement to: toElement.
	self parent view add: edge.
	label := builder addLabelTo: edge.
	builder constraint: label balance: 0.5 offset: 12.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			label shape text: (self convertName: self model name).
			label update.
			label model signalUpdate ].
	label shape text: (self convertName: self model name).
	label update.
	sourceLabel := builder addLabelTo: edge.
	builder constraint: sourceLabel toTargetDistance: 60 offset: -12.
	builder updateLabel: sourceLabel whenChanged: self model sourceNameHolder.
	targetLabel := builder addLabelTo: edge.
	builder constraint: targetLabel toSourceDistance: 60 offset: -12.
	builder updateLabel: targetLabel whenChanged: self model targetNameHolder.
	^ edge