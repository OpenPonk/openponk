accessing
figures: aCollection
	figures := aCollection.
	controllers := figures
		collect: [ :each | self diagramController controllerForFigure: each ]