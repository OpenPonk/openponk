figures
createEdgeFrom: fromElement to: toElement
	^ DCRTCallbackBuilder
		block: [ :view | 
			| fig |
			fig := self edgeBuilder createFigureFrom: fromElement to: toElement view: view.
			fig @ DCRTLineHandles.
			fig ]