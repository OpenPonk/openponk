hooks
connectionFeedback
	^ DCInteractiveLine new
		lineBuilder: [ :fromFigure :toFigure | 
					DCRTMultiLine new
						emptyDiamondHead;
						edgeFrom: fromFigure to: toFigure ];
		from: source figure