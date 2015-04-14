events - registering
attachFigure
	"add figure to the view"

	| newFigure |
	newFigure := self figure.
	newFigure view ifNil: [ self diagramController view add: newFigure ].
	self diagramController figureAdded: newFigure.
	self refreshFigure