adding
figureAdded: aFigure
	"Only elements can be translated, not edges."
	(aFigure isElement)
		ifTrue: [ aFigure translateTo: self lastClickPosition ].
	self addMouseEventsFor: aFigure.
	self addMenuFor: aFigure.
	self signalUpdate