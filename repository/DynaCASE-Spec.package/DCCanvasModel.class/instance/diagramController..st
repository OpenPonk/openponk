accessing
diagramController: aDiagramController
	diagramController ifNotNil: [ self detachDiagramController ].
	diagramController := aDiagramController