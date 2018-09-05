adding
hasModel: aModel view: aDiagramView
	^ controllers
		anySatisfy: [ :each | each model = aModel and: [ each diagramView = aDiagramView ] ]