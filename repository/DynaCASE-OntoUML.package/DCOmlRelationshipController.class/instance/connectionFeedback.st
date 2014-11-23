hooks
connectionFeedback
	^ DCInteractiveLine new
		lineBuilder: [ :fromFigure :toFigure | DCRTMultiLine new edgeFrom: fromFigure to: toFigure ];
		from: source figure