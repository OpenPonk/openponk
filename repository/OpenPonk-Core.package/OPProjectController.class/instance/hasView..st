testing
hasView: aDiagramView
	^ controllers anySatisfy: [ :each | each diagramView = aDiagramView ]