deprecated
registerModelEvents: aModel
	self deprecated: 'Use model: and internalSubscribeTo: instead.'.
"	super registerModelEvents: aModel.
	aModel
		when: OPElementChanged
		do: [ :event | 
			aModel owner isNotNil & figure isNotNil
				ifTrue: [ self refreshFigure ] ]"