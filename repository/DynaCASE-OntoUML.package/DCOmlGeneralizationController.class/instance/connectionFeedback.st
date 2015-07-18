hooks
connectionFeedback
	^ DCInteractiveLine new
		lineBuilder: [ :fromFigure :toFigure | 
					DCRTStyledMultiLine new
						emptyNarrowArrowHead;
						edgeFrom: fromFigure to: toFigure ];
		from: source figure