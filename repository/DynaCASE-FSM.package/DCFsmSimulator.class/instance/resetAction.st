actions
resetAction
	diagramController model elements
		select: #isVertex
		thenDo: [ :each | DCFsmFigureHighlighter unhighlightElement: (diagramController figureFor: each) ].
	diagramController model elements
		select: #isTransition
		thenDo: [ :each | DCFsmFigureHighlighter unhighlightEdge: (diagramController figureFor: each) ]