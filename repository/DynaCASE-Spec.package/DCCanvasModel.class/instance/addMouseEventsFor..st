adding
addMouseEventsFor: aFigure
	aFigure
		when: TRMouseDoubleLeftClick
		do: [ :event | 
			self lastClickPosition: event position.
			self diagramController doubleClickFigure: event element ].
	aFigure
		when: TRMouseLeftClick
		do: [ :event | 
			self lastClickPosition: event position.
			self diagramController selectFigure: event element ].
	aFigure
		when: TRMouseEnter
		do: [ :event | 
			self lastClickPosition: event position.
			self diagramController hoverFigure: event element ].
	aFigure
		when: TRMouseLeave
		do: [ :event | 
			self lastClickPosition: event position.
			self diagramController hoverView ].
	aFigure
		when: TRMouseRightClick
		do: [ :event | 
			self lastClickPosition: event position.
			self diagramController selectFigure: event element ]