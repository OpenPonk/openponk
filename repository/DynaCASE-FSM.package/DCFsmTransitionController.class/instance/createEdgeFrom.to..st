hooks
createEdgeFrom: fromElement to: toElement
	| builder label edge |
	^ DCRTCallbackBuilder
		block: [ :view | 
			builder := DCRTEdgeBuilder new.
			edge := builder createEdgeFrom: fromElement to: toElement.
			view add: edge.
			label := builder addLabelNamed: #name to: edge.
			builder constraint: label balance: 0.8 offset: 12.
			edge ]