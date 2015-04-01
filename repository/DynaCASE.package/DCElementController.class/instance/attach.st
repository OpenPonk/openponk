as yet unclassified
attach
	| newFigure |
	self registerModelEvents: model.
	newFigure := self figure.
	newFigure view ifNil: [ self diagramController view add: newFigure ].
	self diagramController figureAdded: newFigure.
	self refreshFigure