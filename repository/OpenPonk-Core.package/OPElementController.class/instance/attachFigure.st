events - registering
attachFigure
	"add figure to the view"

	| newFigure |
	newFigure := self figure.
	newFigure view ifNil: [ newFigure renderIn: self diagramController view ].
	self diagramController figureAdded: newFigure.
	self refreshFigure