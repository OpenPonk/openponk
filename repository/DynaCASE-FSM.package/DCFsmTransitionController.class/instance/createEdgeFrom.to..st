hooks
createEdgeFrom: fromElement to: toElement
	| builder label edge |
	builder := DCRTRelationshipBuilder new.
	edge := builder createEdgeFrom: fromElement to: toElement.
	self parent view add: edge.
	label := builder addLabelTo: edge.
	builder constraint: label balance: 0.8 offset: 12.
	builder updateLabel: label whenChanged: self model nameHolder.
	^ edge