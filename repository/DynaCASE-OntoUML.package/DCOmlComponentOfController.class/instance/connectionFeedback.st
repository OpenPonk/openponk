hooks
connectionFeedback
	^ DCInteractiveLine new
		lineBuilder: [ :fromFigure :toFigure | 
					DCRTMultiLine new
						filledDiamondHead;
						edgeFrom: fromFigure to: toFigure ];
		from: source figure