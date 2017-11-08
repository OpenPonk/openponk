deprecated
attachFigure
	"add figure to the view"

	self deprecated: 'Use createInModel:andShowInDiagram: instead.'
	"
	| newFigure |
	newFigure := self figure.
	newFigure view ifNil: [ newFigure renderIn: self diagramController view ].
	self diagramController figureAdded: newFigure.
	self refreshFigure"