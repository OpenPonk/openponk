hooks
createEdgeFrom: fromElement to: toElement
	^ OPRTCallbackBuilder block: [ :view | self edgeBuilder createFigureFrom: fromElement to: toElement view: view ]