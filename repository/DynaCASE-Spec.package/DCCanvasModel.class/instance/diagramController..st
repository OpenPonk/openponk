accessing
diagramController: aDiagramController
	diagramController ifNotNil: [ diagramController view: nil ].
	aDiagramController ifNotNil: [ aDiagramController view: roassalView ].
	diagramController := aDiagramController