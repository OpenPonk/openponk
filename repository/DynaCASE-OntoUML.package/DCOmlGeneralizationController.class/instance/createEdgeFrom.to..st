hooks
createEdgeFrom: fromFigure to: toFigure
	^ DCRTCallbackBuilder
		block: [ :view | 
			DCRTEdgeBuilder new
				emptyNarrowArrowHead;
				createFigureFrom: fromFigure to: toFigure view: view ]