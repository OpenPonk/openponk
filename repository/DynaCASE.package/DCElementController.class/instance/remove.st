actions
remove
	super remove.
	self diagramController deselectAll.
	figure view
		ifNotNil: [ 
			figure remove.
			figure := nil ]