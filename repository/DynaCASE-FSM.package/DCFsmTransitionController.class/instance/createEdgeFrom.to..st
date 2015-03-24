hooks
createEdgeFrom: fromElement to: toElement
	^ DCRTCallbackBuilder
		block: [ :view | 
			DCRTEdgeBuilder new
				arrowHead;
				constraintLabel: #name balance: 0.8 offset: 12;
				createFigureFrom: fromElement to: toElement view: view ]