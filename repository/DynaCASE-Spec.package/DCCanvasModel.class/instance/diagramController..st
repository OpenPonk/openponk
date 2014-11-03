accessing
diagramController: aDiagramController
	diagramController
		ifNotNil: [ 
			diagramController view: nil.
			diagramController whenFigureAdded: nil ].
	aDiagramController
		ifNotNil: [ 
			aDiagramController view: roassalView.
			aDiagramController whenFigureAdded: [ :figure | self figureAdded: figure ] ].
	diagramController := aDiagramController