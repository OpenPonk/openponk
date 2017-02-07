accessing
attachController: aDiagramController
	(diagramController := aDiagramController)
		view: roassalView;
		whenFigureAdded: [ :figure | self figureAdded: figure ]