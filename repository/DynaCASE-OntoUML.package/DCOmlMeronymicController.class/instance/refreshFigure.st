hooks
refreshFigure
	figure view ifNil: [ ^ self ].
	figure remove.
	figure := nil.
	self parent figureAdded: self figure.
	super refreshFigure