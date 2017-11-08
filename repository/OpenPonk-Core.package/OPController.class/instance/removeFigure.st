destruction
removeFigure
	self diagramController deselectAll.
	self figure view ifNotNil: [ self figure remove ]