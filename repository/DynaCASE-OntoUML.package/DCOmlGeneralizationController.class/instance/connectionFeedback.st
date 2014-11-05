hooks
connectionFeedback
	^ DCInteractiveLine new
		lineBuilder: [ :fromFigure :toFigure | 
					DCRTMultiLine new
						emptyArrowHead;
						edgeFrom: fromFigure to: toFigure ];
		from: source figure