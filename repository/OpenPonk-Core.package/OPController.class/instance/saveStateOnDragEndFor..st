figures
saveStateOnDragEndFor: aFigure
	aFigure when: TRMouseDragEnd do: [ :evt | self diagramController saveState ]