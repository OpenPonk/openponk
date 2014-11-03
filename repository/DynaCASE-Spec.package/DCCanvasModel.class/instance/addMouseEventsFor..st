adding
addMouseEventsFor: aFigure
	aFigure when: TRMouseLeftClick do: [ :event | self diagramController selectViewElement: event element ].
	aFigure when: TRMouseEnter do: [ :event | self diagramController hoverViewElement: event element ].
	aFigure when: TRMouseLeave do: [ :event | self diagramController hoverView ]