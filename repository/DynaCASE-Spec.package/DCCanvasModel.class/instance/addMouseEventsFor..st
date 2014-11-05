adding
addMouseEventsFor: aFigure
	aFigure when: TRMouseLeftClick do: [ :event | self diagramController selectFigure: event element ].
	aFigure when: TRMouseEnter do: [ :event | self diagramController hoverFigure: event element ].
	aFigure when: TRMouseLeave do: [ :event | self diagramController hoverView ].
	aFigure when: TRMouseRightClick do: [ :event | self diagramController selectFigure: event element ]