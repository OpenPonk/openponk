canvas actions
hideSelectionFeedback
	self figure view
		ifNotNil: [ 
			self figure announce: DCTRUnfocused.
			self figure view signalUpdate ]