canvas actions
hideSelectionFeedback
	self view view
		ifNotNil: [ 
			self view announce: DCTRUnfocused.
			self view view signalUpdate ]