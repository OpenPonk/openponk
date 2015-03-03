accessing
attachController: aDiagramController
	aDiagramController view: roassalView.
	aDiagramController whenFigureAdded: [ :figure | self figureAdded: figure ].
	diagramController := aDiagramController