hooks
refreshFigure
	figure view
		ifNotNil: [ 
			figure remove.
			figure := nil ].
	self figure update.
	self figure view signalUpdate.
	super refreshFigure