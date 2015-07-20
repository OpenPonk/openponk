figures
createEdgeFrom: fromElement to: toElement
	fromElement = toElement
		ifTrue: [ ^ DCRTCallbackBuilder block: [ :view | self createEdgeFor: fromElement inView: view ] ]
		ifFalse: [ ^ DCRTCallbackBuilder block: [ :view | self edgeBuilder createFigureFrom: fromElement to: toElement view: view ] ]