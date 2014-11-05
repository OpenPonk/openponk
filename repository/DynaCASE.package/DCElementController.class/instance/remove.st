actions
remove
	super remove.
	self parent deselectAll.
	figure view
		ifNotNil: [ 
			figure remove.
			figure := nil ]