as yet unclassified
remove
	super remove.
	view view
		ifNotNil: [ 
			view remove.
			view := nil ]