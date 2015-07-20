actions
resetAction
	diagramController model elements
		do: [ :each | DCFsmFigureHighlighter unhighlight: (diagramController figureFor: each) ]