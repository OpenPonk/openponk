hooks
refreshFigure
	(figure attributeAt: #RTLabelledLabel) text: self model name.
	figure update.
	figure view signalUpdate