hooks
createEdgeFrom: fromElement to: toElement
	^ DCRTCallbackBuilder block: [ :view | self edgeBuilder createFigureFrom: fromElement to: toElement view: view ]