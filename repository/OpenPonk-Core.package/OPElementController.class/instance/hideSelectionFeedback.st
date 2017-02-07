canvas actions
hideSelectionFeedback
	self figure view
		ifNotNil: [ 
			self figure announce: OPTRUnfocused.
			self figure view signalUpdate ]