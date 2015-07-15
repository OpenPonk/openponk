actions
removeFigure
	self diagramController deselectAll.
	figure view
		ifNotNil: [ 
			figure remove.
			figure := nil ]