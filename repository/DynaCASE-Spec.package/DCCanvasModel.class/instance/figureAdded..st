adding
figureAdded: aFigure
	aFigure class = RTElement
		ifTrue: [ self lastEvent ifNotNil: [ aFigure translateTo: self lastEvent position ] ].
	self addMenuFor: aFigure.
	self addMouseEventsFor: aFigure.
	self signalUpdate