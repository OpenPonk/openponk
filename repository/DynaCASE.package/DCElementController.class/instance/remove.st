actions
remove
	super remove.
	view view
		ifNotNil: [ 
			self hideSelectionFeedback.
			view remove.
			view := nil ]