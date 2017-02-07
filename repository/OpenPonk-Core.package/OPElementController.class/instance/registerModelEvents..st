events - registering
registerModelEvents: aModel
	super registerModelEvents: aModel.
	aModel
		when: OPElementChanged
		do: [ :event | 
			aModel owner isNotNil & figure isNotNil
				ifTrue: [ self refreshFigure ] ]