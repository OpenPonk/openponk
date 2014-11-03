actions
deselect
	self removeFeedback.
	connectionFeedback
		ifNotNil: [ 
			connectionFeedback remove.
			connectionFeedback := nil ]