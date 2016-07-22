adding
figureAdded: aFigure
	"Or rather things that can be #translateTo:-ed"
	(aFigure isKindOf: RTElement)
		ifTrue: [ aFigure translateTo: self lastClickPosition ].
	self addMenuFor: aFigure.
	self addMouseEventsFor: aFigure.
	self signalUpdate