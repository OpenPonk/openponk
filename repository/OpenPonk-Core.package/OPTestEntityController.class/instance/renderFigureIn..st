construction
renderFigureIn: aView
	figure := RTBox new elementOn: self model.
	aView add: figure.
	self diagramController figureAdded: figure