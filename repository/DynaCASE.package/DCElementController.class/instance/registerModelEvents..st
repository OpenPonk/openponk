events - registering
registerModelEvents: aModel
	super registerModelEvents: aModel.
	aModel
		when: DCElementChanged
		do: [ :event | 
			aModel owner isNotNil & figure isNotNil
				ifTrue: [ self refreshFigure ] ]