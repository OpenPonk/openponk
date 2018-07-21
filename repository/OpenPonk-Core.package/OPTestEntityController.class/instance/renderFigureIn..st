construction
renderFigureIn: aView
	figure := RTBox new size: 50; elementOn: self model.
	aView add: figure.
	self diagramController figureAdded: figure