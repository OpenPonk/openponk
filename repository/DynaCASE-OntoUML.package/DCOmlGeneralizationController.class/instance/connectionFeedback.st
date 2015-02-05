hooks
connectionFeedback
	^ DCInteractiveLine new
		lineBuilder: [ :fromFigure :toFigure | 
					DCRTMultiLine new
						emptyNarrowArrowHead;
						edgeFrom: fromFigure to: toFigure ];
		from: source figure