actions
remove
	super remove.
	self parent deselectAll.
	view view
		ifNotNil: [ 
			view remove.
			view := nil ]