hooks
connectionFeedback
	^ DCInteractiveLine new
		lineBuilder: [ :fromFigure :toFigure | 
					DCRTMultiLine new
						arrowHead;
						edgeFrom: fromFigure to: toFigure ];
		from: source figure