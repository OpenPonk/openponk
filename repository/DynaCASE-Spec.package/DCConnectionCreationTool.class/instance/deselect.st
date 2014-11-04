actions
deselect
	feedback value: nil.
	connectionFeedback
		ifNotNil: [ 
			connectionFeedback remove.
			connectionFeedback := nil ].
	connectionController := nil